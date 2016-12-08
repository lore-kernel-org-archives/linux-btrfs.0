Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36177 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753222AbcLHNgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 08:36:55 -0500
Date: Thu, 8 Dec 2016 14:35:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/6] Btrfs: set single device limit for dax usecase
Message-ID: <20161208133559.GE12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-3-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481147110-20048-3-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 07, 2016 at 01:45:06PM -0800, Liu Bo wrote:
> Dax on btrfs is not ready for multiple device.

How about DUP? Technically it's not multi-device but still stores
multiple copies, so I don't know if the implementation is ok with that.
