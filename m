Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38429 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbcAGPAU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jan 2016 10:00:20 -0500
Date: Thu, 7 Jan 2016 15:57:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH] Btrfs-progs: fix typo in parse_range
Message-ID: <20160107145758.GE4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1452114533-15121-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452114533-15121-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 06, 2016 at 01:08:53PM -0800, Liu Bo wrote:
> s/*end/*start.
> 
> This makes 'btrfs balance start -dvrange=xxx..yyy' really work.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Applied, thanks.
