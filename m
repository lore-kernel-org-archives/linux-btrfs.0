Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53723 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965028AbcBDBnJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Feb 2016 20:43:09 -0500
Date: Wed, 3 Feb 2016 20:42:17 -0500
From: Chris Mason <clm@fb.com>
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>, <ahferroin7@gmail.com>,
        <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
Message-ID: <20160204014217.ayepjdzs2ig23bc3@floor.thefacebook.com>
References: <5656AC64.3030304@cn.fujitsu.com>
 <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com>
 <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com>
 <56581742.9030308@oracle.com>
 <565A5317.8040506@gmx.com>
 <565BD67B.9090007@oracle.com>
 <565BE2A7.8050501@gmx.com>
 <20160203105038.GL31992@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160203105038.GL31992@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03, 2016 at 11:50:38AM +0100, David Sterba wrote:
> Going back to this discussion,
> 
> On Mon, Nov 30, 2015 at 01:46:15PM +0800, Qu Wenruo wrote:
> > To be honest, how many guys really unhappy with current default features 
> > behavior *except* you?
> 
> Me too.
> 
> Anand's summary matches my view of how we should do it:
> 
> ". Do it at run time for the running kernel. Current. In the order of
>    priority .. check sysfs, if not check kernel-version, if not use
>    progs-version-based-defaults (original)."
> 
> I understand that the the kernel version is not always reliable, but
> when we use it only as a fallback we know that at least kernel of this
> upstream version can mount the filesystem.
> 
> And becase we can turn on additional features later this should not be a
> blocker.
> 
> I disagree with your view that the weight should be put on the distro
> integrators. I've been packaging btrfs-progs for the SLES and openSUSE,
> several product lines with different kernels (upstream and backports).
> Keeping the features in sync with kernel started to be an issue with the
> first incompat feature that was different among the kernels. And we want
> change the defaults further.
> 
> The main user bases that I take into account:
> 
> * upstream community, ie. the latest stable version or the git version
> * older stable trees, ie. 3.2, 3.14 up to 4.1
> * heavy backports to enterprise kernels, arbitrary base version
> 
> My idea of the default behaviour is to be able to use latest btrfs-progs
> (released or git) on any of them and minimize possible damage. Ie.
> respect the running kernel and try to best detect the features.
> 
> Besides ancient kernels and the 3.2 that's still in use, the sysfs based
> detection should work.

I do agree with Dave here, and usually defer to the people making
distros on these kinds of things.  I want to make sure it is very
easy for distros to upgrade to the latest progs without worrying about
configuring the exact set of features their kernels currently support.
Yes, they can spent extra time patching progs, but we want to limit the
amount of work each progs update forces them to do.

But we also need to make sure it's obvious to the user which features
have been enabled, and how btrfs-progs went about making that decision.
It should also be easy for people packaging btrfs to override those
decisions based on their distro kernel.

-chris
