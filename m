Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:39369 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3GXB1j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 21:27:39 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 905FB9A06C0
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 19:27:39 -0600 (MDT)
Date: Tue, 23 Jul 2013 21:27:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jerome Haltom <wasabi@cogito.cx>
CC: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Q: Why subvolumes?
Message-ID: <20130724012737.GB30875@localhost.localdomain>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
 <20130723150620.GG20517@carfax.org.uk>
 <51EEC1BD.9030001@gmail.com>
 <20130723193013.GI20517@carfax.org.uk>
 <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
 <79612879-8561-4924-B996-570B8594237F@colorremedies.com>
 <CA+V+5QoSFZOc_nekBUQQSQo+wn5mNaqJNDuq=kwU23a01Nn1Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+V+5QoSFZOc_nekBUQQSQo+wn5mNaqJNDuq=kwU23a01Nn1Kw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 23, 2013 at 06:39:57PM -0500, Jerome Haltom wrote:
> Yeah. I was merely curious about the architecture limits that drove
> the design this way, to begin with. Mostly because it seems "odd". It
> seems like the most obvious and most natural thing from the user's
> perspective to do would just be able to reflink directories. Like
> every decent source control system that exists, for instance. So, I
> figured there must be some very good reason it wasn't done like that.
> 
> I'm still not completely sure what that very good reason is. Obviously
> whatever structure that currently exists for subvolumes would need to
> continue existing, to begin a unique inode scope. But, since
> apparently the VFS can be instructed to plop a new dev_id anywhere in
> the hierarchy, I I still don't see why explicit subvolumes are
> required. Seems more natural to be able to put a quota on a directory.
> To be able to set raid policy on a directory. Compression on a
> directory. COW semantics on a directory. Etc.
> 
> Ahh well, some of you gave really nice detailed answers, and I
> appreciate that. Thanks.
>

Subvolumes are described as directories simply to make it easier to understand.
Directories do not change the heirarchy within the file system itself, they are
simply items in the btree like anything else, they are not special at all.
Subvolumes are _represented_ as directories, but really the directories are just
links to subvolumes.  Subvolumes are a completely separate b-tree, it has it's
own locking, it's own inode numbering and everything.  And this isn't inode
numbering for the sake of inode numbering, our inode numbers are picked by
simply being the next largest objectid we can add to our tree.  Since a
subvolume is it's own tree it's inode numbers start over at the begining.

So it's not that we can just fork off a directory and snapshot there, because
it's not a tree, it's just an item.  A subvolume is its own tree, which can be
snapshotted and locked independantly from the other subvolumes.  Thanks,

Josef 
