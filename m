Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751329AbeFVJn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Jun 2018 05:43:29 -0400
Date: Fri, 22 Jun 2018 11:40:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: return EUCLEAN if extent_inline_ref type is
 invalid
Message-ID: <20180622094038.GW24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
 <20180622081801.19891-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180622081801.19891-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 22, 2018 at 04:18:01PM +0800, Su Yue wrote:
> If type of extent_inline_ref found is not expected, filesystem may have
> been corrupted, should return EUCLEAN instead of EINVAL.
> No functional changes.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
> Changelog:
> v2:
>  Add changes in build_backref_tree, get_extent_inline_ref and
>    add_inline_refs.

v2 looks good. I saw one implicit check for invalid ref in
add_data_references that still returns -EINVAL.
