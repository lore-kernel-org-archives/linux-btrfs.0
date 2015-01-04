Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56142 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbbADTmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 14:42:05 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Erkki Seppala <flux-btrfs@inside.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] E2fsprogs: add compress and cow support in chattr, lsattr
Date: Sun, 04 Jan 2015 20:41:49 +0100
Message-ID: <2718622.uOfcMZu9oC@merkaba>
In-Reply-To: <m49d26u96bo.fsf@battery.modeemi.fi>
References: <4DA2A15C.1050501@cn.fujitsu.com> <54A67152.4030404@5t9.de> <m49d26u96bo.fsf@battery.modeemi.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 4. Januar 2015, 12:40:59 schrieb Erkki Seppala:
> Lutz Vieweg <lvml@5t9.de> writes:
> 
> > Maybe "chattr +C" could print a warning if a file
> > to change attributes for is > 0 bytes long?
> 
> This may only affect btrfs. The old ext2? ext3? compression patches
> were able to compress pre-existing files. I don't know how other
> filesystems behave in this regard.

+C is no-cow, -c is compression.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
