Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:50714 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbJDMDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Oct 2015 08:03:41 -0400
Subject: Re: BTRFS as image store for KVM?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <201510021421.09558.russell@coker.com.au> <560E737C.7050206@gmail.com>
 <201510031832.17802.russell@coker.com.au>
 <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56111598.2080403@bouton.name>
Date: Sun, 4 Oct 2015 14:03:36 +0200
MIME-Version: 1.0
In-Reply-To: <pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 04/10/2015 04:09, Duncan a écrit :
> Russell Coker posted on Sat, 03 Oct 2015 18:32:17 +1000 as excerpted:
>
>> Last time I checked a BTRFS RAID-1 filesystem would assign each process
>> to read from one disk based on it's PID.  Every RAID-1 implementation
>> that has any sort of performance optimisation will allow a single
>> process that's reading to use both disks to some extent.
>>
>> When the BTRFS developers spend some serious effort optimising for
>> performance it will be useful to compare BTRFS and ZFS.
> This is the example I use as to why btrfs isn't really stable, as well.  
> Devs tend to be very aware of the dangers of premature optimization, 
> because done too early, it either means throwing that work away when a 
> rewrite comes, or it severely limits options as to what can be rewritten, 
> if necessary, in ordered to avoid throwing all that work that went into 
> optimization away.
>
> So at least for devs that have been around awhile, that don't have some 
> boss that's paying the bills saying optimize now, an actually really good 
> mark of when the /devs/ consider something stable, is when they start 
> focusing on that optimization.

This focus on single reader RAID1 performance surprises me.

1/ AFAIK the kernel md RAID1 code behaves the same (last time I checked
you need 2 processes to read from 2 devices at once) and I've never seen
anyone arguing that the current md code is unstable.

2/ I'm not familiar with implementations taking advantage of several
disks for single process reads but clearly they'll have more problems
with seeks on rotating devices to solve. So are there really
implementations with better performance across the spectrum or do they
have to pay a performance penalty in the mutiple readers case to
optimize the (arguably less frequent/important) single reader case ?

Best regards,

Lionel
