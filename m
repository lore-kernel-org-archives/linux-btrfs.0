Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab3AXWtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 17:49:23 -0500
Date: Thu, 24 Jan 2013 23:49:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        Eric Sandeen <sandeen@redhat.com>,
        Goffredo Baroncelli <kreijack@gmail.com>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, "gene@czarc.net" <gene@czarc.net>
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
Message-ID: <20130124224920.GX28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-2-git-send-email-anand.jain@oracle.com>
 <5100BB01.3030408@redhat.com>
 <5100FDA3.3040907@giantdisaster.de>
 <510175F7.5080806@gmail.com>
 <51018EBA.60201@redhat.com>
 <5101B131.6010804@tiscalinet.it>
 <20130124223652.GI10162@shiny.int.fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124223652.GI10162@shiny.int.fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 24, 2013 at 05:36:52PM -0500, Chris Mason wrote:
> On Thu, Jan 24, 2013 at 03:09:53PM -0700, Goffredo Baroncelli wrote:
> > The same is true for the debian package, but are these used in Fedora ?
> > > For backwards compat, could those be turned into shell scripts which
> > > invoke the btrfs tool?
> > 
> > I don't see any gain to maintains a script bash (which has to be written 
> > from scratch) instead of maintains the current C code.
> > 
> > These programs were deprecated two years ago [1]. If some distribution 
> > need them, could maintain them as separate patch. But I think that the 
> > mainstream should remove.
> 
> I'd say that if SuSE or oracle depend on them we keep them.  Otherwise,
> I'm fine with removing them or just making the 3 line bash script.

I wanted to remove them once from our packages, but some tool uses them.
I'm fine with replacing them with a shellscript, this is just a
syntactic conversion from btrfsctl style to the subcommands.


david
