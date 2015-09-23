Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbbIWN30 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:29:26 -0400
Date: Wed, 23 Sep 2015 15:28:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>, dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923132829.GB12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <56016BB5.6060101@gmail.com>
 <20150922153930.GK5918@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922153930.GK5918@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 03:39:30PM +0000, Hugo Mills wrote:
> > The way I would expect things to work is that a new subvolume
> > inherits it's properties from it's parent (if it's a snapshot),
> 
>    Definitely this.
> 
> > or
> > from the next higher subvolume it's nested in.
> 
>    I don't think I like this. I'm not quite sure why, though, at the
> moment.

I don't like inheritance from other than the parent subvolume because
this makes things less obvious.

>    It definitely makes the process at the start of allocating a new
> block group much more complex: you have to walk back up through an
> arbitrary depth of nested subvols to find the one that's actually got
> a replication policy record in it. (Because after this feature is
> brought in, there will be lots of filesystems without per-subvol
> replication policies in them, and we have to have some way of dealing
> with those as well).
> 
>    With an FS default policy, you only need check the current subvol,
> and then fall back to the FS default if that's not found.

That looks reasonable to me.

>    These things are, I think, likely to be lightly used: I would be
> reasonably surprised to find more than two or possibly three storage
> policies in use on any given system with a sane sysadmin.

Agreed. At the moment I'm thinking about all the configuration
possibilites we want to give to the users. Eg. the inheritance can be
configurable on the property level.

The usecase: the toplevel has compression enabled but I don't want any
new subvolume share this property automatically.

(The blockgroup type is probably a bad example for configurable
inheritance as it would not work for shared extents if the type is
different.)

>    I'm actually not sure what the interactions of multiple storage
> policies are going to be like. It's entirely possible, particularly
> with some of the more exotic (but useful) suggestions I've thought of,
> that the behaviour of the FS is dependent on the order in which the
> block groups are allocated. (i.e. "20 GiB to subvol-A, then 20 GiB to
> subvol-B" results in different behaviour than "1 GiB to subvol-A then
> 1 GiB to subvol-B and repeat"). I tried some simple Monte-Carlo
> simulations, but I didn't get any concrete results out of it before
> the end of the train journey. :)
> 
> >  This would obviate
> > the need for some special 'default' properties, and would be
> > relatively intuitive behavior for a significant majority of people.
> 
>    Of course, you shouldn't be nesting subvolumes anyway. It makes
> it much harder to manage them.

Depends, there are valid usecases for nested subvolumes but yeah, the
management is harder.
