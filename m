Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965937Ab3HHQKd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 12:10:33 -0400
Date: Thu, 8 Aug 2013 18:10:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>, Zach Brown <zab@redhat.com>
Subject: Re: [PATCH 0/4] btrfs: out-of-band (aka offline) dedupe v4
Message-ID: <20130808161031.GY5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 11:42:47AM -0700, Mark Fasheh wrote:
> The following series of patches implements in btrfs an ioctl to do
> out-of-band deduplication of file extents.

Reviewed-by: David Sterba <dsterba@suse.cz>
