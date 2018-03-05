Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33577 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932641AbeCEVa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 16:30:26 -0500
Date: Mon, 5 Mar 2018 22:28:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: rename btrfs_close_extra_device to
 btrfs_free_extra_devids
Message-ID: <20180305212805.GG5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180227043242.26367-1-anand.jain@oracle.com>
 <20180227044159.27975-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180227044159.27975-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 27, 2018 at 12:41:59PM +0800, Anand Jain wrote:
> This function btrfs_close_extra_devices() is about freeing
> extra devids which once it may have belonged to this fsid.
> So rename it and add the comment. The _devid suffix is
> appropriate as this function won't handle devices which are
> outside of the fsid being mounted.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added to next, thanks.
