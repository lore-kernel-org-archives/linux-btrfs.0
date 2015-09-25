Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210AbbIYUvW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 16:51:22 -0400
Date: Fri, 25 Sep 2015 22:50:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: Read the whole superblock instead of
 struct btrfs_super_block.
Message-ID: <20150925205024.GR11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1431508536-7275-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431508536-7275-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 05:15:34PM +0800, Qu Wenruo wrote:
> Before the patch, btrfs-progs will only read
> sizeof(struct btrfs_super_block) and restore it into super_copy.
> 
> This makes checksum check for superblock impossible.
> Change it to read the whole superblock.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

I've applied this despite there are the issues on ppc64. This patch is
required for the extended superblock checks in the next patch.
