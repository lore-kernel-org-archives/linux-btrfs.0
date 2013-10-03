Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33261 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3JCLpx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Oct 2013 07:45:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VRhLs-0000nQ-5Z
	for linux-btrfs@vger.kernel.org; Thu, 03 Oct 2013 13:45:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 13:45:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Oct 2013 13:45:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfs balance bug
Date: Thu, 3 Oct 2013 11:45:31 +0000 (UTC)
Message-ID: <pan$a0456$a7c238f0$83bcabb4$dcdfc7c5@cox.net>
References: <CADef55pBMJ-oeOLy9Z3AeP7iRyFqm6fNfuS8BNm0qbDk876SwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Slava Barinov posted on Thu, 03 Oct 2013 08:50:06 +0400 as excerpted:

> Good day.
> 
>   I've got a failure with btrfs balance. In fact I started btrfs balance
>   /btr and got a total filesystem freeze. After I tried applying balance
>   pause or balance cancel the following crashdump appeared and btrfs
>   tool freezed.
>   Reboot changed nothing: I've got totally the same crashdump.
>   So I mounted filesystem with skip_balance option and tried to cancel
>   balance. It worked. Then I performed a btrfsck on my fs and it found
>   nothing suspicious. So I believe it is just a balance bug. I suppose
>   that could be because of lack of free space on device but should not
>   filesystem reject balancing instead of crashing?
> 
> [  117.078876] btrfs: continuing balance

> ------------[ cut here ]------------
> [  152.195487] kernel BUG at fs/btrfs/relocation.c:1055!
> [  152.198432] invalid opcode: 0000 [#1] SMP

> # btrfs --version Btrfs v0.20-rc1-358-g194aa4a
> 
> Kernel is just 3.11.3-gentoo. -ray is my machine config and several
> custom modules which are not loaded now.

Greetings fellow gentooer! =:^)


IIRC balances bugging out with invalid opcode 0000, but working properly 
on a fresh boot, were a known issue on 3.11.  I know I had the problem 
here.

I /believe/ that issue was fixed by a patch that went in between 3.12-rc1 
and 3.12-rc2, and I /think/ the same patch is queued for stable, but due 
to a miscommunication with Greg KH where he was waiting on the btrfs 
folks who were waiting on him, the btrfs patches for stable didn't make 
it into 3.11.3.  However, it /should/ be in the /next/ set 3.11-stable 
release, as they uncrossed their signals and GKH said he'd pull them this 
time.  (You can see the thread for the crossed signals just a couple days 
ago I think, on this list.  Of course the thread for that patch and the 
reports of problems without it will be back a bit further...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

