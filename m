Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbcBWM2V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 07:28:21 -0500
Date: Tue, 23 Feb 2016 13:28:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: fix lockdep deadlock warning due to
 dev_replace
Message-ID: <20160223122812.GL4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
 <1437122959-23376-2-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437122959-23376-2-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 04:49:19PM +0800, Liu Bo wrote:
> With this, btrfs/011 no more produces warnings in dmesg.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Patch added to next for 4.6.
