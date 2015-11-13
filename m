Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbbKMPPM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 10:15:12 -0500
Date: Fri, 13 Nov 2015 16:13:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Alexander Fougner <fougner89@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: allow device deletion using 'missing'
 keyword again
Message-ID: <20151113151334.GL6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1446855984-5123-1-git-send-email-fougner89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446855984-5123-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 07, 2015 at 01:26:24AM +0100, Alexander Fougner wrote:
> Device deletion procedures ensures the device is a block device.
> This patch introduces 'missing' as keyword again, correctly
> passing it on to the kernel instead of complaining about
> 'missing' not being a block device.
> 
> Signed-off-by: Alexander Fougner <fougner89@gmail.com>

Applied, thanks. Scheduled for 4.3.1.
