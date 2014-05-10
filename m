Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:37972 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750775AbaEJABm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 20:01:42 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs cleaner failure - fs/btrfs/extent-tree.c:5748 (3.14.0)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140509223659.GW11401@merlins.org>
Date: Fri, 9 May 2014 18:00:50 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <0AE72D68-224C-4B12-9C9B-3B7628174ACB@colorremedies.com>
References: <20140507233959.GB11401@merlins.org> <536AD20E.70004@fb.com> <20140508004344.GE11401@merlins.org> <20140508013440.GH11401@merlins.org> <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com> <20140508220242.GO11401@merlins.org> <CAKhhfD5DTPfKvWcRDERxWa_pjfhCkZxW3WBtznYC94EFy7A0mQ@mail.gmail.com> <423AB9BE-EDBF-478B-8CED-C1A9A0FAE736@colorremedies.com> <20140509223659.GW11401@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 9, 2014, at 4:36 PM, Marc MERLIN <marc@merlins.org> wrote:

> 
> Details:
> It looks like my corruption came from there.
> I'm still not sure why it's apparently so severe that btrfs recovery cannot
> open the FS now.
> 
> WARNING: CPU: 6 PID: 555 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
> CPU: 6 PID: 555 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
> Hardware name: LENOVO 20BECT0/20BECT0, BIOS GMET28WW (1.08 ) 09/18/2013
> 0000000000000000 ffff8800cd9f1b38 ffffffff8160a06d 0000000000000000
> ffff8800cd9f1b70 ffffffff81050025 ffffffff812170f6 ffff88013c9cbdf0
> 00000000fffffffe 0000000000000000 0000000001856000 ffff8800cd9f1b80
> Call Trace:
> [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
> [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
> [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
> [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
> [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
> [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
> [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
> [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
> [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
> [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
> [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
> [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
> [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
> [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
> [<ffffffff8114020e>] ? kfree+0x66/0x85
> [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
> [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
> [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
> [<ffffffff8106bc62>] kthread+0xae/0xb6
> [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
> [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
> [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61

Well I'm sorta dense, so I only find a complete dmesg useful because with storage problems it seems much is due to some other problem happening earlier. Maybe a fs developer would say "yeah that's not good, but we maybe should do better failing gracefully". Call traces don't mean much of anything to me, I think the real problem happened before this, unless it's strictly a Btrfs bug in which case the evidence may be localized in just the trace.

Also you said it went read only overnight but I'm seeing a reference here to cleaning up a deleted snapshot? Are you running something that's taking and deleting snapshots on a schedule?
> 
> 
> On Fri, May 09, 2014 at 10:19:46AM -0600, Chris Murphy wrote:
>> 
>> On May 9, 2014, at 4:35 AM, Marc MERLIN <marc@merlins.org> wrote:
>> 
>>> 
>>> Howdy,
>>> 
>>> I won't have the time to rebuild my laptop tonight, so I'll wait one more
>>> day to see if anyone would like data from that fs to see why it crashed and
>>> why btrfs recovery doesn't even seem able to open it.
>> 
>> There's some underlying reason why it went read only, but we don't
>> have those messages. The message we do have says the kernel is already
>> tainted, so something (possibly entirely unrelated) happened earlier.
> 
> Oh, I missed that.
> May  2 14:23:06 legolas kernel: [283268.319035] CPU: 0 PID: 25726 Comm: watchdog/0 Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
> This is weird because I don't use any 3rd party binary modules.

The G means it's not a proprietary driver involved. You'd have to go through a full dmesg to find out what's causing it, but the point of the tainted state notification is that the kernel is in a state likely no one, or very few, other people are experiencing and any subsequent problems are suspect. 

> 
> Right now, I do see:
> legolas:~# cat /proc/sys/kernel/tainted
> 512
> 
> Mmmh, so I missed up and pasted the wrong error. I found the real one now, pasted below
> 
>>> Also I'm not sure if I should risk 3.15rc to rebuild the filesystem and I'd
>>> love not to have to say during my talk that even almost latest btrfs
>>> corrupts itself without reason and working recovery methods :-/
>> 
>> Just because the reason isn't yet known or understood yet doesn't mean it's happened without reason. And we also don't know whether it corrupted itself, or had help earlier on. Neither is good, but depending on the cause of the corruption, recovery may not even be realistic.
> 
> You're right that there is always a reason :)
> (especially now that I see the real error, my fault for missing it the first time)
> 
> But I was fairly dismayed that btrfs recovery couldn't even open the filesystem.
> I was somehow thinking maybe I gave it the wrong options.

There are still ZFS corruptions from time to time. And they happen even on file systems that get pounded on mercilessly like NTFS, XFS and HFS+. Almost always it's not the file system itself, something else instigated the problem. Still such mature file systems have bugs being found and fixed. So recovery not working itself doesn't surprise me, I don't even know what caused the problem.


> 
>> I'd probably consider 3.13.11 if I simply had work that needs to get done rather than testing. If the problem happens there too then you've stumbled on something that isn't likely a regression.
> 
> True, although most devs tell you to run the latest, or any problems or bugs are your fault :)
> (losely paraphrased :)

I think Btrfs in general is still buyer beware, but that's in the category of Not News because I think all free software distributions say the same thing, essentially. None of it comes with support or a warranty unless you've bought an SLA. If you really suspect a problem in 3.14.x that may not yet be fixed in 3.15rc or you don't want to run rc kernels is reasonable to run the kernel prior to the current one which is 3.13.11. The way kernel fixes work, a fix has to be demonstrated in 

> 
>> If you've done any suspend/hibernate at all, I'd stop doing that until
>> you're in a position to do a lot more rigorous testing. I say that
> 
> Thanks for warning me of that.
> I only use S3 sleep, oh but you say that's bad too?
> I've been using it for more than 10 years, is it now suddenly cause of
> kernel and/or filesystem corruption?

Well you think you've been using it successfully for 10 years. If you've have exactly 0 cases of any kind of fs corruption in 10 years, or can exclude suspend/resume from corruption incident by assurance there was a reboot in between the suspend/resume and the corruption, then maybe you haven't experienced a problem. But Google is full of users who have not merely immediate corruption on suspend/resume but rather several successful cycles of it and then get hit with some amount of corruption. So chances are they're getting corruption each time, it's just that it takes a cumulative effect for it to be noticed. But then, maybe not, maybe it's transient. And maybe everyone with different hardware is actually experiencing a slightly different problem and type of corruption.

So i can't give an exhaustive summary as to how reliable it is, or why or when it's unreliable. In my own case, it works, and then it doesn't and sometimes I get a lot of corruption and it doesn't matter what the file system is. I don't know whether I'd say Btrfs is more or less prone to such corruption, or whether it's just more self aware seeing as none of the other file systems I use even checksum their own fs metadata (not even their own journal).

What I can say is that it was working for a few kernel releases and then it just took a swan dive and now it's so unreliable I simply don't trust it at all. I power off the computer. And I know it's not strictly hardware related, because I don't have such problems with "the other OS" on this hardware, OS X. But it wouldn't surprise me one bit if the firmware is doing something loosy goosy between suspend/resume that Apple knows about and has accounted for, yet isn't accounted for by Linux maybe even because it can't if the firmware isn't cooperative.

So I personally don't draw too much conclusions about bugs, including Btrfs bugs, until I have a reproducer in a VM and on baremetal. If I can't reproduce it, well then I'm just frustrated and learn to live with that.


Chris Murphy

