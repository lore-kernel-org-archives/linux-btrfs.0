Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752186AbdBBRh2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Feb 2017 12:37:28 -0500
Date: Thu, 2 Feb 2017 18:36:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: remove unused trans in read_block_for_search
Message-ID: <20170202173659.GB16723@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1485807822-16386-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1485807822-16386-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2017 at 12:23:42PM -0800, Liu Bo wrote:
> @trans is not used at all, this removes it.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
