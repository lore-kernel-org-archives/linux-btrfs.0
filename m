Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33580 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932072Ab3L3Sjv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 13:39:51 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131230175740.GS19863@merlins.org>
Date: Mon, 30 Dec 2013 11:39:41 -0700
Cc: Marc MERLIN <marc@merlins.org>
Message-Id: <F3EB1119-BDD6-418E-A43A-963C2987E536@colorremedies.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20131228182023.GG19863@merlins.org> <1388419531.11341.6.camel@ret.masoncoding.com> <20131230161729.GQ19863@merlins.org> <1388420830.11341.12.camel@ret.masoncoding.com> <20131230171039.GC26054@merlins.org> <95A29B65-87F9-4B73-9715-2BBC10833A64@colorremedies.com> <20131230175740.GS19863@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 30, 2013, at 10:57 AM, Marc MERLIN <marc@merlins.org> wrote:

> On Mon, Dec 30, 2013 at 10:48:10AM -0700, Chris Murphy wrote:
>> 
>> On Dec 30, 2013, at 10:10 AM, Marc MERLIN <marc@merlins.org> wrote:
>>> 
>>> If one day, it could at least work on a subvolume level (only sync a
>>> subvolume), then it would be more useful to me. Maybe later…
>> 
>> Maybe I'm missing something, but btrfs send/receive only work on a subvolume level.
> 
> Never mind, I seem to be the one being dense. I mis-read that you needed
> to create the filesystem with btrfs receive.
> Indeed, it's on a subvolume level, so it's actually fine since it does
> allow over provisionning afterall.

Depending on resources and disaster recovery requirements, you might also consider using send -f without receive at all, to the backup destination. The first send file (which will be big) can then be put anywhere, even to tape, and use the backup storage just for the incremental send -f files.


Chris Murphy