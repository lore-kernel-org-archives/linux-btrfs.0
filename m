Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbbJ3Pzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 11:55:39 -0400
Date: Fri, 30 Oct 2015 16:54:11 +0100
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?B?6rCV7IOB7Jqw?= <kenneth.kang@lge.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: FW: btrfs-progs: android build
Message-ID: <20151030155411.GG13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <003201d0d02c$3349fe10$99ddfa30$@lge.com>
 <003f01d0d02c$96c92f10$c45b8d30$@lge.com>
 <20150806143839.GK31669@twin.jikos.cz>
 <001b01d0d33e$8043bb60$80cb3220$@lge.com>
 <20150826144428.GY10756@twin.jikos.cz>
 <20150831163301.GB11834@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150831163301.GB11834@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 06:33:01PM +0200, David Sterba wrote:
> So the preliminary support is merged. Outstanding issues are all related
> to blkid API:
> 
> - is_ssd

Fixed by trivially ifdef around the function.

> - btrfs_wipe_existing_sb
> - check_overwrite
>
> In the ssd check case it's safe to provide the 'return 1' replacement,
> but the other two are related to safety measures and I'm not comfortable
> to ifdef them out yet.

I'm not able to find the exact version of libblkid that android uses,
closest guess is 2.14 which is pretty old. The low-level probing has
been added to 2.15 and I think we can't avoid that. Reimpliementing the
missing blkid functionality is possible but I'd rather not go that way.

Please let me know if there's a version of android build system that
provides sufficiently new blkid otherwise I'm afraid that we can't
support it.
