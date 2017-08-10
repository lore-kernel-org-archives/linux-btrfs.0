Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38442 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752091AbdHJOtJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 10:49:09 -0400
Received: by mail-wm0-f43.google.com with SMTP id f15so24646022wmg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Aug 2017 07:49:08 -0700 (PDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com. [74.125.82.44])
        by smtp.gmail.com with ESMTPSA id e9sm3881674eda.52.2017.08.10.07.49.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Aug 2017 07:49:06 -0700 (PDT)
Received: by mail-wm0-f44.google.com with SMTP id t201so21691029wmt.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Aug 2017 07:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJM9R-JCUkVXg+BAY4ri_w8f39xS0QqMYHv2j6ck_3tpH+3Mxw@mail.gmail.com>
References: <CAJM9R-JxTptrU6GZzrMwvugpOqsmhu09Q8RAcA+TviOaK1RY4Q@mail.gmail.com>
 <c9fbfedd-1a3b-b6f4-8773-1a7e5f79f18a@suse.com> <1d36851e-6a1c-1c32-ee00-96f43ead55d2@suse.com>
 <CAJM9R-+=ww-7Zz9rgsGuCmiPZFZ+U8zhLHA4bEuzNederH49OQ@mail.gmail.com>
 <0bea5669-f6de-b14b-4e40-15f144a60976@suse.com> <CAJM9R-JCUkVXg+BAY4ri_w8f39xS0QqMYHv2j6ck_3tpH+3Mxw@mail.gmail.com>
From: Angel Shtilianov <kernel@kyup.com>
Date: Thu, 10 Aug 2017 17:49:05 +0300
Message-ID: <CAJM9R-Kr9Oo4YTC2La_ih4qqZu_0JhXZ-EZm+HCq6KEAerRAwg@mail.gmail.com>
Subject: Re: Btrfs umount hang
To: Angel Shtilianov <kernel@kyup.com>
Cc: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="001a114b09a45dfad30556674cd6"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a114b09a45dfad30556674cd6
Content-Type: text/plain; charset="UTF-8"

Here is a fresh snapshot hang example:

Here kworker/u24:0 is blocked waiting on btrfs_tree_read_lock.
And again underlaying is btrfs_search_slot after it has gone through
cache_block_group.
The other two has blocked on the same place in cache_block_group. So I
can confirm it is hanging the same way as with umount.
Here is the struct extent_buffer passed to btrfs_tree_read_lock for
kworker/u24:0:
struct extent_buffer {
...
  lock_owner = 23286,
  write_locks = {
    counter = 1
  },
  read_locks = {
    counter = 0
  },
  blocking_writers = {
    counter = 1
  },
..
}
So again the ioctl has taken the lock needed for its underlying operation.
Btrfs pid 23286 is going to perform a write, so it can't skip locking,
and not just read locking, but write locking.
The fact that it owns the wr lock is good. skip_locking in its
btrfs_path struct is zero, so till here it is fine and locked. The
problem rises later, if cache isnt available. Then we are about to try
to do cache_block_group. Even if it is not going to hang on the
wait in the beginning in the cache_block_group function (as in current case):
while (cache->cached == BTRFS_CACHE_FAST) {
                struct btrfs_caching_control *ctl;

                ctl = cache->caching_ctl;
                atomic_inc(&ctl->count);
                prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
                spin_unlock(&cache->lock);

>                schedule();

                finish_wait(&ctl->wait, &wait);
                put_caching_control(ctl);
                spin_lock(&cache->lock);
        }
it seems that there is high chance to hang later on
btrfs_tree_read_lock even if there is absolutely no concurrent work
going on by calling:
cache_block_group
 ->load_free_space_cache
   ->lookup_free_space_inode
     ->__lookup_free_space_inode
       ->btrfs_search_slot
         ->btrfs_read_lock_root_node
           ->btrfs_tree_read_lock
since we are already holding the write lock.
It looks like if we call cache_block_group at find_free_extent under
call via btrfs_search_slot we are about to get deadlocked too in case
the data isn't cached.

It looks scary. I hope that I've missed something.

Best regards,
Angel

