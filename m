Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754013AbcHSMOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Aug 2016 08:14:17 -0400
Date: Fri, 19 Aug 2016 13:55:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert regression fix with print-tree enhancement
Message-ID: <20160819115500.GH16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160819081308.21348-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2016 at 04:13:04PM +0800, Qu Wenruo wrote:
> This patchset fixes one convert regression, adds regression test.
> Then with 2 print-tree enhancement, which is quite handy to find how inode
> and subvolume READONLY flag is set.
> 
> Qu Wenruo (4):
>   btrfs-progs: convert: Fix a regression that ext2_save/image is not
>     readonly
>   btrfs-progs: convert-test: Check if the ext2_save/image is read only
>   btrfs-progs: print-tree: Print human readable inode flags
>   btrfs-progs: print-tree: Print hex and human readable root flags

All applied, thanks.
