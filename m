Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32397 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751038AbcLEAjQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 19:39:16 -0500
Subject: Re: system hangs due to qgroups
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <1776088.42rHLKPlSp@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5f35cc2d-4c3d-b14c-01f6-4bfb0f22823b@cn.fujitsu.com>
Date: Mon, 5 Dec 2016 08:39:02 +0800
MIME-Version: 1.0
In-Reply-To: <1776088.42rHLKPlSp@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/04/2016 02:40 AM, Marc Joliet wrote:
> Hello all,
>
> I'm having some trouble with btrfs on a laptop, possibly due to qgroups.
> Specifically, some file system activities (e.g., snapshot creation,
> baloo_file_extractor from KDE Plasma) cause the system to hang for up to about
> 40 minutes, maybe more.  It always causes (most of) my desktop to hang,
> (although I can usually navigate between pre-existing Konsole tabs) and
> prevents new programs from starting.  I've seen the system load go up to >30
> before the laptop suddenly resumes normal operation.  I've been seeing this
> since Linux 4.7, maybe already 4.6.

Qgroup is CPU intensive operation.

The main problem is the design of btrfs extent tree, which bias towards 
snapshot creating speed, but quite complicated if used for tracing all 
referencer (which qgroup heavily relies on it).


The main factor affecting qgroup speed, is how many shared extents are 
in the fs.
This including reflinked files and snapshot, under most case snapshot is 
the main part.

Unless we find a better solution, to keep both qgroup accurate and fast, 
I'd recommend to keep qgroup under a reasonable number.
(Personally speaking, 10 would be good)

Despite the qgroup, relocation(balancing) should also be affected by the 
number of shared extents.

>
> Now, I thought that maybe this was (indirectly) due to an overly full file
> system (~90% full), so I deleted some things I didn't need to get it up to 15%
> free.  (For the record, I also tried mounting with ssd_spread.)  After that, I
> ran a balance with -dusage=50, which started out promising, but then went back
> to the "bad" behaviour.  *But* it seemed better than before overall, so I
> started a balance with -musage=10, then -musage=50.  That turned out to be a
> mistake.  Since I had to transport the laptop, and couldn't wait for "balance
> cancel" to return (IIUC it only returns after the next block (group?) is
> freed), I forced the laptop off.
>
> After I next turned on the laptop, the balance resumed, causing bootup to
> fail, after which I remembered about the skip_balance mount option, which I
> tried in a rescue shell from an initramfs.  But wait, that failed, too!
> Specifically, the stack trace I get whenever I try it includes as one of the
> last lines:
>
> "RIP [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a8"

This seems to be a NULL pointer bug in qgroup relocation fix.

The latest fix (not merged yet) should address it.

You could try the for-next-20161125 branch from David to fix it:
https://github.com/kdave/btrfs-devel/tree/for-next-20161125

>
> (I can take photos of the full stack trace if requested.)
>
> So then I ran "btrfs qgroup show /sysroot/", which showed many quota groups,
> much to my surprise.  On the upside, at least now I discovered the likely
> reason for the performance problems.

So, the number of qgroups is the cause for the slowness.

>
> (I actually think I know why I'm seeing qgroups: at one point I was trying out
> various snapshot/backup tools for btrfs, and one (I forgot which)
> unconditionally activated quota support, which infuriated me, but I promptly
> deactivated it, or so I thought.  Is quota support automatically enabled when
> qgroups are discovered, or did I perhaps not disable quota support properly?)

Qgroup will always be enabled after "btrfs quota enable", and until 
"btrfs quota disable" to disable it.

No method to temporarily disable quota, since quota must trace any 
modification, or qgroup number will be out of true.

So, one should manually disable quota.
(And that's the backup tool to blame, it should either info user or 
disable qgroup on uninstallation)

>
> Since I couldn't use skip_balance, and logically can't destroy qgroups on a
> read-only file system, I decided to wait for a regular mount to finish.  That
> has been running since Tuesday, and I am slowly growing impatient.
>
> Thus I arrive at my question(s): is there anything else I can try, short of
> reformatting and restoring from backup?  Can I use btrfs-check here, or any
> other tool?  Or...?
>
> Also, should I be able to avoid reformatting: how do I properly disable quota
> support?

"btrfs quota disable <mnt>", yes you need RW mount.
Any RW mountable snapshot/subvolume is OK.

>
> (BTW, searching for qgroup_fix_relocated_data_extents turned up the ML thread
> "[PATCH] Btrfs: fix endless loop in balancing block groups", could that be
> related?)

Nope, the actual fixing patches are:
[PATCH 1/4] btrfs: qgroup: Add comments explaining how btrfs qgroup works
[PATCH 2/4] btrfs: qgroup: Rename functions to make it follow 
reserve,trace,account steps
[PATCH 3/4] btrfs: Expoert and move leaf/subtree qgroup helpers to qgroup.c
[PATCH 4/4] btrfs: qgroup: Fix qgroup data leaking by using subtree tracing


The 4th patch is the real working one, but relies on previous 3 to apply.

The regression is also caused by my patch:
[PATCH v3.1 2/3] btrfs: relocation: Fix leaking qgroups numbers on data 
extents

Sorry for the trouble.


And for your recovery, I'd suggest to install an Archlinux into a USB 
HDD or USB stick, and compile David's branch and install it into the USB 
HDD.

Then use the USB storage as rescue tool to mount the fs, which should do 
RW mount with or without skip_balance mount option.
So you could disable quota then.

Thanks,
Qu


>
> The laptop is currently running Gentoo with Linux 4.8.10 and btrfs-progs
> 4.8.4.
>
> Greetings
>


