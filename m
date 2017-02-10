Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751058AbdBJPPo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Feb 2017 10:15:44 -0500
Date: Fri, 10 Feb 2017 16:13:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2] Btrfs: create helper for processing bits on
 contiguous pages
Message-ID: <20170210151349.GG16928@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1486086563-25543-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 02, 2017 at 05:49:22PM -0800, Liu Bo wrote:
> This introduces a new helper which can be used to process pages bits.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
