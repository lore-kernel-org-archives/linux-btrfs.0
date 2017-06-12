Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37531 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755228AbdFLPsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:48:51 -0400
Date: Mon, 12 Jun 2017 17:47:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Sargun Dhillon <sargun@sargun.me>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Convert btrfs_fs_info's free_chunk_space to an
 atomic64_t
Message-ID: <20170612154741.GQ25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170607180930.GA12551@ircssh-2.c.rugged-nimbus-611.internal>
 <612dbf16-32df-25ea-331f-f5147035d5f6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <612dbf16-32df-25ea-331f-f5147035d5f6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 09, 2017 at 09:44:31AM +0300, Nikolay Borisov wrote:
> 
> 
> On  7.06.2017 21:09, Sargun Dhillon wrote:
> > This patch is a small performance optimization to get rid of a spin
> > lock, where instead an atomic64_t can be used.
> > 
> > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> 
> I've already sent similar patch 1 month ago:
> 
> https://patchwork.kernel.org/patch/9720999/

Another hint is to look to the linux-next or to my kernel.org for-next
branch.
