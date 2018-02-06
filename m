Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbeBFO4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Feb 2018 09:56:37 -0500
Date: Tue, 6 Feb 2018 15:54:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: nborisov@suse.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs: use enum instead of constant value
Message-ID: <20180206145422.GB31890@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
 <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 11, 2018 at 04:12:17PM +0800, Gu Jinxiang wrote:
> populate_free_space_tree calls function btrfs_search_slot_for_read with
> parameter int find_higher = 1, it means that, if no exact match is found,
> then use the next higher item.
> So in function populate_free_space_tree, use READA_FORWARD to read
> forward ahead.
> 
> Changelog:
> v2->v1: change enum from READA_BACK to READA_FORWARD, since according
> to the logic of the source, it should reada_for_search forward, not
> backward.
> And, Reference:
> commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")
> 
> v3->v2: add commit message to make it easy to understand. And split it
> to two patch.
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>

For some reason I have the two mails tagged as applied but don't see
them in any branch. Anyway, now added, thanks.
