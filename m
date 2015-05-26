Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbbEZPYN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 11:24:13 -0400
Date: Tue, 26 May 2015 17:24:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/4] btrfs-progs: Minor change of change_uuid().
Message-ID: <20150526152411.GL23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1431671306-22262-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 15, 2015 at 02:28:23PM +0800, Qu Wenruo wrote:
> Change the change_uuid():
> 1) Remove new_chunk_tree_uuid para
> As chunk_tree_uuid is only internal used, no need to manual specify it.
> Use random generated UUID instead.
> 
> 2) Don't use heap allocated memory for fs_info->new_fsid/chunk_tree_id.
> It's easy to forgot free or double free heap memory.
> Use stack memory instead.
> (In fact, I forgot to free them in previous patchset)
> 
> 3) Print dst fsid.
> As now it's possible to change fsid to random uuid, it's better to print
> it out.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

All of the patchset applied, thanks!
