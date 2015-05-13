Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934424AbbEMN4k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 09:56:40 -0400
Date: Wed, 13 May 2015 15:56:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/13]  Introduce offline fsid/chunk tree uuid change
 for btrfstune.
Message-ID: <20150513135638.GK23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 04:08:41PM +0800, Qu Wenruo wrote:
> This patchset will introduce offline fsid/chunk tree uuid change
> function to 'btrfs property' command, with "fsid" and "chunk_tree_uuid"
> respectively.

One more thing: the goal is to change the filesystem uuid, the chunk
tree uuid should be changed as well. But I think both uuids have to be
changed at the same time and the chunk tree uuid should be generated
randomly as it's entirely internal value.

> To avoid such problem, we introduce new btrfs super flags:
> BTRFS_SUPER_FLAG_CHANGING_FSID and BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID

Based on that, the separate BTRFS_SUPER_FLAG_CHANGING_CHUNK_TREE_ID flag
does not make sense and could be dropped.
