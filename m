Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36075 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2G3Rim (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 13:38:42 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: severe hardlink bug
Date: Mon, 30 Jul 2012 19:38:40 +0200
Cc: "Michael Niederle" <mniederle@gmx.at>
References: <20100124015138.092c4959@simplux> (sfid-20100124_140227_915565_71E60B6D)
In-Reply-To: <20100124015138.092c4959@simplux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207301938.40461.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 24. Januar 2010 schrieb Michael Niederle:
> I'm using btrfs with a kernel 2.6.32.2 (builtin) as the root file
> system of a Gentoo Linux installation.

Upgrade your kernel!

This kernel is waaaaaaaaaaaaaaaaaaaaaaaay to old for any production use of 
BTRFS. Heck, upstream still did not mark BTRFS as stable although Oracle 
and SUSE do support it. Current kernel have a many fixes.

Use at least 3.2. And have backups anyway.

The hard-link issue is known since ages and being worked on (see link from 
Jan in this thread). If you want to help, test the patch.

So, folks, can we get over it?

Thanks, 
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
