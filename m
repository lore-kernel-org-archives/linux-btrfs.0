Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbbEMQOW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 12:14:22 -0400
Date: Wed, 13 May 2015 18:14:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, lukas.lueg@gmail.com
Subject: Re: [PATCH 2/4] btrfs-progs: Read the whole superblock instead of
 struct btrfs_super_block.
Message-ID: <20150513161420.GO23255@twin.jikos.cz>
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

We've been there already:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/36563

IIRC it caused a bug on PPC64 machine but I don't have it at hand right
now.
