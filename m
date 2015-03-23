Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbbCWQAJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 12:00:09 -0400
Date: Mon, 23 Mar 2015 17:00:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Sebastian Thorarensen <sebth@naju.se>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/4] btrfs-progs: btrfs-convert: Allow setting nodesize
Message-ID: <20150323160007.GO20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1426812639.git.sebth@naju.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 02:09:45AM +0100, Sebastian Thorarensen wrote:
> Changes since v1:
>  * Split patch into smaller patches
>  * btrfs-convert and mkfs now shares check_node_or_leaf_size
>  * Rebased onto latest v3.19.x

Thanks! Minor changes: I've fixed build failure of mkfs, added btrfs_
prefix to the function (as it's now in utils.c) and added the remaining
nodesizes to tests. Queued for 3.19.1.
