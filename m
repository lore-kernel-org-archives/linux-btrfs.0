Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.70.57.6] ([195.70.57.6]:33808 "EHLO icts.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbbJ1IpL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 04:45:11 -0400
Received: from [10.168.1.103] (91.82.213.117.pool.invitel.hu [91.82.213.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id EE9411D14B35
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 09:44:12 +0100 (CET)
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Subject: Re: random i/o error without error in dmesg
To: linux-btrfs@vger.kernel.org
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
 <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
Message-ID: <56308ADC.5060207@dblaci.hu>
Date: Wed, 28 Oct 2015 09:44:12 +0100
MIME-Version: 1.0
In-Reply-To: <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I had a chance to try some things.

1.: the error

md5sum xyz
md5sum: xyz: Input/output error

(no any errors in dmesg)

2.: mount -o remount,ro /mnt/x

(could not do, it is used)
mysql stop && mount -o remount,ro /mnt/x
problem persists: io error.
mount -o remount,rw /mnt/x
still io error
umount /mnt/x
mount /mnt/x
NO io error, md5sum works!

The umount/mount ALWAYS solved the problem for me, mount -o remount,ro 
was tried for the first time, but it was not enought. Reboot was not needed.
(kernel 4.2.4)

László Szalma


2015-10-27 07:23 keltezéssel, Duncan írta:
> Marc Joliet posted on Mon, 26 Oct 2015 15:23:39 +0100 as excerpted:
>
>> Occasionally they go away by themselves, but usually I have to reboot to
>> make them go away.  This happens when getmail attempts to fetch mail,
>> which fails due to the above error.  After the reboot getmail succeeds
>> again.
> Just out of curiosity, does a remount,ro, followed by a remount,rw, solve
> the problem?
>
> The ro/rw cycle should force anything in memory to device, so if that
> eliminates the problem, it could well be some sort of sync issue.  If it
> doesn't, then it's more likely an in-memory filesystem state issue,
> that's cleared by the reboot.
>
> And if the ro/rw cycle doesn't clear the problem, what about a full
> unmount/mount cycle, at least of that subvolume?
>
> If you're running multiple subvolumes with root being one of them, you
> can't of course unmount the entire filesystem, but you could go down to
> emergency mode (systemctl emergency), try unmounting everything but /,
> mounting / ro, and then switching back to normal mode (from emergency
> mode, simply exiting should return you to normal multi-user or gui
> target, remounting filesystems as necessary, etc).
>
> IOW, does it take a full reboot to clear the problem, or is a simple ro/rw
> mount cycle enough, or an unmount/remount?
>
> Finally, assuming root itself isn't btrfs, if you have btrfs configured
> as a module, you could try unmounting all btrfs and then unloading the
> module, then reloading and remounting.  That should entirely clear all in-
> memory btrfs state, so if that doesn't solve the problem, while rebooting
> does, then the problem's very possibly outside of btrfs scope.  Of course
> if root is btrfs, you can't really check that.
>

