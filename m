Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5874 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbaG3PkV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 11:40:21 -0400
Message-ID: <53D911DE.7000806@fb.com>
Date: Wed, 30 Jul 2014 11:40:14 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chris Mason <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Fix memory corruption by ulist_add_merge() on
 32bit arch
References: <1406537824-2376-1-git-send-email-tiwai@suse.de>	<53D64D40.80606@fb.com>	<s5hzjft7fwm.wl%tiwai@suse.de>	<s5hsill7fak.wl%tiwai@suse.de>	<s5hsiljrwwy.wl%tiwai@suse.de>	<53D9015A.90001@fb.com>	<s5h61iesxen.wl%tiwai@suse.de> <s5h1tt2sx94.wl%tiwai@suse.de>
In-Reply-To: <s5h1tt2sx94.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2014 11:05 AM, Takashi Iwai wrote:
> At Wed, 30 Jul 2014 17:01:52 +0200,
> Takashi Iwai wrote:
>>
>> At Wed, 30 Jul 2014 10:29:46 -0400,
>> Josef Bacik wrote:
>>>
>>> On 07/30/2014 05:57 AM, Takashi Iwai wrote:
>>>> At Mon, 28 Jul 2014 16:01:55 +0200,
>>>> Takashi Iwai wrote:
>>>>>
>>>>> At Mon, 28 Jul 2014 15:48:41 +0200,
>>>>> Takashi Iwai wrote:
>>>>>>
>>>>>> At Mon, 28 Jul 2014 09:16:48 -0400,
>>>>>> Josef Bacik wrote:
>>>>>>>
>>>>>>> On 07/28/2014 04:57 AM, Takashi Iwai wrote:
>>>>>>>> We've got bug reports that btrfs crashes when quota is enabled on
>>>>>>>> 32bit kernel, typically with the Oops like below:
>>>>>>>>     BUG: unable to handle kernel NULL pointer dereference at 00000004
>>>>>>>>     IP: [<f9234590>] find_parent_nodes+0x360/0x1380 [btrfs]
>>>>>>>>     *pde = 00000000
>>>>>>>>     Oops: 0000 [#1] SMP
>>>>>>>>     CPU: 0 PID: 151 Comm: kworker/u8:2 Tainted: G S      W 3.15.2-1.gd43d97e-default #1
>>>>>>>>     Workqueue: btrfs-qgroup-rescan normal_work_helper [btrfs]
>>>>>>>>     task: f1478130 ti: f147c000 task.ti: f147c000
>>>>>>>>     EIP: 0060:[<f9234590>] EFLAGS: 00010213 CPU: 0
>>>>>>>>     EIP is at find_parent_nodes+0x360/0x1380 [btrfs]
>>>>>>>>     EAX: f147dda8 EBX: f147ddb0 ECX: 00000011 EDX: 00000000
>>>>>>>>     ESI: 00000000 EDI: f147dda4 EBP: f147ddf8 ESP: f147dd38
>>>>>>>>      DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>>>>>>>     CR0: 8005003b CR2: 00000004 CR3: 00bf3000 CR4: 00000690
>>>>>>>>     Stack:
>>>>>>>>      00000000 00000000 f147dda4 00000050 00000001 00000000 00000001 00000050
>>>>>>>>      00000001 00000000 d3059000 00000001 00000022 000000a8 00000000 00000000
>>>>>>>>      00000000 000000a1 00000000 00000000 00000001 00000000 00000000 11800000
>>>>>>>>     Call Trace:
>>>>>>>>      [<f923564d>] __btrfs_find_all_roots+0x9d/0xf0 [btrfs]
>>>>>>>>      [<f9237bb1>] btrfs_qgroup_rescan_worker+0x401/0x760 [btrfs]
>>>>>>>>      [<f9206148>] normal_work_helper+0xc8/0x270 [btrfs]
>>>>>>>>      [<c025e38b>] process_one_work+0x11b/0x390
>>>>>>>>      [<c025eea1>] worker_thread+0x101/0x340
>>>>>>>>      [<c026432b>] kthread+0x9b/0xb0
>>>>>>>>      [<c0712a71>] ret_from_kernel_thread+0x21/0x30
>>>>>>>>      [<c0264290>] kthread_create_on_node+0x110/0x110
>>>>>>>>
>>>>>>>> This indicates a NULL corruption in prefs_delayed list.  The further
>>>>>>>> investigation and bisection pointed that the call of ulist_add_merge()
>>>>>>>> results in the corruption.
>>>>>>>>
>>>>>>>> ulist_add_merge() takes u64 as aux and writes a 64bit value into
>>>>>>>> old_aux.  The callers of this function in backref.c, however, pass a
>>>>>>>> pointer of a pointer to old_aux.  That is, the function overwrites
>>>>>>>> 64bit value on 32bit pointer.  This caused a NULL in the adjacent
>>>>>>>> variable, in this case, prefs_delayed.
>>>>>>>>
>>>>>>>> Here is a quick attempt to band-aid over this: a new function,
>>>>>>>> ulist_add_merge_ptr() is introduced to pass/store properly a pointer
>>>>>>>> value instead of u64.  There are still ugly void ** cast remaining
>>>>>>>> in the callers because void ** cannot be taken implicitly.  But, it's
>>>>>>>> safer than explicit cast to u64, anyway.
>>>>>>>>
>>>>>>>> Bugzilla: https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.novell.com/show_bug.cgi?id%3D887046&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=m3qrbo6ngjqKO%2B7ofuwRfQflb9Cx%2FXrF8TKejkPjxfA%3D%0A&s=199a5b6f0ed181925e9ba2c1060fe20d1c8ad2831dd1d96cc7eddd2a343fa72b
>>>>>>>> Cc: <stable@vger.kernel.org> [v3.11+]
>>>>>>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> Alternatively, we can change the argument of aux and old_aux to a
>>>>>>>> pointer from u64, as backref.c is the only user of ulist_add_merge()
>>>>>>>> function.  I'll cook up another patch if it's the preferred way.
>>>>>>>>
>>>>>>>
>>>>>>> Yeah lets just use a pointer and see how that works out.  Thanks,
>>>>>>
>>>>>> Oops, I forgot that ulist_add() takes aux as u64 and it calling
>>>>>> ulist_add_merge() internally.  So, we can't change the type blindly
>>>>>> there, unfortunately.
>>>>>
>>>>> Looking back at the code, it seems that all aux arguments passed to
>>>>> ulist_add() in qgroup.c are pointers, too.  So, indeed, all aux values
>>>>> are pointers, so far, and it'd be even cleaner to replace all these
>>>>> from u64 to void *.
>>>>>
>>>>> But, such a replacement patch will become difficult for backporting to
>>>>> stable kernels (the bug existed since 3.11, at least).  So IMO, we
>>>>> should put a smaller fix like my previous one, let it backported to
>>>>> stable kernels, and do more comprehensive replacements to pointer on
>>>>> its top.
>>>>
>>>> Ping.  Could you guys take my original patch as is, or do you prefer
>>>> changing in a different way?  If so, how?
>>>>
>>>
>>> I don't care how hard it is to backport to stable,
>>
>> You must do care as a maintainer.  It's a long-standing and serious
>> bug since 3.11.  The kernel hangs up immediately when you enable quota
>> on 32bit kernel.  And it's really hard to revert it when the rootfs is
>> btrfs.  (The mount follows the immediate hang up after reboot.)
>>

What I mean is that we want the right fix first, not something that is easier to
pull back to stable and then the right fix later.  Do it right first and then
backport it to the stable kernels, it's perfectly acceptable to adjust patches
when sending them to the stable team.  "But it's hard" is not a valid excuse for
not doing it right the first time.

>>> since we're using pointers
>>> everywhere just change it to void * and be done with it.  Thanks,
>>
>> Fix it quickly, then do cleanup.  This is the golden rule for
>> regression :)
>
> Also, another question is whether you guys are OK to change the type
> to a pointer.  Through a glance, the ulist code was intended to handle
> any generic data, thus it uses u64, right?  Using void pointer breaks
> this concept.
>

It's fine, ulist today resembles very little from what it was originally.  The
current users all shove pointers into there, so we might as well just make it a
pointer.  Thanks,

Josef