On Thu, Aug 10, 2017 at 1:30 AM, Angel Shtilianov <kernel@kyup.com> wrote:
> Hi Jeff,
> That's exactly what I am observing in the backtraces.
> umount reaches cache_block_group passing through btrfs_search_slot,
> which looks like got the wr_lock (to be confirmed tomorrow when I'm in
> the office) and all other btrfs worker threads are fighting for the
> btrfs_tree_read_lock.
> Umount is hanging on the cache_block_group wait, all others are
> hanging on the read_lock. So caching seems to be the bottleneck,
> blocking all others. Good catch! I'll take a look at the commit
> tomorrow morning (with large cup of coffee of course).
>
> By the way, looking through the logs I can see one more pattern -
> umount after drop snapshot reaches similar state. The common is that
> drop snapshot will also call search slot, get the readlock, drop it
> and get the write lock. In the same time there is umount causing
> fs_sync going concurently. I've seen at least three such hangs today
> and I've started the corresponding crashdumps to get copied to my
> machine. Tomorrow I'll take a look at them. It seems the common is
> that umount again reaches to the same place - cache_block_group and
> hangs. Tomorrow I'll take a look at the crash dump for the workers
> state.
>
> Thank you,
> Angel
>
> On Wed, Aug 9, 2017 at 6:42 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>> On 8/8/17 7:30 AM, Angel Shtilianov wrote:
>>> crash> bt -f 31625
>>> PID: 31625  TASK: ffff88046a833400  CPU: 7   COMMAND: "btrfs-transacti"
>>> wants to acquire struct extent_buffer ffff88000460aca0 lock, whose
>>> lock_owner is 27574.
>>>
>>> here is pid 27574:
>>> PID: 27574  TASK: ffff88038b469a00  CPU: 4   COMMAND: "kworker/u32:9"
>>> which is also is trying to acquire eb lock ffff8802598b6200, and here
>>> the owner is 31696.
>>>
>>> 31696 is
>>> PID: 31696  TASK: ffff88044b59ce00  CPU: 5   COMMAND: "umount"
>>>
>>> So definitely here is a kind of deadlock.
>>> umount holds the lock needed by the workers to complete and waits them
>>> to complete.
>>> Lockdep wouldn't complain about that.
>>> I am still about to investigate what has previously triggered/disabled lockdep.
>>> I have to obtain the log from the machine, but I need some time to get it.
>>>
>>> Jeff, you were right.
>>> Could you help demystifying how we ended up here?
>>
>> Hi Angel -
>>
>> It looks like a regression introduced by 291c7d2f5, but that's a very
>> old commit.  As that commit says, it's a rare occurence to hit that
>> wait, and that's probably why we haven't seen this issue sooner.
>>
>> There's potential for this to happen whenever two threads are modifying
>> the tree at once and one needs to find a free extent.  I'll need to
>> think a bit on how to fix it.
>>
>> -Jeff
>>
>>> Best regards,
>>> Angel
>>>
>>> On Mon, Aug 7, 2017 at 9:10 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>>> On 8/7/17 1:19 PM, Jeff Mahoney wrote:
>>>>> On 8/7/17 10:12 AM, Angel Shtilianov wrote:
>>>>>> Hi there,
>>>>>> I'm investigating sporadic hanging during btrfs umount. The FS is
>>>>>> contained in a loop mounted file.
>>>>>> I have no reproduction scenario and the issue may happen once a day or
>>>>>> once a month. It is rare, but frustrating.
>>>>>> I have a crashdump (the server has been manually crashed and collected
>>>>>> a crashdump), so I could take look through the data structures.
>>>>>> What happens is that umount is getting in D state and a the kernel
>>>>>> complains about hung tasks. We are using kernel 4.4.y The actual back
>>>>>> trace is from 4.4.70, but this happens with all the 4.4 kernels I've
>>>>>> used (4.4.30 through 4.4.70).
>>>>>> Tasks like:
>>>>>> INFO: task kworker/u32:9:27574 blocked for more than 120 seconds.
>>>>>> INFO: task kworker/u32:12:27575 blocked for more than 120 seconds.
>>>>>> INFO: task btrfs-transacti:31625 blocked for more than 120 seconds.
>>>>>> are getting blocked waiting for btrfs_tree_read_lock, which is owned
>>>>>> by task umount:31696 (which is also blocked for more than 120 seconds)
>>>>>> regarding the lock debug.
>>>>>>
>>>>>> umount is hung in "cache_block_group", see the '>' mark:
>>>>>>        while (cache->cached == BTRFS_CACHE_FAST) {
>>>>>>                 struct btrfs_caching_control *ctl;
>>>>>>
>>>>>>                 ctl = cache->caching_ctl;
>>>>>>                 atomic_inc(&ctl->count);
>>>>>>                 prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
>>>>>>                 spin_unlock(&cache->lock);
>>>>>>
>>>>>>>                schedule();
>>>>>>
>>>>>>                 finish_wait(&ctl->wait, &wait);
>>>>>>                 put_caching_control(ctl);
>>>>>>                 spin_lock(&cache->lock);
>>>>>>         }
>>>>>>
>>>>>> The complete backtraces could be found in the attached log.
>>>>>>
>>>>>> Do you have any ideas ?
>>>>>
>>>>> Hi Angel -
>>>>>
>>>>> In your log, it says lockdep is disabled.  What tripped it earlier?
>>>>> Lockdep really should be catching locking deadlocks in situations like
>>>>> this, if that's really the underlying cause.
>>>>
>>>> Actually, I'm not sure if lockdep would catch this one.  Here's my
>>>> hypothesis:
>>>>
>>>> kworker/u32:9 is waiting on a read lock while reading the free space
>>>> cache, which means it owns the cache->cached value and will issue the
>>>> wakeup when it completes.
>>>>
>>>> umount is waiting on for the wakeup from kworker/u32:9 but is holding
>>>> some tree locks in write mode.
>>>>
>>>> If kworker/u32:9 is waiting on the locks that umount holds, we have a
>>>> deadlock.
>>>>
>>>> Can you dump the extent buffer that kworker/u32:9 is waiting on?  Part
>>>> of that will contain the PID of the holder, and if matches umount, we
>>>> found the cause.
>>>>
>>>> -Jeff
>>>>
>>>> --
>>>> Jeff Mahoney
>>>> SUSE Labs
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --
>> Jeff Mahoney
>> SUSE Labs
>>

