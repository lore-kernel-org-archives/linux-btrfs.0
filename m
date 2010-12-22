From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/6] random bugfixes of the space management
Date: Wed, 22 Dec 2010 14:27:13 -0500
Message-ID: <1293045976-sup-8544@think>
References: <4D11D72C.7010704@cn.fujitsu.com> <20101222192254.GB1669@dhcp231-156.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101222192254.GB1669@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2010-12-22 14:22:54 -0500:
> On Wed, Dec 22, 2010 at 06:47:08PM +0800, Miao Xie wrote:
> > Hello,
> > 
> > I have a bunch of random fixes of the space management in
> > 
> > git://repo.or.cz/linux-btrfs-devel.git space-manage
> > 
> > They are the ENOSPC fixes, as well as fixes for df command.
> > The first one and the last one fixed the wrong free space information reported
> > by df command. The second one fixed ENOSPC when there is tiny space in the
> > filesystem. And The third fixed wrong calculation of stripe size. And the 4th
> > and 5th patches fixed the chunk allocation problem when the block devices have
> > no enough space to allocate a default-size chunk.
> >
> 
> I'll review the rest of them when I have more time, thanks for these Miao.

For now they are going with the new compression code into a new branch
for 2.6.38 in my git tree.  I might have to rebase as patches are added
and removed, but these will all go in.

-chris
