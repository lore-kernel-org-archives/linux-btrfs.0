Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:60275 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3JNOBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 10:01:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A235D7C04D8
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 08:01:35 -0600 (MDT)
Date: Mon, 14 Oct 2013 10:01:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
CC: Stefan Behrens <sbehrens@giantdisaster.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v6] btrfs: Fix memory leakage in the tree-log.c
Message-ID: <20131014140133.GA14323@localhost.localdomain>
References: <1381516545-27786-1-git-send-email-geyslan@gmail.com>
 <525849B2.7080306@giantdisaster.de>
 <CAGG-pURmJKq+w8CNdAEuu8Ajcexfo1mRrKu7TjberKH=1D3rsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAGG-pURmJKq+w8CNdAEuu8Ajcexfo1mRrKu7TjberKH=1D3rsg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 13, 2013 at 07:03:12PM -0300, Geyslan Gregório Bem wrote:
> 2013/10/11 Stefan Behrens <sbehrens@giantdisaster.de>:
> > On 10/11/2013 20:35, Geyslan G. Bem wrote:
> >>
> >> In add_inode_ref() function:
> >>
> >> Initializes local pointers.
> >>
> >> Reduces the logical condition with the __add_inode_ref() return
> >> value by using only one 'goto out'.
> >>
> >> Centralizes the exiting, ensuring the freeing of all used memory.
> >>
> >> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> >> ---
> >>   fs/btrfs/tree-log.c | 33 +++++++++++++++++++--------------
> >>   1 file changed, 19 insertions(+), 14 deletions(-)
> >>
> >> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> >> index 79f057c..61bb051 100644
> >> --- a/fs/btrfs/tree-log.c
> >> +++ b/fs/btrfs/tree-log.c
> >> @@ -1113,11 +1113,11 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>                                   struct extent_buffer *eb, int slot,
> >>                                   struct btrfs_key *key)
> >>   {
> >> -       struct inode *dir;
> >> -       struct inode *inode;
> >> +       struct inode *dir = NULL;
> >> +       struct inode *inode = NULL;
> >>         unsigned long ref_ptr;
> >>         unsigned long ref_end;
> >> -       char *name;
> >> +       char *name = NULL;
> >>         int namelen;
> >>         int ret;
> >>         int search_done = 0;
> >> @@ -1150,13 +1150,15 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>          * care of the rest
> >>          */
> >>         dir = read_one_inode(root, parent_objectid);
> >> -       if (!dir)
> >> -               return -ENOENT;
> >> +       if (!dir) {
> >> +               ret = -ENOENT;
> >> +               goto out;
> >> +       }
> >>
> >>         inode = read_one_inode(root, inode_objectid);
> >>         if (!inode) {
> >> -               iput(dir);
> >> -               return -EIO;
> >> +               ret = -EIO;
> >> +               goto out;
> >>         }
> >>
> >>         while (ref_ptr < ref_end) {
> >> @@ -1169,14 +1171,16 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>                          */
> >>                         if (!dir)
> >>                                 dir = read_one_inode(root,
> >> parent_objectid);
> >> -                       if (!dir)
> >> -                               return -ENOENT;
> >> +                       if (!dir) {
> >> +                               ret = -ENOENT;
> >> +                               goto out;
> >> +                       }
> >>                 } else {
> >>                         ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
> >>                                              &ref_index);
> >>                 }
> >>                 if (ret)
> >> -                       return ret;
> >> +                       goto out;
> >>
> >>                 /* if we already have a perfect match, we're done */
> >>                 if (!inode_in_dir(root, path, btrfs_ino(dir),
> >> btrfs_ino(inode),
> >> @@ -1196,12 +1200,11 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>                                                       parent_objectid,
> >>                                                       ref_index, name,
> >> namelen,
> >>                                                       &search_done);
> >> -                               if (ret == 1) {
> >> -                                       ret = 0;
> >> +                               if (ret) {
> >> +                                       if (ret == 1)
> >> +                                               ret = 0;
> >>                                         goto out;
> >>                                 }
> >> -                               if (ret)
> >> -                                       goto out;
> >>                         }
> >>
> >>                         /* insert our name */
> >> @@ -1215,6 +1218,7 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>
> >>                 ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) +
> >> namelen;
> >>                 kfree(name);
> >> +               name = NULL;
> >>                 if (log_ref_ver) {
> >>                         iput(dir);
> >>                         dir = NULL;
> >> @@ -1225,6 +1229,7 @@ static noinline int add_inode_ref(struct
> >> btrfs_trans_handle *trans,
> >>         ret = overwrite_item(trans, root, path, eb, slot, key);
> >>   out:
> >>         btrfs_release_path(path);
> >> +       kfree(name);
> >>         iput(dir);
> >>         iput(inode);
> >>         return ret;
> >>
> >
> > The patch looks really good now. Thanks!
> >
> > Reviewed-by: Stefan Behrens <sbehrens@giantdisaster.de>
> >
> >
> 
> Will it to be committed to the next?

I will pull it into btrfs-next the next time I scrape the list for patches and
then it will go into 3.13.  Thanks,

Josef
