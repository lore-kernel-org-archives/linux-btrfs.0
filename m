Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53898 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752329AbdIXNuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 09:50:24 -0400
Date: Sun, 24 Sep 2017 15:48:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: skip checksum when reading compressed data if
 some IO have failed
Message-ID: <20170924134850.GU29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170920235019.10508-1-bo.li.liu@oracle.com>
 <20170920235019.10508-2-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170920235019.10508-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 05:50:19PM -0600, Liu Bo wrote:
> Currently even if the underlying disk reports failure on IO,
> compressed read endio still gets to verify checksum and reports it as
> a checksum error.
> 
> In fact, if some IO have failed during reading a compressed data
> extent , there's no way the checksum could match, therefore, we can
> skip that in order to return error quickly to the upper layer.
> 
> Please note that we need to do this after recording the failed mirror
> index so that read-repair in the upper layer's endio can work
> properly.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
