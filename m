Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39966 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2J1NgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Oct 2012 09:36:25 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        Ronnie Collinson <notthinking@gmail.com>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>
Subject: Re: How does btrfs behave on checksum mismatch?
Date: Sun, 28 Oct 2012 14:36:24 +0100
References: <20121027215645.GU2381@yeono.kjorling.se> <201210281423.51427.Martin@lichtvoll.de> <20121028132639.GC5042@carfax.org.uk> (sfid-20121028_143432_324693_8EF50121)
In-Reply-To: <20121028132639.GC5042@carfax.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210281436.24540.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Oktober 2012 schrieb Hugo Mills:
> On Sun, Oct 28, 2012 at 02:23:51PM +0100, Martin Steigerwald wrote:
> > Am Sonntag, 28. Oktober 2012 schrieb Ronnie Collinson:
> > > In a raid1 situation, it will also rewrite the effected data, on
> > > the drive that failed the checksum
> > 
> > Will it do so without an explicit scrub?
> 
>    If a failed checksum is detected, yes.
> 
>    If there's a bad block, and the FS happens to read the good copy
> first, it won't fix it, because it hasn't tried reading the bad copy
> yet.

Ah, okay. I think I read some while ago in a case of bad checksum detected 
it won´t repair automatically. Has this been changed?

Anyway, a regular scrub still makes sense, as BTRFS only reads files that 
applications demand and BTRFS may read from a good copy as you pointed 
out.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