--001a114b09a45dfad30556674cd6
Content-Type: text/x-log; charset="US-ASCII"; name="lockup2.log"
Content-Disposition: attachment; filename="lockup2.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j66k1tnc0

WzIwMDM3ODkuMDIzOTM0XSBzeXNycTogU3lzUnEgOiBTaG93IEJsb2NrZWQgU3RhdGUKWzIwMDM3
ODkuMDI0MTU5XSAgIHRhc2sgICAgICAgICAgICAgICAgICAgICAgICBQQyBzdGFjayAgIHBpZCBm
YXRoZXIKWzIwMDM3ODkuMDI0NjEzXSBrd29ya2VyL3UyNDowICAgRCBmZmZmODgwMzdkMzYzNDcw
ICAgICAwIDE3OTA1ICAgICAgMiAweDAwMDAwMDAwClsyMDAzNzg5LjAyNTAyN10gV29ya3F1ZXVl
OiBldmVudHNfdW5ib3VuZCBidHJmc19hc3luY19yZWNsYWltX21ldGFkYXRhX3NwYWNlIFtidHJm
c10KWzIwMDM3ODkuMDI1Mzc4XSAgZmZmZjg4MDM3ZDM2MzQ3MCBmZmZmODgwMjZiYmQxODUwIGZm
ZmY4ODAzN2QzNjM0MzggZmZmZmZmZmYwMDAwMDAwMApbMjAwMzc4OS4wMjU4NTddICBmZmZmODgw
NDZiZjc4MDAwIGZmZmY4ODAwMDU0M2I0MDAgZmZmZjg4MDM3ZDM2NDAwMCBmZmZmODgwMjZiYmQx
ODUwClsyMDAzNzg5LjAyNjM0MV0gIGZmZmY4ODAwMDU0M2I0MDAgZmZmZjg4MDAwNTQzYjQwMCBm
ZmZmODgwMzdkMzYzNGIwIGZmZmY4ODAzN2QzNjM0ODgKWzIwMDM3ODkuMDI2ODE3XSBDYWxsIFRy
YWNlOgpbMjAwMzc4OS4wMjY5OTJdICBbPGZmZmZmZmZmODE2YjQxYWM+XSBzY2hlZHVsZSsweDNj
LzB4OTAKWzIwMDM3ODkuMDI3MTkwXSAgWzxmZmZmZmZmZmEwYWMzMGI1Pl0gYnRyZnNfdHJlZV9y
ZWFkX2xvY2srMHhlNS8weDE0MCBbYnRyZnNdClsyMDAzNzg5LjAyNzM5OV0gIFs8ZmZmZmZmZmY4
MTBhMzM5MD5dID8gd2FpdF93b2tlbisweGIwLzB4YjAKWzIwMDM3ODkuMDI3NTk0XSAgWzxmZmZm
ZmZmZmEwYTU5NTg0Pl0gYnRyZnNfcmVhZF9sb2NrX3Jvb3Rfbm9kZSsweDM0LzB4NTAgW2J0cmZz
XQpbMjAwMzc4OS4wMzA4NjRdICBbPGZmZmZmZmZmYTBhNWU0ZGI+XSBidHJmc19zZWFyY2hfc2xv
dCsweDcwYi8weDlkMCBbYnRyZnNdClsyMDAzNzg5LjAzMTA0Nl0gIFs8ZmZmZmZmZmY4MTA4MTJk
Mj5dID8gX19taWdodF9zbGVlcCsweDUyLzB4YjAKWzIwMDM3ODkuMDMxMjQ0XSAgWzxmZmZmZmZm
ZmEwYTdhM2JmPl0gYnRyZnNfbG9va3VwX2lub2RlKzB4MmYvMHhhMCBbYnRyZnNdClsyMDAzNzg5
LjAzMTQzOV0gIFs8ZmZmZmZmZmZhMGE5MjVlNz5dIGJ0cmZzX2lnZXQrMHhkNy8weDZhMCBbYnRy
ZnNdClsyMDAzNzg5LjAzMTYyOV0gIFs8ZmZmZmZmZmZhMGFjYjFkZj5dIF9fbG9va3VwX2ZyZWVf
c3BhY2VfaW5vZGUrMHhkZi8weDE1MCBbYnRyZnNdClsyMDAzNzg5LjAzMTkyNV0gIFs8ZmZmZmZm
ZmZhMGFjY2YwYj5dIGxvb2t1cF9mcmVlX3NwYWNlX2lub2RlKzB4NmIvMHhlMCBbYnRyZnNdClsy
MDAzNzg5LjAzMjEwOV0gIFs8ZmZmZmZmZmZhMGFjZTRjYT5dIGxvYWRfZnJlZV9zcGFjZV9jYWNo
ZSsweDdhLzB4MWIwIFtidHJmc10KWzIwMDM3ODkuMDMyMzAwXSAgWzxmZmZmZmZmZmEwYTYzN2I3
Pl0gY2FjaGVfYmxvY2tfZ3JvdXArMHgxYjcvMHgzZDAgW2J0cmZzXQpbMjAwMzc4OS4wMzI0NzRd
ICBbPGZmZmZmZmZmODEwYTMzOTA+XSA/IHdhaXRfd29rZW4rMHhiMC8weGIwClsyMDAzNzg5LjAz
MjY1Nl0gIFs8ZmZmZmZmZmZhMGE3MmM5Zj5dIGZpbmRfZnJlZV9leHRlbnQrMHg3YmYvMHhmNDAg
W2J0cmZzXQpbMjAwMzc4OS4wMzI4MzhdICBbPGZmZmZmZmZmYTBhNzM0ODc+XSBidHJmc19yZXNl
cnZlX2V4dGVudCsweDY3LzB4MTUwIFtidHJmc10KWzIwMDM3ODkuMDMzMDIwXSAgWzxmZmZmZmZm
ZmEwYTczNjY5Pl0gYnRyZnNfYWxsb2NfdHJlZV9ibG9jaysweGY5LzB4NDgwIFtidHJmc10KWzIw
MDM3ODkuMDMzMjEwXSAgWzxmZmZmZmZmZmEwYTU5ZjBjPl0gX19idHJmc19jb3dfYmxvY2srMHgx
MmMvMHg1YTAgW2J0cmZzXQpbMjAwMzc4OS4wMzMzOTldICBbPGZmZmZmZmZmYTBhNWE1MTY+XSBi
dHJmc19jb3dfYmxvY2srMHgxMTYvMHgyYTAgW2J0cmZzXQpbMjAwMzc4OS4wMzM1ODZdICBbPGZm
ZmZmZmZmYTBhNWRmYTY+XSBidHJmc19zZWFyY2hfc2xvdCsweDFkNi8weDlkMCBbYnRyZnNdClsy
MDAzNzg5LjAzMzc3NF0gIFs8ZmZmZmZmZmZhMGE1ZmY3MT5dIGJ0cmZzX2luc2VydF9lbXB0eV9p
dGVtcysweDcxLzB4YzAgW2J0cmZzXQpbMjAwMzc4OS4wMzQwNzVdICBbPGZmZmZmZmZmODExYjY5
ZDM+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHgyMDMvMHgyZjAKWzIwMDM3ODkuMDM0MjY3XSAgWzxm
ZmZmZmZmZmEwYTYwMDFlPl0gYnRyZnNfaW5zZXJ0X2l0ZW0rMHg1ZS8weGQwIFtidHJmc10KWzIw
MDM3ODkuMDM0NDU4XSAgWzxmZmZmZmZmZmEwYTZmYTkxPl0gYnRyZnNfY3JlYXRlX3BlbmRpbmdf
YmxvY2tfZ3JvdXBzKzB4MTExLzB4MjEwIFtidHJmc10KWzIwMDM3ODkuMDM0NzY0XSAgWzxmZmZm
ZmZmZmEwYTg2ODE0Pl0gX19idHJmc19lbmRfdHJhbnNhY3Rpb24rMHg5NC8weDM0MCBbYnRyZnNd
ClsyMDAzNzg5LjAzNTA3MF0gIFs8ZmZmZmZmZmZhMGE4NmFkMD5dIGJ0cmZzX2VuZF90cmFuc2Fj
dGlvbisweDEwLzB4MjAgW2J0cmZzXQpbMjAwMzc4OS4wMzUyNjddICBbPGZmZmZmZmZmYTBhNzBm
MjA+XSBmbHVzaF9zcGFjZSsweGYwLzB4NGIwIFtidHJmc10KWzIwMDM3ODkuMDM1NDYwXSAgWzxm
ZmZmZmZmZmEwYTcxNDBhPl0gPyBidHJmc19hc3luY19yZWNsYWltX21ldGFkYXRhX3NwYWNlKzB4
MTJhLzB4MWMwIFtidHJmc10KWzIwMDM3ODkuMDM1NzY3XSAgWzxmZmZmZmZmZmEwYTcxNDBhPl0g
PyBidHJmc19hc3luY19yZWNsYWltX21ldGFkYXRhX3NwYWNlKzB4MTJhLzB4MWMwIFtidHJmc10K
WzIwMDM3ODkuMDM2MDcyXSAgWzxmZmZmZmZmZmEwYTcxNDcwPl0gPyBidHJmc19hc3luY19yZWNs
YWltX21ldGFkYXRhX3NwYWNlKzB4MTkwLzB4MWMwIFtidHJmc10KWzIwMDM3ODkuMDM2Mzg0XSAg
WzxmZmZmZmZmZmEwYTcxNDAyPl0gYnRyZnNfYXN5bmNfcmVjbGFpbV9tZXRhZGF0YV9zcGFjZSsw
eDEyMi8weDFjMCBbYnRyZnNdClsyMDAzNzg5LjAzNjY4MF0gIFs8ZmZmZmZmZmY4MTA3Mzc2Nj5d
IHByb2Nlc3Nfb25lX3dvcmsrMHgxZTYvMHg2YjAKWzIwMDM3ODkuMDM2ODU1XSAgWzxmZmZmZmZm
ZjgxMDczNmRkPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MTVkLzB4NmIwClsyMDAzNzg5LjAzNzAy
OF0gIFs8ZmZmZmZmZmY4MTA3M2M5OT5dIHdvcmtlcl90aHJlYWQrMHg2OS8weDQ4MApbMjAwMzc4
OS4wMzcyMTRdICBbPGZmZmZmZmZmODEwNzNjMzA+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHg2YjAv
MHg2YjAKWzIwMDM3ODkuMDM3Mzk2XSAgWzxmZmZmZmZmZjgxMDdhMzdkPl0ga3RocmVhZCsweDEx
ZC8weDE0MApbMjAwMzc4OS4wMzc1NzNdICBbPGZmZmZmZmZmODEwN2EyNjA+XSA/IGt0aHJlYWRf
Y3JlYXRlX29uX25vZGUrMHgyMjAvMHgyMjAKWzIwMDM3ODkuMDM3NzUxXSAgWzxmZmZmZmZmZjgx
NmJhOGZmPl0gcmV0X2Zyb21fZm9yaysweDNmLzB4NzAKWzIwMDM3ODkuMDM3OTI1XSAgWzxmZmZm
ZmZmZjgxMDdhMjYwPl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MjIwLzB4MjIwClsyMDAz
Nzg5LjAzODExN10gYnRyZnMtdHJhbnNhY3RpIEQgZmZmZjg4MDM5ZGNmYjZhOCAgICAgMCAyMzI4
NSAgICAgIDIgMHgwMDAwMDAwMApbMjAwMzc4OS4wMzg1MTNdICBmZmZmODgwMzlkY2ZiNmE4IGZm
ZmY4ODA0NmEyNmQ0YjAgZmZmZjg4MDM5ZGNmYjY3MCAwMDAwMDAwMDAwMDAwMDAwClsyMDAzNzg5
LjAzODk5MV0gIGZmZmY4ODA0NmJmNTlhMDAgZmZmZjg4MDAwM2FjMzQwMCBmZmZmODgwMzlkY2Zj
MDAwIGZmZmY4ODAzMTJhMWMwNDAKWzIwMDM3ODkuMDM5NDc2XSAgZmZmZjg4MDEyNmE2YmEwMCBm
ZmZmODgwNDZhMjZkNGIwIGZmZmY4ODA0NmEyNmQ0MDAgZmZmZjg4MDM5ZGNmYjZjMApbMjAwMzc4
OS4wMzk5NTNdIENhbGwgVHJhY2U6ClsyMDAzNzg5LjA0MDEyNF0gIFs8ZmZmZmZmZmY4MTZiNDFh
Yz5dIHNjaGVkdWxlKzB4M2MvMHg5MApbMjAwMzc4OS4wNDAzMTZdICBbPGZmZmZmZmZmYTBhNjM3
MzY+XSBjYWNoZV9ibG9ja19ncm91cCsweDEzNi8weDNkMCBbYnRyZnNdClsyMDAzNzg5LjA0MDQ5
NV0gIFs8ZmZmZmZmZmY4MTBhMzM5MD5dID8gd2FpdF93b2tlbisweGIwLzB4YjAKWzIwMDM3ODku
MDQwNjgxXSAgWzxmZmZmZmZmZmEwYTcyYzlmPl0gZmluZF9mcmVlX2V4dGVudCsweDdiZi8weGY0
MCBbYnRyZnNdClsyMDAzNzg5LjA0MDg2OF0gIFs8ZmZmZmZmZmZhMGE3MzQ4Nz5dIGJ0cmZzX3Jl
c2VydmVfZXh0ZW50KzB4NjcvMHgxNTAgW2J0cmZzXQpbMjAwMzc4OS4wNDEwNTVdICBbPGZmZmZm
ZmZmYTBhNzM2Njk+XSBidHJmc19hbGxvY190cmVlX2Jsb2NrKzB4ZjkvMHg0ODAgW2J0cmZzXQpb
MjAwMzc4OS4wNDEyNTJdICBbPGZmZmZmZmZmYTBhNTlmMGM+XSBfX2J0cmZzX2Nvd19ibG9jaysw
eDEyYy8weDVhMCBbYnRyZnNdClsyMDAzNzg5LjA0MTQ0MV0gIFs8ZmZmZmZmZmZhMGE1YTUxNj5d
IGJ0cmZzX2Nvd19ibG9jaysweDExNi8weDJhMCBbYnRyZnNdClsyMDAzNzg5LjA0MTYyN10gIFs8
ZmZmZmZmZmZhMGE1ZGZhNj5dIGJ0cmZzX3NlYXJjaF9zbG90KzB4MWQ2LzB4OWQwIFtidHJmc10K
WzIwMDM3ODkuMDQxODEzXSAgWzxmZmZmZmZmZmEwYTY1MTc1Pl0gbG9va3VwX2lubGluZV9leHRl
bnRfYmFja3JlZisweGM1LzB4NWIwIFtidHJmc10KWzIwMDM3ODkuMDQyMTA3XSAgWzxmZmZmZmZm
ZjgxMDgxMmQyPl0gPyBfX21pZ2h0X3NsZWVwKzB4NTIvMHhiMApbMjAwMzc4OS4wNDIzMDFdICBb
PGZmZmZmZmZmYTBhNTkxNmE+XSA/IGJ0cmZzX2FsbG9jX3BhdGgrMHgxYS8weDIwIFtidHJmc10K
WzIwMDM3ODkuMDQyNDkyXSAgWzxmZmZmZmZmZmEwYTY3NzAxPl0gX19idHJmc19mcmVlX2V4dGVu
dC5pc3JhLjY3KzB4ZjEvMHhjYjAgW2J0cmZzXQpbMjAwMzc4OS4wNDI4MDBdICBbPGZmZmZmZmZm
YTBhZDM4NWQ+XSA/IGJ0cmZzX21lcmdlX2RlbGF5ZWRfcmVmcysweDhkLzB4NjMwIFtidHJmc10K
WzIwMDM3ODkuMDQzMTAyXSAgWzxmZmZmZmZmZmEwYTZiOTgyPl0gPyBfX2J0cmZzX3J1bl9kZWxh
eWVkX3JlZnMrMHgxOTIvMHgxNjMwIFtidHJmc10KWzIwMDM3ODkuMDQzNDE2XSAgWzxmZmZmZmZm
ZmEwYTZjMGMwPl0gX19idHJmc19ydW5fZGVsYXllZF9yZWZzKzB4OGQwLzB4MTYzMCBbYnRyZnNd
ClsyMDAzNzg5LjA0MzcxNV0gIFs8ZmZmZmZmZmY4MTBkNGVhND5dID8gbG9ja190aW1lcl9iYXNl
LmlzcmEuMzUrMHg1NC8weDcwClsyMDAzNzg5LjA0MzkwNl0gIFs8ZmZmZmZmZmZhMGE4NDJlYj5d
ID8gam9pbl90cmFuc2FjdGlvbi5pc3JhLjEzKzB4MmIvMHg0NDAgW2J0cmZzXQpbMjAwMzc4OS4w
NDQyMThdICBbPGZmZmZmZmZmYTBhNmZjMTI+XSBidHJmc19ydW5fZGVsYXllZF9yZWZzKzB4ODIv
MHgyYzAgW2J0cmZzXQpbMjAwMzc4OS4wNDQ0MTJdICBbPGZmZmZmZmZmYTBhODU1ZjM+XSBidHJm
c19jb21taXRfdHJhbnNhY3Rpb24rMHg0My8weGIxMCBbYnRyZnNdClsyMDAzNzg5LjA0NDcxOV0g
IFs8ZmZmZmZmZmZhMGE4MDlhYz5dIHRyYW5zYWN0aW9uX2t0aHJlYWQrMHgyMmMvMHgyOTAgW2J0
cmZzXQpbMjAwMzc4OS4wNDQ5MDddICBbPGZmZmZmZmZmYTBhODA3ODA+XSA/IGJ0cmZzX2NsZWFu
dXBfdHJhbnNhY3Rpb24rMHg2NTAvMHg2NTAgW2J0cmZzXQpbMjAwMzc4OS4wNDUyMTBdICBbPGZm
ZmZmZmZmODEwN2EzN2Q+XSBrdGhyZWFkKzB4MTFkLzB4MTQwClsyMDAzNzg5LjA0NTM4NV0gIFs8
ZmZmZmZmZmY4MTA3YTI2MD5dID8ga3RocmVhZF9jcmVhdGVfb25fbm9kZSsweDIyMC8weDIyMApb
MjAwMzc4OS4wNDU1NjBdICBbPGZmZmZmZmZmODE2YmE4ZmY+XSByZXRfZnJvbV9mb3JrKzB4M2Yv
MHg3MApbMjAwMzc4OS4wNDU3MzVdICBbPGZmZmZmZmZmODEwN2EyNjA+XSA/IGt0aHJlYWRfY3Jl
YXRlX29uX25vZGUrMHgyMjAvMHgyMjAKWzIwMDM3ODkuMDQ1OTEwXSBidHJmcyAgICAgICAgICAg
RCBmZmZmODgwMjZiMjJiODgwICAgICAwIDIzMjg2ICAyMzIwMiAweDAwMDAwMDAwClsyMDAzNzg5
LjA0NjI5MV0gIGZmZmY4ODAyNmIyMmI4ODAgZmZmZjg4MDQ2YTI2ZDRiMCBmZmZmODgwMjZiMjJi
ODQ4IDAwMDAwMDAwMDAwMDAwMDAKWzIwMDM3ODkuMDQ2NzY3XSAgZmZmZjg4MDQ2YmY1YjQwMCBm
ZmZmODgwMDM3OGUzNDAwIGZmZmY4ODAyNmIyMmMwMDAgZmZmZjg4MDMxMmExYzA0MApbMjAwMzc4
OS4wNDcyNDFdICBmZmZmODgwNDY1NzJiNDAwIGZmZmY4ODA0NmEyNmQ0YjAgZmZmZjg4MDQ2YTI2
ZDQwMCBmZmZmODgwMjZiMjJiODk4ClsyMDAzNzg5LjA0NzcyMF0gQ2FsbCBUcmFjZToKWzIwMDM3
ODkuMDQ3ODkwXSAgWzxmZmZmZmZmZjgxNmI0MWFjPl0gc2NoZWR1bGUrMHgzYy8weDkwClsyMDAz
Nzg5LjA0ODA3Nl0gIFs8ZmZmZmZmZmZhMGE2MzczNj5dIGNhY2hlX2Jsb2NrX2dyb3VwKzB4MTM2
LzB4M2QwIFtidHJmc10KWzIwMDM3ODkuMDQ4MjYwXSAgWzxmZmZmZmZmZjgxMGEzMzkwPl0gPyB3
YWl0X3dva2VuKzB4YjAvMHhiMApbMjAwMzc4OS4wNDg0NDldICBbPGZmZmZmZmZmYTBhNzJjOWY+
XSBmaW5kX2ZyZWVfZXh0ZW50KzB4N2JmLzB4ZjQwIFtidHJmc10KWzIwMDM3ODkuMDQ4NjM4XSAg
WzxmZmZmZmZmZmEwYTczNDg3Pl0gYnRyZnNfcmVzZXJ2ZV9leHRlbnQrMHg2Ny8weDE1MCBbYnRy
ZnNdClsyMDAzNzg5LjA0ODgyN10gIFs8ZmZmZmZmZmZhMGE3MzY2OT5dIGJ0cmZzX2FsbG9jX3Ry
ZWVfYmxvY2srMHhmOS8weDQ4MCBbYnRyZnNdClsyMDAzNzg5LjA0OTAxNV0gIFs8ZmZmZmZmZmZh
MGE1OWYwYz5dIF9fYnRyZnNfY293X2Jsb2NrKzB4MTJjLzB4NWEwIFtidHJmc10KWzIwMDM3ODku
MDQ5MjExXSAgWzxmZmZmZmZmZmEwYTVhNTE2Pl0gYnRyZnNfY293X2Jsb2NrKzB4MTE2LzB4MmEw
IFtidHJmc10KWzIwMDM3ODkuMDQ5NDE0XSAgWzxmZmZmZmZmZmEwYTVkZmE2Pl0gYnRyZnNfc2Vh
cmNoX3Nsb3QrMHgxZDYvMHg5ZDAgW2J0cmZzXQpbMjAwMzc4OS4wNDk2MDFdICBbPGZmZmZmZmZm
YTBhNWZmNzE+XSBidHJmc19pbnNlcnRfZW1wdHlfaXRlbXMrMHg3MS8weGMwIFtidHJmc10KWzIw
MDM3ODkuMDQ5OTA5XSAgWzxmZmZmZmZmZmEwYWMzNzU4Pl0gYnRyZnNfaW5zZXJ0X29ycGhhbl9p
dGVtKzB4NTgvMHg4MCBbYnRyZnNdClsyMDAzNzg5LjA1MDIyN10gIFs8ZmZmZmZmZmZhMGFiYWU0
OD5dIGJ0cmZzX2lvY3RsX3NuYXBfZGVzdHJveSsweDRiOC8weDdlMCBbYnRyZnNdClsyMDAzNzg5
LjA1MDU0Ml0gIFs8ZmZmZmZmZmZhMGFjMGU4OT5dIGJ0cmZzX2lvY3RsKzB4ODk5LzB4MjdlMCBb
YnRyZnNdClsyMDAzNzg5LjA1MDcyMF0gIFs8ZmZmZmZmZmY4MTZiOWJhNz5dID8gX3Jhd19zcGlu
X3VubG9jaysweDI3LzB4NDAKWzIwMDM3ODkuMDUwODk3XSAgWzxmZmZmZmZmZjgxMTkwNjhkPl0g
PyBoYW5kbGVfbW1fZmF1bHQrMHhkYmQvMHgxYjgwClsyMDAzNzg5LjA1MTA3M10gIFs8ZmZmZmZm
ZmY4MTE4ZjkyNj5dID8gaGFuZGxlX21tX2ZhdWx0KzB4NTYvMHgxYjgwClsyMDAzNzg5LjA1MTI1
N10gIFs8ZmZmZmZmZmY4MTFlYTZlZj5dIGRvX3Zmc19pb2N0bCsweDMwZi8weDU4MApbMjAwMzc4
OS4wNTE0MzRdICBbPGZmZmZmZmZmODEwYWEyNmY+XSA/IHVwX3JlYWQrMHgxZi8weDQwClsyMDAz
Nzg5LjA1MTYwNV0gIFs8ZmZmZmZmZmY4MTFmNjc5Nj5dID8gX19mZ2V0X2xpZ2h0KzB4NjYvMHg5
MApbMjAwMzc4OS4wNTE3NzVdICBbPGZmZmZmZmZmODExZWE5ZDk+XSBTeVNfaW9jdGwrMHg3OS8w
eDkwClsyMDAzNzg5LjA1MTk0OF0gIFs8ZmZmZmZmZmY4MTZiYTU1Yj5dIGVudHJ5X1NZU0NBTExf
NjRfZmFzdHBhdGgrMHgxNi8weDczClsyMDAzODQ4Ljc4MDg2NF0gc3lzcnE6IFN5c1JxIDogVHJp
Z2dlciBhIGNyYXNoClsyMDAzODQ4Ljc4MTA5M10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5l
bCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAgICAgICAgIChudWxsKQ==
--001a114b09a45dfad30556674cd6--
