Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41311 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbbHYNog (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 09:44:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUEWf-0000P9-D0
	for linux-btrfs@vger.kernel.org; Tue, 25 Aug 2015 15:44:33 +0200
Received: from h8193.mu.qub.ac.uk ([143.117.78.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 15:44:33 +0200
Received: from miguel.negrao-lists by h8193.mu.qub.ac.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 15:44:33 +0200
To: linux-btrfs@vger.kernel.org
From: Miguel =?utf-8?b?TmVncsOjbw==?=
	<miguel.negrao-lists@friendlyvirus.org>
Subject: Btrfs tragedy: lack of space for metadata leads to loss of fs.
Date: Tue, 25 Aug 2015 13:44:12 +0000 (UTC)
Message-ID: <loom.20150825T151154-787@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

This weekend had my first btrfs horror story. 

system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2

A disclaimer: I know 3.13 is very out of date, but I the requirement of
keeping kernel up to date clashes with my requirement of keeping a stable
system. At the moment I can't disturb my system as I'm doing important work,
upgrading kernel requires upgrading ubuntu, which will upgrade a lot of
packages and might lead to problems which I don't have time to fix. One
might argue that in the end I lost time anyway dealing with these btrfs
issues. When I'm done with this current work I will update the whole system
which will update the kernel in the process.

Story:

btrfs fi show / -> devid 1 size 92.27GiB used 92.27GiB.

Suddenly a 100GB single device fs goes into a state where it doesn't have
more free space, no new files can be written. 'fi usage' says a minimum of
20GB are free, but metadata is 4.97GiB allocated vs 4.45Gib used. I decide
to do a 'balance -dusage=55' as lower values of usage don't balance
anything. This starts a balance of '0 out of 0 chunks' which goes on for 24h
(status always says 0 considered, -nan% left, dmesg had only 'relocating
block group 32...... flags 36'). This is a OCZ vertex 3, a quite fast SSD.
24h seemed excessive to me, I assume that the balance has gone wrong
somehow. I shutdown the system to see if the balance will stop. On the first
boot up the fs is still mounted, on a second boot the fs no longer mounts.

I switch to a nixos usb pen running kernel 4.1.6 and progs up to date also
(probably 4.1.x). Trying to mount the fs results in a kernel error (
http://pastebin.com/CzryecsX ).

trying mounting with '-o recovery,ro' hangs the system, a reboot is needed.

I proceed to get contents of disk via 'restore'. I then do btrfs-zero-log,
still doesn't mount, and then do btrfs check --repair a couple of times (log
before running with '--repair' http://pastebin.com/VPZLjcXR)
 
I then try to mount with '-o recovery,ro' and it works !! (thank you btrfs
check !!). I proceed to get the data out of the disk, this seems to go well,
no errors in dmesg. I then try to mount without recovery,ro and again the
kernel hangs. One time I had the dmesg window open and was able to see that
it was something about ..._async_reclaim_metadata_space. 

I finally give up on the filesystem and format it. I have an image produced
via btrfs-image if it is of interest.

A couple of notes:

1) I know btrfs is experimental, anything that I might have lost is my fault
(I didn't loose anything).
2) I think this issue of free space is a known issues being worked on, that
no space to allocate when metadata space is needed will cause no free space
problem. It's on the faq. Still, it doesn't seem acceptable to me that the
system can go into a state where in the end the fs is destroyed or the linux
machine is unusable (can never turn it off because balance never stops),
specially since there was still a lot of space in the disk. If the system
somehow had rebalanced itself automatically this could have been avoided. It
shouldn't let itself get into this corner. Perhaps a bit of space should
always be kept for emergency rebalancing ?
4) I wonder if that balance would have ended or if it had just stalled. It
seems that a reboot with a ongoing or stalled balance will cause fs
destruction. Possibly an issue already fixed in later kernels. Also, why did
it say 0 considered, -nan% left ? -nan% looks strange.
3) The system freezing when trying to mount a fs is possible not supposed to
happen ? (this was on the latest kernel)

Just wanted to share the story in case it is of some use for developers.
Again, possibly this happened due to issues already fixed in later kernels.
Anyway, despite this issue, I'm still quite happy with btrfs overall.

Best regards,
Miguel Negr√£oˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
