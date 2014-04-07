Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41791 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaDGPLA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 11:11:00 -0400
Received: by mail-ie0-f174.google.com with SMTP id rp18so6340501iec.33
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 08:10:59 -0700 (PDT)
Message-ID: <5342C00F.8070001@gmail.com>
Date: Mon, 07 Apr 2014 11:11:11 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
References: <2692878.dRG1K49eOP@fnix> <7675297.F25Z3Ox7Yz@tethys> <pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net> <12471892.pAn1KAtSS4@tethys>
In-Reply-To: <12471892.pAn1KAtSS4@tethys>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-05 07:10, Swâmi Petaramesh wrote:
> Le samedi 5 avril 2014 10:12:17 Duncan wrote [excellent performance advice 
> about disabling Akonadi in BTRFS etc]:
> 
> Thanks Duncan for all this excellent discussion.
> 
> However I'm still rather puzzled with a filesystem for which advice is "if you 
> want tolerable performance, you have to turn off features that are the default 
> with any other FS out there (relatime -> noatime) or you have to quit using 
> this database, or you have to fiddle around with esoteric option such as 
> disabling COW wich BTW is one of BTRFS most promiment features".
> 
The only reason AFAIK that noatime isn't the default on other
filesystems is because it breaks stuff like mutt.  Other than that,
nobody really uses atimes, and noatime will in-fact get you better
performance on any filesystem.
> [...]
> To put it plain flat clear, even if "relatime" causes writes, every other FS 
> out there can cope with it. Even if akonadi is heavy and a disk resource hog, 
> any other FS out there can cope with it and still maintain acceptable, usable 
> performance.
> 
This is because every other filesystem (except ZFS) doesn't use COW
semantics.  IIRC, using those same features on ZFS causes the same
problems.  This in fact brings to mind one of the biggest reasons that I
refuse to use KDE (or systemd for that matter), KDE systems run slower
in my experience even on ext4, XFS, and JFS, not just on COW filesystems.
