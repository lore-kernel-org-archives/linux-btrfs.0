From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/file.c:528 on Linux 2.6.31.1
Date: Wed, 7 Oct 2009 11:40:28 -0400
Message-ID: <20091007154028.GI3757@think>
References: <fbd9d3990910070334j2080a579p25c42d23dbee08c0@mail.gmail.com>
 <20091007152557.GG3757@think>
 <fbd9d3990910070835y1247893et7a258bdb6c8c3f0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fbd9d3990910070835y1247893et7a258bdb6c8c3f0a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 07, 2009 at 04:35:37PM +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 7, 2009 at 4:25 PM, Chris Mason <chris.mason@oracle.com> =
wrote:
> > This oops means that we're trying to insert an extent that already
> > exists. =A0I think it is related to the bug in the file clone ioctl=
 that
> > Sage recently fixed. =A0The fix is in the master branch of the
> > btrfs-unstable tree.
>=20
> Thanks for explaining this.  How can I track when this hits vanilla l=
inux-2.6?

It is already included in 2.6.32-rc1.  The master branch of the btrfs
unstable tree is currently based on 2.6.31, so you can just pull it int=
o
a 2.6.31 kernel and you'll get all of the current fixes.

>=20
> > So, I'd say step one is to make a backup of this data.
> >
> > Are you able to figure out which of the files is being written at t=
he
> > time of the oops? =A0If not we can easily add a message to help nai=
l it
> > down.
> >
> > Either way, I'd copy the file that is triggering the problem to a n=
ew
> > file and delete the old one.
>=20
> The data wasn't critical, for now I have switched back to ext3.  I
> really like the COW copy feature so I intend to get back on btrfs whe=
n
> I have time to rebuild a kernel with the fix in it.

Ok great.  Please let us know if you're able to trigger it again.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
