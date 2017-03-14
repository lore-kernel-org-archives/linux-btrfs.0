Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdCNLzp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 07:55:45 -0400
Date: Tue, 14 Mar 2017 12:55:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 0/7] convert: rollback rework
Message-ID: <20170314115506.GT14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170314080509.31163-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 04:05:02PM +0800, Qu Wenruo wrote:
> v2:
>   Abstract the original code to read out data in one btrfs file to
>   btrfs_read_file().
>   Use simple_range and btrfs_reserved_ranges[] to cleanup open code.
> v3:
>   Rebased to v4.10.
>   Squash modification in later commits to their previous owner.
>   Fix a converity report, which doesn't exit when an error is found in
>   check_convert_image()
>   Fix a lot of check scripts warning

I did not mention that explicitly under v2, but the series has been
merged to devel so incremental changes should be sent from now on. I
went through the patches almost line by line and fixed things here and
there. The patchset-to-patchset diff is not large (attached). If you
think there are still issues to fix, please send them on top of the
devel branch.
