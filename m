From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Btrfs fixes and features
Date: Fri, 30 Mar 2012 16:01:12 -0400
Message-ID: <20120330200112.GK755@shiny>
References: <20120330175106.GB755@shiny>
 <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwFkeR8pNo7dF1gr0VPD9hr+9zB8zoc_byvMxSzr2WEZw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 30, 2012 at 12:50:26PM -0700, Linus Torvalds wrote:
> On Fri, Mar 30, 2012 at 10:51 AM, Chris Mason <chris.mason@oracle.com=
> wrote:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git=
 for-linus
>=20
> This causes a new warning for me:
>=20
>   fs/btrfs/extent_io.c: In function =E2=80=98repair_eb_io_failure=E2=80=
=99:
>   fs/btrfs/extent_io.c:1940:6: warning: =E2=80=98ret=E2=80=99 may be =
used
> uninitialized in this function

Interesting that my gcc doesn't warn here.  Strictly speaking, gcc isn'=
t
wrong, but num_extent_pages() will always be at least 1.  This function
is new in this pull, so it can't be a conflict.

Do you want a new pull with the ret =3D 0 patch?

int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer
*eb,
			 int mirror_num)
{
	struct btrfs_mapping_tree *map_tree =3D &root->fs_info->mapping_tree;
	u64 start =3D eb->start;
	unsigned long i, num_pages =3D num_extent_pages(eb->start, eb->len);
	int ret;

	for (i =3D 0; i < num_pages; i++) {
		struct page *p =3D extent_buffer_page(eb, i);
		ret =3D repair_io_failure(map_tree, start, PAGE_CACHE_SIZE,
					start, p, mirror_num);
		if (ret)
			break;
		start +=3D PAGE_CACHE_SIZE;
	}

	return ret;
}

-chris
