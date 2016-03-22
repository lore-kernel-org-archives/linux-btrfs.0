Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbcCVQLd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 12:11:33 -0400
Date: Tue, 22 Mar 2016 17:11:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/6 v3] btrfs-progs: subvolume functions reorg
Message-ID: <20160322161103.GF29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458544865-16467-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 03:20:59PM +0800, Anand Jain wrote:
> We need subvolume helper functions easily accessible for features
> around subvolume. This patch set is just a cleanup of subvolume
> functions.
> 
> This is tested fine with fstests group subvol and subvol hand tests.
> 
> v3: Separate changes into 6 commits,
>     Drops the idea of creating subvolume.c, instead update utils.c.
>     Adds 1/5 a minor func mv and 3/5 remove of a duplicate func and
>     6/6 rename of get_subvol_name as per review comment.
> 
> v2: Update commit log. Separate this patch from the encryption
>     patch set.
> 
> 
> Anand Jain (6):
>   btrfs-progs: spatial rearrange subvolume functions together
>   btrfs-progs: move test_issubvolume() to utils.c
>   btrfs-progs: remove duplicate function __is_subvol()
>   btrfs-progs: move get_subvol_name() to utils.c
>   btrfs-progs: create get_subvol_info()
>   btrfs-progs: rename get_subvol_name() to subvol_minus_mnt()

Applied, thanks.
