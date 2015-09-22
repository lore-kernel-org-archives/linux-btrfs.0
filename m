Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683AbbIVOY3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:24:29 -0400
Date: Tue, 22 Sep 2015 16:23:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150922142333.GH12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20150922134131.GH5918@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 01:41:31PM +0000, Hugo Mills wrote:
> On Tue, Sep 22, 2015 at 03:36:43PM +0200, Holger Hoffstätte wrote:
> > On 09/22/15 14:59, Jeff Mahoney wrote:
> > (snip)
> > > So if they way we want to prevent the loss of raid type info is by
> > > maintaining the last block group allocated with that raid type, fine,
> > > but that's a separate discussion.  Personally, I think keeping 1GB
> > 
> > At this point I'm much more surprised to learn that the RAID type can
> > apparently get "lost" in the first place, and is not persisted
> > separately. I mean..wat?
> 
>    It's always been like that, unfortunately.
> 
>    The code tries to use the RAID type that's already present to work
> out what the next allocation should be. If there aren't any chunks in
> the FS, the configuration is lost, because it's not stored anywhere
> else. It's one of the things that tripped me up badly when I was
> failing to rewrite the chunk allocator last year.

Yeah, right now there's no persistent default for the allocator. I'm
still hoping that the object properties will magically solve that.
