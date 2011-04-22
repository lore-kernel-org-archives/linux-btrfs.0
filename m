From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 13:28:52 +0200
Message-ID: <20110422112852.GB1627@x4.trippels.de>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
 <loom.20110422T001650-760@post.gmane.org>
 <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com>
 <20110422045054.GB17795@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@toxicpanda.com>, Eric Blake <eblake@redhat.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110422045054.GB17795@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 2011.04.22 at 00:50 -0400, Christoph Hellwig wrote:
> [Eric: please don't drop the Cc list, thanks!]
>=20
> On Thu, Apr 21, 2011 at 09:22:55PM -0400, Josef Bacik wrote:
> > > since all files have a virtual hole at the end, but leaves the po=
sition
> > > unchanged). ??I'd have to write a test program on Solaris to see =
whether that
> > > definition is actually true, or if it is a bug in the Solaris man=
 page.
> > >
> >=20
> > lseek's purpose is to reposition the file position, so I'd imagine
> > this is just a bug in the man page.
>=20
> I would be surprised if the bug is around for such a long time, but
> otherwise I concur.

It's a bug. Let me quote what Jeff Bonwick wrote on his blog:

=BBI'm not sure where you got the impression that either SEEK_HOLE or
SEEK_DATA doesn't set the file pointer. They do. (If they didn't, that
would be weird, and we'd call it out explicitly.)=AB

http://blogs.sun.com/bonwick/entry/seek_hole_and_seek_data

--=20
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
