From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL][PATCH v2 0/6] btrfs: Add lzo compression support
Date: Fri, 24 Dec 2010 07:32:16 -0500
Message-ID: <1293193867-sup-1552@think>
References: <4CE48ABB.5070302@cn.fujitsu.com> <AANLkTi=jGNaV-Sm+GsCHtwGx1UkG8bUyvGgz+2KLPgUT@mail.gmail.com> <4D1443F9.4040001@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D1443F9.4040001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2010-12-24 01:55:53 -0500:
> cwillu wrote:
> > On Wed, Nov 17, 2010 at 8:08 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >> Hi Chris,
> >>
> >> Here's the updated patchset. As I still haven't got a kernel.org
> >> account, I have set up a git tree in another public git repository,
> >> and I'll use it for now.
> >>
> >> You can pull from:
> >>
> >>        git://repo.or.cz/linux-btrfs-devel.git lzo-support

I pulled this in last night and an all night run completed without
troubles.  I'm trying a few more this morning, but it looks really good.

I think I'll also bump the compressed extent size up to 512KB, which
will cut down on the number of extents in files that compress well.

-chris
