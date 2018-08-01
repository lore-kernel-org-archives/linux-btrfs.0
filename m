Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389054AbeHAOjI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 10:39:08 -0400
Date: Wed, 1 Aug 2018 14:53:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] Some unused parameter cleanup
Message-ID: <20180801125321.GB3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180801033231.23166-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2018 at 11:32:24AM +0800, Lu Fengqi wrote:
> PATCH 1-2 remove all unused fs_info parameter from delayed-inode.c
> PATCH 3-5 remove all unused fs_info parameter from root-tree.c
> PATCH 6-7 some cleanup for btrfs_unlink_subvol

Thanks, added to misc-next.
