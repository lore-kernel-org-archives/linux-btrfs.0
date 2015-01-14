Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbbANR6c (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 12:58:32 -0500
Date: Wed, 14 Jan 2015 18:58:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs-progs: Enhance btrfs-find-root.
Message-ID: <20150114175830.GX3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1415771534-7979-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415771534-7979-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 12, 2014 at 01:52:12PM +0800, Qu Wenruo wrote:
> Enhance btrfs-find-root in the following way:
> 1. Use existing or lightly modified btrfs infrastructure
>    Don't use btrfs-find-root local defined open_ctree or csum check.
>    Slightly modify open_ctree() and csum_tree_block() to provide the
>    chunk-only open_ctree and suprress error output for csum_tree_block()
> 
> 2. Output the trees in an ascending order of generation
>    Normally, end user running btrfs-find-root is hoping to find out a
>    recently new old root.
>    So output the search result in an ascending order of generation.
> 
> 3. Hide the obviously not tree root node/leaf
>    Only output the node/leaf with the highest level among its generation
>    to simplify the output.

Can you please split this patch into logical and possibly independent
parts? There are cleanups, core functionality changes and new option(s)
added.
