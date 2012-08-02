Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50585 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2HBN5X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 09:57:23 -0400
Date: Thu, 2 Aug 2012 15:57:20 +0200
From: David Sterba <dave@jikos.cz>
To: Arne Jansen <sensille@gmx.net>
Cc: Liu Bo <liub.liubo@gmail.com>, Stefan Behrens <sbehrens@giantdisaster.de>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
Message-ID: <20120802135719.GR17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50192A11.3060109@jan-o-sch.net>
 <50192FCE.30006@gmail.com>
 <50193DDA.20504@giantdisaster.de>
 <501A56E3.3080401@giantdisaster.de>
 <501A583D.8030600@gmail.com>
 <501A61ED.3000908@gmx.net>
 <501A65B9.5060004@gmail.com>
 <501A6731.4000405@gmx.net>
 <501A6B0D.6050303@gmail.com>
 <501A84CA.10604@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501A84CA.10604@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 03:46:50PM +0200, Arne Jansen wrote:
> > Anyway, for now, our error flag has only been stored in memory, so what
> > about just keep it until we find a graceful way?
> 
> Yeah, we need this patch to restore consistency. We can define a fixed
> area on disk (e.g. behind the superblock) where we can write the flag
> to without risking the superblock.

Is it possible that sectors around the superblock are somehow damaged
and unwritable that writing to them will fail as well? Ie. some safe
distance from the superblock would be needed.

david
