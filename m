Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481AbbD0K7b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 06:59:31 -0400
Date: Mon, 27 Apr 2015 12:59:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
Message-ID: <20150427105929.GT4996@suse.cz>
Reply-To: dsterba@suse.cz
References: <1429837961-2255-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150424150507.GQ4996@twin.jikos.cz>
 <553D8216.8090503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <553D8216.8090503@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 27, 2015 at 08:25:58AM +0800, Qu Wenruo wrote:
> 
> 
> -------- Original Message  --------
> Subject: Re: [PATCH v2 1/2] btrfs: Fix superblock csum type check.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年04月24日 23:05
> 
> > On Fri, Apr 24, 2015 at 09:12:40AM +0800, Qu Wenruo wrote:
> >> --- a/fs/btrfs/ctree.h
> >> +++ b/fs/btrfs/ctree.h
> >> @@ -173,6 +173,7 @@ struct btrfs_ordered_sum;
> >>
> >>   /* csum types */
> >>   #define BTRFS_CSUM_TYPE_CRC32	0
> >> +#define BTRFS_CSUM_LAST_TYPE	0
> >>
> >>   static int btrfs_csum_sizes[] = { 4, 0 };
> >
> > I'd prefer to fix it by removing the 0 from btrfs_csum_sizes instead of
> > introducing a define.
> >
> 
> Removing the zero seems not help for this case, as some one can still
> craft a strange csum_type to access outside the array.

The ARRAY_SIZE will be 1, so if a crafted csum will be anything than 0,
then the check will catch it, no?

> So I introduce the new macro and use the new macro to compare with 
> csum_type without acess the array.

The macro serves the same purpose as the ARRAY_SIZE macro and is always
in sync with the btrfs_csum_size.
