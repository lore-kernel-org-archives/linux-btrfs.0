Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58587 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaDELLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 07:11:35 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS setup advice for laptop performance ?
Date: Sat, 05 Apr 2014 13:10:13 +0200
Message-ID: <12471892.pAn1KAtSS4@tethys>
In-Reply-To: <pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>
References: <2692878.dRG1K49eOP@fnix> <7675297.F25Z3Ox7Yz@tethys> <pan$ca9c0$aeb7ee6f$84e2e493$5ee834ed@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le samedi 5 avril 2014 10:12:17 Duncan wrote [excellent performance advice 
about disabling Akonadi in BTRFS etc]:

Thanks Duncan for all this excellent discussion.

However I'm still rather puzzled with a filesystem for which advice is "if you 
want tolerable performance, you have to turn off features that are the default 
with any other FS out there (relatime -> noatime) or you have to quit using 
this database, or you have to fiddle around with esoteric option such as 
disabling COW wich BTW is one of BTRFS most promiment features".

In other words, IMHO the best quality of a filesystem is to handle efficiently my 
workload - which means the FS corresponds to my needs - rather than 
necessitating that I change my workload and habits to adapt to the FS.

Looks a bit like you will have to cut one inch of your toes to fit into your 
brand new shiny shoes, ain't it ?

To put it plain flat clear, even if "relatime" causes writes, every other FS 
out there can cope with it. Even if akonadi is heavy and a disk resource hog, 
any other FS out there can cope with it and still maintain acceptable, usable 
performance.

Having a FS which advice is either to stop using what I'm using, OR to turn of 
or not use some of its key features - snapshots, COW... - which are the only 
reasons to consider using it in the 1st place... Uh.

Well... Buy a new car, let the vendor tell you you shouldn't go to the moutain 
for it isn't adapted, you shouldn't go to the sea as the engine will rust, and 
you shouldn't drive too much in cities as it will smoke too much... and not 
too much motorways either as the motor might heat a bit too much.

I need a filesystem that fits me, I don't want to have to fit my filesystem :-\


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

