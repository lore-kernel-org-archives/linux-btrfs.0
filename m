From: pragnesh radadia <pragnesh.radadia@gmail.com>
Subject: Re: kernel oops when trying to compile kernel on btrfs part
Date: Tue, 24 Nov 2009 20:12:01 +0530
Message-ID: <3fa5c0870911240642o648806d4l9a42f132663b1e4a@mail.gmail.com>
References: <3fa5c0870911190516q227a65cau20716cc3b425a5f1@mail.gmail.com>
	 <20091124012353.GE24068@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	pragnesh radadia <pragnesh.radadia@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091124012353.GE24068@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2009 at 6:53 AM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Thu, Nov 19, 2009 at 06:46:58PM +0530, pragnesh radadia wrote:
>> I got following kernel oops when trying to compile kernel on btrfs
>> partation on my laptop.
>
> This is probably running out of space. =A0Could you please send along=
 the
> lines around line number 735 in fs/btrfs/inode.c?
>
> -chris
>
code,
 712                 if (ret =3D=3D 0) {
 713                         extent_clear_unlock_delalloc(inode,
 714
&BTRFS_I(inode)->io_tree,
 715                                                      start, end,
NULL, 1, 1,
 716                                                      1, 1, 1, 1);
 717                         *nr_written =3D *nr_written +
 718                              (end - start + PAGE_CACHE_SIZE) /
PAGE_CACHE_SIZE;
 719                         *page_started =3D 1;
 720                         ret =3D 0;
 721                         goto out;
 722                 }
 723         }
 724
 725         BUG_ON(disk_num_bytes >
 726                btrfs_super_total_bytes(&root->fs_info->super_copy)=
);
 727
 728         btrfs_drop_extent_cache(inode, start, start + num_bytes - =
1, 0);
 729
 730         while (disk_num_bytes > 0) {
 731                 cur_alloc_size =3D min(disk_num_bytes,
root->fs_info->max_extent);
 732                 ret =3D btrfs_reserve_extent(trans, root, cur_allo=
c_size,
 733                                            root->sectorsize, 0, al=
loc_hint,
 734                                            (u64)-1, &ins, 1);
 735                 BUG_ON(ret);
 736
 737                 em =3D alloc_extent_map(GFP_NOFS);
 738                 em->start =3D start;
 739                 em->orig_start =3D em->start;
 740
 741                 ram_size =3D ins.offset;
-pragnesh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
