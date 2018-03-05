Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbeCEVhF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 16:37:05 -0500
Date: Mon, 5 Mar 2018 22:34:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: verify max_inline mount parameter
Message-ID: <20180305213444.GH5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180215164338.GC10193@twin.jikos.cz>
 <20180226024704.15567-1-anand.jain@oracle.com>
 <20180227154538.GB27791@twin.jikos.cz>
 <f744e050-f05d-623d-eaa5-4d5079af19a5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f744e050-f05d-623d-eaa5-4d5079af19a5@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 01, 2018 at 07:51:23PM +0800, Anand Jain wrote:
> >> @@ -605,7 +605,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >>   		case Opt_max_inline:
> >>   			num = match_strdup(&args[0]);
> >>   			if (num) {
> >> -				info->max_inline = memparse(num, NULL);
> >> +				char *retptr;
> >> +
> >> +				info->max_inline = memparse(num, &retptr);
> > 
> > I missed it in the patch that changed max_inline to u32, memparse
> > returns unsigned long long, so this is not entrely correct and requires
> > a temporary variable.
> > 
> > We should also report if the user-specified value is larger than
> > BTRFS_MAX_METADATA_BLOCKSIZE .
> 
> (Got diverted into something else. Sorry for the delay.)
> 
> Currently -o max_line can be only upto sectorsize.
> 
> We have MAX_INLINE_EXTENT_BUFFER_SIZE which is 64K and is equal to 
> BTRFS_MAX_METADATA_BLOCKSIZE (also 64K)

BTRFS_MAX_METADATA_BLOCKSIZE is the limit of nodesize,
MAX_INLINE_EXTENT_BUFFER_SIZE exists only for sanity checking.


> I didn't get the point that max_inline is limited by sector size in the 
> current design. Any idea?

The sectorsize is now mandatory to be equal to the page size, so the
inline file size is rather limited by that.
