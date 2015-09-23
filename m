Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbbIWNi1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:38:27 -0400
Date: Wed, 23 Sep 2015 15:37:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923133730.GC12815@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <20150923131226.GA12815@twin.jikos.cz>
 <5602A6EA.8050107@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5602A6EA.8050107@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 23, 2015 at 09:19:38PM +0800, Qu Wenruo wrote:
> >  From the UI point, we proposed to add a specifier that would route the
> > property to either subvolume or the filesystem:
> >
> > $ btrfs prop set -t filesystem bgtype raid0
> > $ btrfs prop set -t subvolume bgtype raid1
> 
> BTW, is btrfs going to support different chunk/bg type for subvolume?!

People have been asking for that for years.

> I thought data/meta/system chunk types are all per filesystem level,
> and was planning to use superblock to record it...

Any superblock change like that will lead to backward incompatibilities
worse than just storing some key:value as an extended attribute. Older
kernels will just ignore the constraints but will be still
mountable/usable.

> If really to support that, does it mean we will have different meta/data 
> type for each subvolume?
> That's a little too flex for me....

btrfs design is ready for this kind of flexibility. The hard task is to
stay sane and offer somethig flexible yet manageable.
