Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.70.57.6] ([195.70.57.6]:58132 "EHLO icts.hu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbbJ0O6F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 10:58:05 -0400
Received: from [10.168.1.103] (193.226.213.205.pool.invitel.hu [193.226.213.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by icts.hu (Postfix) with ESMTPSA id 072C91D0FA89
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 15:57:08 +0100 (CET)
From: =?UTF-8?B?U3phbG1hIEzDoXN6bMOz?= <dblaci@dblaci.hu>
Subject: Re: random i/o error without error in dmesg
To: linux-btrfs@vger.kernel.org
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
 <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
Message-ID: <562F90C3.6000002@dblaci.hu>
Date: Tue, 27 Oct 2015 15:57:07 +0100
MIME-Version: 1.0
In-Reply-To: <pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wait for the problem to occur, i will try the remount,ro remount,rw. 
But I know for sure, in my case umount / mount solved the problem every 
time!

Reboot was not needed. (I think reboot is simpler because the fs is 
used, and the service has to be stopped etc.)

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

