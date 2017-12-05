Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752373AbdLESLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 13:11:25 -0500
Date: Tue, 5 Dec 2017 19:09:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] Btrfs: make raid6 rebuild retry more
Message-ID: <20171205180925.GO3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171204224037.7556-1-bo.li.liu@oracle.com>
 <20171204224037.7556-4-bo.li.liu@oracle.com>
 <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ab2da20-6294-67a4-2ef3-6a65afed0fc6@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 04:07:35PM +0800, Qu Wenruo wrote:
> > @@ -2166,11 +2166,21 @@ int raid56_parity_recover(struct btrfs_fs_info *fs_info, struct bio *bio,
> >  	}
> >  
> >  	/*
> > -	 * reconstruct from the q stripe if they are
> > -	 * asking for mirror 3
> > +	 * Loop retry:
> > +	 * for 'mirror == 2', reconstruct from all other stripes.
> 
> What about using macro to makes the reassemble method more human readable?

Yeah, that's definetelly needed and should be based on
BTRFS_MAX_MIRRORS, not just hardcoded to 3.
