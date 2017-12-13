Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50150 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753524AbdLMSqY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Dec 2017 13:46:24 -0500
Date: Wed, 13 Dec 2017 19:44:21 +0100
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] define BTRFS_DEV_STATE
Message-ID: <20171213184421.GE3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171210091522.6061-1-anand.jain@oracle.com>
 <20171212174249.GN3553@twin.jikos.cz>
 <d37abb08-087f-7372-2196-c98b60229b63@oracle.com>
 <20171213022619.GD3553@twin.jikos.cz>
 <CAGqmi77LeXmQCYVKC1wjHycOO12JTzRzcYreX0c2qN+LoEAKxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi77LeXmQCYVKC1wjHycOO12JTzRzcYreX0c2qN+LoEAKxA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 13, 2017 at 12:57:21PM +0300, Timofey Titovets wrote:
> > The kernel.org repository only gets the latest for-next, that is
> > assembled from the pending branches, and also after some testing. You
> > could still find 'misc-next' inside the for-next branch, but it's not
> > obvious.
> >
> > All the development branches are pushed to
> >
> > https://github.com/kdave/btrfs-devel or
> > http://repo.or.cz/linux-2.6/btrfs-unstable.git
> >
> > more frequently than the k.org/for-next is updated. I thought this has
> > become a common knowledge, but yet it's not documented on the wiki so.
> > Let's fix that.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Didn't know about your GitHub copy,
> may be that have sense to update:
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
> 
> And add new links? To:
>  - k.org/for-next
>  - https://github.com/kdave/btrfs-devel or
>  - http://repo.or.cz/linux-2.6/btrfs-unstable.git
> 
> Because current link to
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> looks like a bit outdated.

Wiki updated, the section for kernel git repos was really out of date.
