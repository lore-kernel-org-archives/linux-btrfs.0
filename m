Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3AXSNK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 13:13:10 -0500
Date: Thu, 24 Jan 2013 19:13:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/13] Btrfs-progs: more patches for integration
 (integration-20130121)
Message-ID: <20130124181308.GT28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <20130121184016.GC7971@twin.jikos.cz>
 <50FEF32B.6050005@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FEF32B.6050005@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 03:14:35PM -0500, Gene Czarcinski wrote:
> On 01/21/2013 01:40 PM, David Sterba wrote:
> >On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
> >>>I have done some additional scraping of the mailing list to
> >>>identify some "low hanging fruit" which I consider should
> >>>be merged into the btrfs-progs repository.
> >Thanks, I went through them and put together into an integration branch
> >
> >   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121
> There is a problem with one of the patches:
>     detect if the disk we are formatting is a ssd
> 
> The commit comments appear to come from the patch I submitted. However, as I
> said in the submission, the patch for mkfs.c has to be "refitted" because of
> a conflict.  The conflict is a result of the patch:
>     Fix compiler warnings on PPC64
> which relocated the include "kerncompat.h" to a different line in the mkfs.c
> file.

These merge conflicts are inevitable and normal (though sometimes not
that trivial). My initial aim was to build one linear branch only with
fixes and git-merge the patches that add features, but this will not be
easy to merge for much longer, so I'm going to do a linear integration
branch so others can take them as checkpoint to base the various
patchsets.


david
