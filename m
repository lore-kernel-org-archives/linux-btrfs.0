Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbcCHT4p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 14:56:45 -0500
Date: Tue, 8 Mar 2016 11:58:57 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Tobias Hunger <tobias.hunger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and containers
Message-ID: <20160308195857.GB26981@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
 <CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 07, 2016 at 04:45:09PM -0700, Chris Murphy wrote:
> On Mon, Mar 7, 2016 at 3:55 PM, Tobias Hunger <tobias.hunger@gmail.com> wrote:
> > Hi,
> >
> > I have been running systemd-nspawn containers on top of a btrfs
> > filesystem for a while now.
> >
> > This works great: Snapshots are a huge help to manage containers!
> >
> > But today I ran btrfs subvol list . *inside* a container. To my
> > surprise I got a list of *all* subvolumes on that drive. That is
> > basically a complete list of containers running on the machine. I do
> > not want to have that kind of information exposed to my containers.
> >
> > Is there a way to stop btrfs from listing subvolumes "above" the
> > current location? So that "btrfs subvol list /" in a container will
> > only show subvolumes that are set up in the container?

That's a good question.

Looks like that "btrfs subvolume list -o" match the needs here.

> 
> I'm not sure whether this is something that goes in Btrfs proper,
> since this is presumably a privileged container? The same thing
> happens with Docker containers. One way to do this is if it's not
> privileged, as non-root can't list subvolumes. I think some work is
> needed to make it possible for users to list subvolumes they own.
> Right now a user can create a subvolume but then now list or get
> information on it. By default they can't delete it either unless a
> special mount option is used. So I think there's work that's needed
> one way or another, and maybe in more than one part.

Unfortunately, btrfs subvolume list 's various usage is built on top of TREE_SEARCH ioctl 
which requires CAP_SYS_ADMIN.

So what we need here might be to teach 'btrfs sub list' to recognize
container's CAP_SYS_XXX (if this is possible?) 

Thanks,

-liubo

> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
