Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:40514 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3AXWgy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 17:36:54 -0500
Date: Thu, 24 Jan 2013 17:36:52 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: "kreijack@inwind.it" <kreijack@inwind.it>
CC: Eric Sandeen <sandeen@redhat.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, "gene@czarc.net" <gene@czarc.net>
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
Message-ID: <20130124223652.GI10162@shiny.int.fusionio.com>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-2-git-send-email-anand.jain@oracle.com>
 <5100BB01.3030408@redhat.com>
 <5100FDA3.3040907@giantdisaster.de>
 <510175F7.5080806@gmail.com>
 <51018EBA.60201@redhat.com>
 <5101B131.6010804@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5101B131.6010804@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 24, 2013 at 03:09:53PM -0700, Goffredo Baroncelli wrote:
> On 01/24/2013 08:42 PM, Eric Sandeen wrote:
> > On 1/24/13 11:57 AM, Goffredo Baroncelli wrote:
> >> On 01/24/2013 10:23 AM, Stefan Behrens wrote:
> >>> On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
> >>>> instead of renaming&   keeping the btrfsctl.c copy
> >>>
> >>> There is a new momentum to improve the Btrfs-progs quality :)
> >>>
> >>> IMO, one step is to get rid of the legacy tools and sources. It
> >>> wastes time to maintain them and these old tools cause confusion.
> >>> btrfsctl.c, btrfs-vol.c and btrfs-show.c are not needed anymore.
> >>> Please correct me if there are plans to use these old tools in
> >>> future Linux distributions. The "btrfs" tool replaces the legacy
> >>> "btrfsctl", "btrfs-vol" and "btrfs-show" tools. Below, the usage
> >>> text of the old tools is quoted. All these tasks are also offered
> >>> in the "btrfs" tool, and this tool is the newer one.
> >>
> >> I fully agree: btrfsctl, btrfs-vol, btrfs-show are perfectly
> >> replaced by by btrfs. Moreover time to time the patches are more
> >> complex than the needing because exists these "legacy" programs.
> >>
> >> I checked the debian package, and to me seems that there is no need
> >> of {btrfsctl,btrfs-vol,btrfs-show}
> >
> > Hm, they are shipped in the Fedora package.
> 
> The same is true for the debian package, but are these used in Fedora ?
> 
> >
> > For backwards compat, could those be turned into shell scripts which
> > invoke the btrfs tool?
> 
> I don't see any gain to maintains a script bash (which has to be written 
> from scratch) instead of maintains the current C code.
> 
> These programs were deprecated two years ago [1]. If some distribution 
> need them, could maintain them as separate patch. But I think that the 
> mainstream should remove.

I'd say that if SuSE or oracle depend on them we keep them.  Otherwise,
I'm fine with removing them or just making the 3 line bash script.

-chris

