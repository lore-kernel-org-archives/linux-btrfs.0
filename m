Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52714 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbcBCKuy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Feb 2016 05:50:54 -0500
Date: Wed, 3 Feb 2016 11:50:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.cz, calestyo@scientia.net,
        ahferroin7@gmail.com, 1i5t5.duncan@cox.net
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
Message-ID: <20160203105038.GL31992@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com>
 <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com>
 <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com>
 <56581742.9030308@oracle.com>
 <565A5317.8040506@gmx.com>
 <565BD67B.9090007@oracle.com>
 <565BE2A7.8050501@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <565BE2A7.8050501@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Going back to this discussion,

On Mon, Nov 30, 2015 at 01:46:15PM +0800, Qu Wenruo wrote:
> To be honest, how many guys really unhappy with current default features 
> behavior *except* you?

Me too.

Anand's summary matches my view of how we should do it:

". Do it at run time for the running kernel. Current. In the order of
   priority .. check sysfs, if not check kernel-version, if not use
   progs-version-based-defaults (original)."

I understand that the the kernel version is not always reliable, but
when we use it only as a fallback we know that at least kernel of this
upstream version can mount the filesystem.

And becase we can turn on additional features later this should not be a
blocker.

I disagree with your view that the weight should be put on the distro
integrators. I've been packaging btrfs-progs for the SLES and openSUSE,
several product lines with different kernels (upstream and backports).
Keeping the features in sync with kernel started to be an issue with the
first incompat feature that was different among the kernels. And we want
change the defaults further.

The main user bases that I take into account:

* upstream community, ie. the latest stable version or the git version
* older stable trees, ie. 3.2, 3.14 up to 4.1
* heavy backports to enterprise kernels, arbitrary base version

My idea of the default behaviour is to be able to use latest btrfs-progs
(released or git) on any of them and minimize possible damage. Ie.
respect the running kernel and try to best detect the features.

Besides ancient kernels and the 3.2 that's still in use, the sysfs based
detection should work.

> Or how many bug report in maillist/bugzilla is about that?
> 
> Introducing a new feature matrix only to change the behavior to your flavor?
> Isn't this what you called "bloated intelligence"?

I'm not sure why you see the feature matrix getting more complicated.
The testeres and developers know what features to turn on if desired,
testing recent kernel with recent progs will do the right thing on
itself.  The rest of the user are supposed to just install and use it.
