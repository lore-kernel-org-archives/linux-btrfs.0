Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaK0RV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Nov 2014 12:21:26 -0500
Date: Thu, 27 Nov 2014 18:21:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: boris <6401e46d@opayq.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: File test operator for subvols; possible bug in 'btrfs show
 <directory>'
Message-ID: <20141127172125.GC12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <loom.20141125T024507-20@post.gmane.org>
 <54743094.8050200@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54743094.8050200@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 08:32:36AM +0100, Goffredo Baroncelli wrote:
> On 11/25/2014 03:11 AM, boris wrote:
> > Hi all,
> > 
> > I was looking for a quick method of testing whether a working directory is a 
> > subvolume.
> 
> Currently btrfs check that:
> - the inode number is 255

It's 256.

>         return (st.st_ino == 256) && S_ISDIR(st.st_mode);

The shell test to identify a subvolume is

[ -d "$dir" -a `stat --format=%i "$dir"` = 256
