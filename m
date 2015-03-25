Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:49265 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbCYLVu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 07:21:50 -0400
Date: Wed, 25 Mar 2015 12:21:47 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Recursive subvolume snapshots and deletion?
Message-ID: <20150325112147.GB21533@gardel-login>
References: <20150323045718.GE19498@gardel-login>
 <1427114207.5707.2@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427114207.5707.2@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 23.03.15 08:36, Chris Mason (clm@fb.com) wrote:

> On Mon, Mar 23, 2015 at 12:57 AM, Lennart Poettering <mzerqung@0pointer.de>
> wrote:
> >Heya!
> >
> >So what's the story on recursive btrfs snapshotting and snapshot
> >removal? Since a while systemd has now by default creating btrfs
> >subvolumes for /var/lib/machines for example. Now, if that code is run
> >inside a container, and the container itself already is stored in a
> >subvolume we end up with a subvolume inside a subvolume, which
> >currently breaks snapshotting and deletion of the outer container
> >subvolume.
> >
> >What's the plan regarding recursive versions of the operations? Any
> >plan to add this? We could work around this in userspace, of course,
> >but it would not be atomic, and I'd much prefer if the kernel could do
> >this on its own!
> 
> Hi Lennart,
> 
> I've got a patch to btrfs-progs that can do the recursive snapshotting, let
> me clean it up and submit to Dave.  For recursive deletion I think the same
> method can be used.

OK, so this means you want this to be solved in userspace, hence in a
non-atomic fashion?

What precisely will your code do? Enumerate the subvolumes and simply
snapshot all subvolumes below the desired path? Or anything smarter?

Lennart

-- 
Lennart Poettering, Red Hat
