Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55848 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2INLWG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 07:22:06 -0400
Date: Fri, 14 Sep 2012 13:21:59 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/5] Btrfs: cleanup fs_info->hashers
Message-ID: <20120914112159.GG17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-4-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347613087-3489-4-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 04:58:06PM +0800, Liu Bo wrote:
> fs_info->hashers is now an obsolete one.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
