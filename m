Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965836AbcCPKOh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 06:14:37 -0400
Date: Wed, 16 Mar 2016 11:14:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: Re: [PATCH] btrfs: rename btrfs_std_error() to
 btrfs_handle_fs_error()
Message-ID: <20160316101411.GI21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
 <1458117788-840-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458117788-840-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 16, 2016 at 04:43:06PM +0800, Anand Jain wrote:
> btrfs_std_error() handles errors, puts FS into readonly mode
> (as of now). So its good idea to rename it to btrfs_handle_fs_error().
> So that bugs like
>   btrfs: pass the error code to the btrfs_std_error and log ret
> (in the ML) may be avoided.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>

btrfs_handle_fs_error is much better.
