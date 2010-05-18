From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: [PATCH 1/4] btrfs-convert: make more use of cache_free_extents
Date: Tue, 18 May 2010 12:18:19 -0400
Message-ID: <20100518161819.GB4380@flcl.lan>
References: <20100320042449.GA17083@flcl.lan>
 <AANLkTikJiGhwyOV3UTiS9vdjVX4w3yuVT2urOdXSZ8sD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikJiGhwyOV3UTiS9vdjVX4w3yuVT2urOdXSZ8sD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 09:40:28PM +0800, Yan, Zheng  wrote:
> On Sat, Mar 20, 2010 at 12:24 PM, Sean Bartell
> <wingedtachikoma@gmail.com> wrote:
> > An extent_io_tree is used for all free space information. This allo=
ws
> > removal of ext2_alloc_block and ext2_free_block, and makes
> > create_ext2_image less ext2-specific.

> > + =A0 =A0 =A0 ret =3D ext2_cache_free_extents(ext2_fs, &orig_free_t=
ree);
> > + =A0 =A0 =A0 if (ret) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error during cache_f=
ree_extents %d\n", ret);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> > + =A0 =A0 =A0 }
> > + =A0 =A0 =A0 /* preserve first 64KiB, just in case */
> > + =A0 =A0 =A0 clear_extent_dirty(&orig_free_tree, 0, BTRFS_SUPER_IN=
=46O_OFFSET - 1, 0);
> > +
> > + =A0 =A0 =A0 ret =3D copy_dirtiness(&free_tree, &orig_free_tree);
> > + =A0 =A0 =A0 if (ret) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "error during copy_di=
rtiness %d\n", ret);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fail;
> > + =A0 =A0 =A0 }

> extent_io_tree is not very space efficient. caching free space in
> several places is not good. I prefer adding a function that checks
> if a given block is used to the 'convert_fs' structure.

Good point. I'll change cache_free_extents to something like
  int (*iterate_used_extents)(struct convert_fs *fs, u64 start, u64 end=
,
                              void *priv, int (*cb)(u64 start, u64 end)=
)
create_image_file_range and do_convert should work well with a callback=
=2E

This also opens up the possibility of finding free extents
incrementally: call iterate_used_extents on the first GB, then
custom_alloc_extent will call it on the next GB once free space runs
out.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
