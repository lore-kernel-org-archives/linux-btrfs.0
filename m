Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:61717 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3JZFpl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 01:45:41 -0400
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252; format=flowed
Received: from [192.168.2.90]
 (modemcable211.176-81-70.mc.videotron.ca [70.81.176.211])
 by VL-VM-MR002.ip.videotron.ca
 (Oracle Communications Messaging Exchange Server 7u4-22.01 64bit (built Apr 21
 2011)) with ESMTPA id <0MV900ANGHC43590@VL-VM-MR002.ip.videotron.ca> for
 linux-btrfs@vger.kernel.org; Sat, 26 Oct 2013 01:45:40 -0400 (EDT)
Message-id: <526B56DE.6060105@polymtl.ca>
Date: Sat, 26 Oct 2013 01:45:02 -0400
From: Christian Robert <christian.robert@polymtl.ca>
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why cannot I move a read-only snapshot around?
References: <20131024152955.GA6110@kipc2.localdomain>
 <pan$85344$b336f5bf$ca444091$a3ef1e0c@cox.net>
 <20131024220919.GB14128@kipc2.localdomain>
In-reply-to: <20131024220919.GB14128@kipc2.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

you can change a "ro" snapshot into a "rw" snapshot

you just snapshot it without the -r" option

ex:

# btrfs subv snap -r linux-3.12-rc5 snap_ro
Create a readonly snapshot of 'linux-3.12-rc5' in './snap_ro'

# touch ./snap_ro/helo
touch: cannot touch ‘./snap_ro/helo’: Read-only file system

# btrfs subv snap snap_ro snap_rw
Create a snapshot of 'snap_ro' in './snap_rw'

# touch ./snap_rw/helo

# btrfs subv delete ./snap_ro
Delete subvolume '/data/snap_ro'

# mv snap_rw snap_any

# ls -ld snap*
drwxrwxr-x 1 root root 944 Oct 26 01:41 snap_any/


On 2013-10-24 18:09, Karl Kiniger wrote:
> Hi
>
> (pls see also my other reply in this thread)
>
> On Thu 131024, Duncan wrote:
>> Karl Kiniger posted on Thu, 24 Oct 2013 17:29:56 +0200 as excerpted:
>>
>>> Dear list, (newbie alert)
>>>
>>> After sucessfully sending and receiving a dozen of  related snapshots I
>>> want to move them all to the readonly folder but I cannot:
>>
>> I see you mention fedora 19 in a followup, but for those not on fedora,
>> that's not much help figuring out which kernel you're running.  It's
>> likely that the following is your problem, tho there's not enough
>> information in your post to be sure.
>
> I promise to include more info in the future but just received
> snapshots should be read-only if I read the docs correctly.
>
>>
>> There was a recent regression with nested subvolumes that may be what
>> you're running into.  Kernel 3.11 was affected as well as early 3.12-rcs
>> and I believe 3.10 also but I'm not sure how far back, except that
>> someone mentioned trying an old kernel (3.8 or 3.6-ish) and moving
>> subvolumes into subvolumes worked there (tho doing anything involving
>> writing into read-only snapshots shouldn't work, by design, but that
>> doesn't appear to be what you're doing, you're just trying to move read-
>> only snapshots to a different location on a read/write base or parent
>> subvolume, this post assuming it's a parent subvolume, thus triggering
>> the nested subvolumes bug).
>
> No nested subvolumes involved. (Is this true? This all is inside the top
> level volume or what it is called in btrfs.....)
>
>> A fix is available but I'm not sure whether it got into 3.12 (which is
>> just about to be released) or will now have to wait for 3.13.  So either
>> try latest 3.12 git and see if its there, or find and cherry-pick the
>> patch, applying it against 3.11 or 3.12.  (Given that btrfs is still an
>> experimental filesystem with fixes applied every kernel, while reverting
>> to an old enough kernel should unregress this particular problem, I can't
>> recommend it except possibly for testing against data you don't care
>> about, since by doing so you're exposing yourself to other known and now
>> fixed bugs.)
> Agreed, I dont want to go back to older kernels - too risky. The data  are
> backed up anyways (on ZFS if you are curious)  but the time invested  into
> my current btrfs setup would be gone.
>
> I can live with the current situation, its just not nice to have the
> snapshots lying around in a place where they should not belong.
>
> If it were possible to temporarily make the r/o snapshots r/w just for
> the purpose of moving (being aware that caution is needed) I would
> not hesitate ane try that.
>
> Karl
>
>
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
