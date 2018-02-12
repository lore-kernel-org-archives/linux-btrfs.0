Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56707 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751108AbeBLRCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 12:02:44 -0500
Date: Mon, 12 Feb 2018 18:00:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/1] btrfs: open code
 btrfs_init_dev_replace_tgtdev_for_resume()
Message-ID: <20180212170028.GL3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153625.19541-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212153625.19541-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:36:25PM +0800, Anand Jain wrote:
> btrfs_init_dev_replace_tgtdev_for_resume()  initializes replace
> target device in few simple steps, so do it at the parent function.
> Moreover, there isn't any other caller so just open code it.

Makes sense,

Reviewed-by: David Sterba <dsterba@suse.com>
