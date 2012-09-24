Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:32919 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab2IXNyh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 09:54:37 -0400
Date: Mon, 24 Sep 2012 15:53:52 +0200
From: David Sterba <dave@jikos.cz>
To: Jp Wise <jpwise@theflat.net.nz>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
Message-ID: <20120924135352.GF14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <505D32C2.8070105@theflat.net.nz>
 <505D6D87.1070403@gmx.net>
 <505E3412.4010900@theflat.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505E3412.4010900@theflat.net.nz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 23, 2012 at 09:56:34AM +1200, Jp Wise wrote:
> >Afaik without playing with it myself fiemap can give you information
> >about the mappings of each file. If the mappings of 2 files match,
> >the data is shared.
> OK, have just done some searching on fiemap and located a code example using
> it to pull the file extent data.
> http://smackerelofopinion.blogspot.com/2010/01/using-fiemap-ioctl-to-get-file-extents.html
> Will have a play around to see if i might be able to hack it up to compare
> two files, or just parse it's output between two files to identify matches.
> Thank you for the pointer. :)
> 
> Likewise if anyone else knows of an existing utility to do a non-bytewise
> compare between two files, and just check if they share the same datablocks
> please let me know. :)

The FIEMAP is a way with stable and defined interface to show file
extents, there's the filefrag utility (from e2fsprogs). It does not
have a parser-friendly output, so you may want to call the ioctl
directly. The key information is in the (struct
fiemap_extent)->fe_physical field. If physical block ranges from two
files overlap, they're shared.

There's another way how to get the extent info, via btrfs' SEARCH_TREE
ioctl, but it's more low-level and needs basic knowledge about the
internal b-tree items and how they're linked together.

david
