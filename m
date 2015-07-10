Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbbGJLGz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jul 2015 07:06:55 -0400
Date: Fri, 10 Jul 2015 13:06:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Byongho Lee <bhlee.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unused mutex from struct 'btrfs_fs_info'
Message-ID: <20150710110654.GB726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1436501426-29202-1-git-send-email-bhlee.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436501426-29202-1-git-send-email-bhlee.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 10, 2015 at 01:10:26PM +0900, Byongho Lee wrote:
> The code using 'ordered_extent_flush_mutex' mutex has removed by below
> commit.
>  - 8d875f95da43c6a8f18f77869f2ef26e9594fecc
>    btrfs: disable strict file flushes for renames and truncates
> But the mutex still lives in struct 'btrfs_fs_info'.
> 
> So, this patch removes the mutex from struct 'btrfs_fs_info' and its
> initialization code.
> 
> Signed-off-by: Byongho Lee <bhlee.kernel@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
