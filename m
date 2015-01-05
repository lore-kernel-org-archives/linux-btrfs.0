Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46568 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbbAETL6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 14:11:58 -0500
Date: Mon, 5 Jan 2015 20:11:56 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_IOC_TREE_SEARCH ioctl
Message-ID: <20150105191156.GA19373@gardel-login>
References: <20150105171512.GA19126@gardel-login>
 <20150105182238.GE32182@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150105182238.GE32182@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 05.01.15 18:22, Hugo Mills (hugo@carfax.org.uk) wrote:

> On Mon, Jan 05, 2015 at 06:15:12PM +0100, Lennart Poettering wrote:
> > Heya,
> > 
> > I recently added some btrfs magic to systemd's machinectl/nspawn
> > tool. More specifically it can now show the disk usage of a container
> > that is stored in a btrfs subvolume. For that I made use of the btrfs
> > quota logic. To read the current disk usage of a subvolume I took
> > inspiration from btrfs-progs, most specifically the
> > BTRFS_IOC_TREE_SEARCH ioctl(). Unfortunately, documentation for the
> > ioctl seems to to be lacking, but there are some things about it I
> > fail to grok:
> > 
> > What precisely are the semantics of the ioctl, regarding the search
> > key min/max values (the fields of "struct btrfs_ioctl_search_key")? I
> > kinda assumed that setting them would result in in only objects to be
> > returned that are within the min/max ranges. However, that appears not
> > to be the case. At least the min_offset/max_offset setting appears to
> > be ignored?
> 
>    This is an old argument. :)
> 
>    Keys have three parts, so it's plausible (but, in this case, wrong)
> to consider the space you're searching to be a 3-dimensional space of
> (object, type, offset), which seems to be what you're expecting. A
> min, max pair would then define an oblong subset of the keyspace from
> which to retrieve keys.
>
>    However, that's not actually what's happening. Keys are indexed
> within their tree(s) by a concatenation of the items in the key. A
> key, therefore, should be thought of as a single 136-bit integer, and
> the keys are lexically ordered, (object||type||offset), where "||" is
> the concatenation operator. You get every key _lexically ordered_
> between the min and max values. This is a superset of the
> 3-dimensional results above.

Ah, I see. Makes sense.

I figure the comments in btrfs.h next to "struct
btrfs_ioctl_search_key" could use some updating in this regard. They
pretty explicitly suggest that the 3 axis were independent and each
eleent individually would be between the respective min/max when
returning...

Ideally the structure would just have two fields called "max", and
"min" or so, of type btrfs_disk_key, right? In that case I figure the
behaviour would have been clear. It's particular confusing that the
disk key fields appear in a different order than otherwise used and
with the min_transid+max_transid in the middle...

Which brings me to my question: how does {min|max}_transid affect the
search result? Is this axis orthogonal or is it neither?

Thanks for the explanations!

Lennart

-- 
Lennart Poettering, Red Hat
