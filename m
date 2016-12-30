Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37386 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751075AbcL3ArR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Dec 2016 19:47:17 -0500
Subject: Re: Btrfs send does not preserve reflinked files within subvolumes.
To: Glenn Washburn <development@efficientek.com>
References: <20161228204430.348cb61f@crass-Ideapad-Z570>
 <c4956c5f-b9e2-fe28-0c0d-4e6a03da9a7c@cn.fujitsu.com>
 <20161229042055.17e4774e@crass-Ideapad-Z570>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a9f1fb46-5311-2279-68a0-66cf9979ebac@cn.fujitsu.com>
Date: Fri, 30 Dec 2016 08:47:07 +0800
MIME-Version: 1.0
In-Reply-To: <20161229042055.17e4774e@crass-Ideapad-Z570>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Glenn,

At 12/29/2016 06:20 PM, Glenn Washburn wrote:
> Hi Qu,
>
> Thanks for your response.  I've attached the send file as you have
> requested. The "-2" one is created from the same script modified to
> create a snapshot of C called C.snap instead of setting C to readonly,
> and sending C.snap instead of C.  The second version is to mirror what
> you seemed to do in your reply.  Still no reflinking.  I've included
> the original script and log again, which was modified to show more
> verbose logging on the receive.

Confirmed it's kernel bug.
Send stream doesn't contain the clone operation.

So it's kernel send to blame.

>
> As I was using btrgs-progs v4.4, I've compiled v4.9 to get the nice
> --dump option for receive (which you seem to have added, kudos!).  The
> output of the dump option is in the *.recv-dump.log files.  However, I
> see no clone command in the output.
>
> Keep in mind that I'm running Ubuntu kernel 4.4.0-53-generic, which I
> believe to be mostly v4.4.30 with a few patches.  Any ideas when send
> started using "clone" in the kernel?

Not pretty sure about from which exact kernel version send can detect 
reflink.

AFAIC I sent an RFC patch to disable reflink detection in send in July 
2016, and it just got rejected.

So I assume at least v4.6 kernel works.

Thanks,
Qu

>
> Thanks,
> Glenn
>
> On Thu, 29 Dec 2016 13:55:46 +0800
> Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>> Hi,
>>
>> I tried just what you did, and use "btrfs receive --dump" to exam the
>> send stream.
>>
>> And things works quite well:
>>
>> $ sudo mount /dev/sda6  /mnt/btrfs/
>> $ sudo btrfs subvolume create /mnt/btrfs/subv1
>> $ sudo xfs_io -f -c "pwrite 0 2M" /mnt/btrfs/subv1/file1
>> $ sudo xfs_io -f -c "reflink /mnt/btrfs/subv1/file1 0 0 2M"
>> /mnt/btrfs/subv1/file1.ref
>> $ sudo btrfs subv snap -r /mnt/btrfs/subv1/ /mnt/btrfs/ro_snap
>> $ sudo btrfs send /mnt/btrfs/ro_snap/ > /tmp/output
>> $ sudo btrfs receive --dump < /tmp/output
>>
>> And the output shows like this:
>> subvol          ./ro_snap
>> uuid=e788bb6e-8ec6-dd47-a452-e26196d22699 transid=9
>> chown           ./ro_snap/                      gid=0 uid=0
>> chmod           ./ro_snap/                      mode=755
>> utimes          ./ro_snap/
>> atime=2016-12-29T13:46:00+0800 mtime=2016-12-29T13:46:50+0800
>> ctime=2016-12-29T13:46:50+0800
>> mkfile          ./ro_snap/o257-8-0rename          ./ro_snap/o257-8-0
>>           dest=./ro_snap/file1
>> utimes          ./ro_snap/
>> atime=2016-12-29T13:46:00+0800 mtime=2016-12-29T13:46:50+0800
>> ctime=2016-12-29T13:46:50+0800
>> write           ./ro_snap/file1                 offset=0 len=49152
>> write           ./ro_snap/file1                 offset=49152 len=49152
>> <snip normal write for file1>
>> write           ./ro_snap/file1                 offset=2064384
>> len=32768 truncate        ./ro_snap/file1                 size=2097152
>> chown           ./ro_snap/file1                 gid=0 uid=0
>> chmod           ./ro_snap/file1                 mode=600
>> utimes          ./ro_snap/file1
>> atime=2016-12-29T13:46:24+0800 mtime=2016-12-29T13:46:24+0800
>> ctime=2016-12-29T13:46:24+0800
>> mkfile          ./ro_snap/o258-8-0rename          ./ro_snap/o258-8-0
>>           dest=./ro_snap/file1.ref
>> utimes          ./ro_snap/
>> atime=2016-12-29T13:46:00+0800 mtime=2016-12-29T13:46:50+0800
>> ctime=2016-12-29T13:46:50+0800
>> clone           ./ro_snap/file1.ref             offset=0 len=2097152
>> from=./ro_snap/file1 clone_offset=0
>> ^^^ Here is the clone operation
>>
>> truncate        ./ro_snap/file1.ref             size=2097152
>> chown           ./ro_snap/file1.ref             gid=0 uid=0
>> chmod           ./ro_snap/file1.ref             mode=600
>> utimes          ./ro_snap/file1.ref
>> atime=2016-12-29T13:46:50+0800 mtime=2016-12-29T13:47:07+0800
>> ctime=2016-12-29T13:47:07+0800
>>
>> And in fact, btrfs send can even handle reflink to parent subvolume.
>> (Although this behavior can be deadly for heavily reflinked files)
>>
>>
>> So, would you please upload the send stream for us to check?
>>
>> Thanks,
>> Qu
>>
>> At 12/29/2016 10:44 AM, Glenn Washburn wrote:
>>> I'm having a hard time getting btrfs receive to create reflinked
>>> files and have a trivial example that I believe *should* work but
>>> doesn't. I've attached a script that I used to perform this test,
>>> so others can try to reproduce.  The text file is the output of the
>>> shell script except the last command, which is a tool I wrote to
>>> print the extent info from FIEMAP.  "btrfs fi du" would work just
>>> as well, but I'm on Ubuntu 16.04, whose btrfs progs doesn't have
>>> that command yet.  I've also tested on Ubuntu 16.10 with similar
>>> results, except that "btrfs fi du" is on that version and confirms
>>> what my tool displays.
>>>
>>> So, can send not do what I'm trying to get it to do? If it can now,
>>> when did that feature get introduced (must have been after kernel
>>> 4.8)?  I'm very surprised that this feature wouldn't have already
>>> been done and if not that no one seems to be complaining about it.
>>> I've done a decent amount of searching on this and have come up with
>>> nothing.  Any help would be greatly appreciated.
>>>
>>> Thanks,
>>> Glenn
>>>
>>>
>>
>>
>
>


