Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758196AbcIWLAZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 07:00:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C980AC71
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 11:00:23 +0000 (UTC)
Date: Fri, 23 Sep 2016 12:58:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH] parent_start initialization cleanup
Message-ID: <20160923105821.GW16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1474571494-5321-1-git-send-email-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474571494-5321-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 22, 2016 at 02:11:34PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Code cleanup. parent_start is initialized multiple times when it is
> not necessary to do so.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
