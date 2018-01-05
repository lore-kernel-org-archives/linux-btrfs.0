Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751400AbeAEO2O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 09:28:14 -0500
Date: Fri, 5 Jan 2018 15:26:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add missing BTRFS_SUPER_FLAG define
Message-ID: <20180105142606.GO3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180105092422.9794-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180105092422.9794-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 05, 2018 at 05:24:22PM +0800, Anand Jain wrote:
> btrfs-progs uses additional two super flag bits. So just define
> that so that we know its been used.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> The btrfs-progs commits (very old) introduced them,
> 
>  commit 7cc792872a133cabc3467e6ccaf5a2c8ea9e5218
>     btrfs-progs: Add CHANGING_FSID super flag
> 
>  commit 797a937e5dd8db0092add633a80f3cd698e182df
>     Btrfs-progs: Introduce metadump_v2
> 
> Appears that we need bit of support from the kernel side like
> failing to mount if CHANGING_FSID is set. And device mounted
> with metadump_v2 flag is kind of broken on the kernel side
> as of now, this patch does not fix those.

Please add the code that uses the flags, at least the for the pending
uuid change.
