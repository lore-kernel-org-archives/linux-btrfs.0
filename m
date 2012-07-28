Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab2G1J4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jul 2012 05:56:20 -0400
Received: by pbbrp8 with SMTP id rp8so6511831pbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jul 2012 02:56:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHf9xvYApp7yEmX7BCi1Y3Ut7hX2VDxAkJgAxNp-FtkQCBiXUQ@mail.gmail.com>
References: <CAHf9xvbz92KdUrXHhEFyEqwFhA97yTw7=10YC8YyCMxDZ20_Yw@mail.gmail.com>
	<CAB9VWqDS+zVku2diCYh08k=V_iT10fssRpEFcw9p8rn+dtaQqg@mail.gmail.com>
	<CAHf9xvbaWkM8EqeBA-z1HaFV56vtMfWjpZDp+OfUGu88nsOzug@mail.gmail.com>
	<CAHf9xvaj+uzWc39Hp5SLaVfevhwqvNXY9eWBY0Q-yT=7yPgS-w@mail.gmail.com>
	<CAB9VWqDj5c2Ds=zthKdUPfNyGELgaTmfj9UHf4uvqxMs4--9+Q@mail.gmail.com>
	<CAB9VWqAv-86CtAgitTD0BBaifomMGVsGZEnhaMsZ4DNV8DndFA@mail.gmail.com>
	<CAHf9xvYApp7yEmX7BCi1Y3Ut7hX2VDxAkJgAxNp-FtkQCBiXUQ@mail.gmail.com>
Date: Sat, 28 Jul 2012 11:56:19 +0200
Message-ID: <CAB9VWqAPvjyQ3EhcZQC59b0qcGr3QFozP60A0q+=FiRv3wxgbg@mail.gmail.com>
Subject: Re: btrfs send/receive: if new inode ino is less than its new
 directory ino, incorrect path is sent
From: Alexander Block <ablock84@googlemail.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 27, 2012 at 4:37 PM, Alex Lyakas
<alex.bolshoy.btrfs@gmail.com> wrote:
> Hi Alexander,
> your solution is simple and elegant. I this this issue is solved now. Thanks!
> Two minor issues:
> 1)
> /*
>  * We need some special handling for inodes that get processed before the parent
>  * directory got created. See process_all_refs for details.
>  * This function does the check if we already created the dir out of order.
>  */
> /*
>  * Only creates the inode if it is:
>  * 1. Not a directory
>  * 2. Or a directory which was not created already due to out of order
>  *    directories. See did_create_dir and process_all_refs for details.
>  */
>
> These comments tell to look at process_all_refs(), while we should
> look at process_recorded_refs().
>
> 2)
>                  * We can however not delete the orphan in case the inode relies
>                  * in a directory that was not created yet (see
>                  * __record_new_ref)
>                  */
> This part should be removed, because your new solution does not work this way.
Whoops...corrected all comments.
>
>
> If you find, time, pls look at the two attached scripts.
>
> btrfs_test_1.sh:
> it tries to explore the is_first_ref() issue and founds a problem.
> Proposed patch - compare also the (dir,gen) tuple and only the name:
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 68e504c..b83ec5f 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -1597,7 +1597,7 @@ out:
>
>  static int is_first_ref(struct send_ctx *sctx,
>                         struct btrfs_root *root,
> -                       u64 ino, u64 dir,
> +                       u64 ino, u64 dir, u64 dir_gen,
>                         const char *name, int name_len)
>  {
>         int ret;
> @@ -1613,6 +1613,11 @@ static int is_first_ref(struct send_ctx *sctx,
>         if (ret < 0)
>                 goto out;
>
> +       if (dir != tmp_dir || dir_gen != tmp_dir_gen) {
> +               ret = 0;
> +               goto out;
> +       }
> +
>         if (name_len != fs_path_len(tmp_name)) {
>                 ret = 0;
>                 goto out;
> @@ -2834,7 +2839,7 @@ verbose_printk("btrfs: process_recorded_refs
> %llu\n", sctx->cur_ino);
>                         goto out;
>                 if (ret) {
>                         ret = is_first_ref(sctx, sctx->parent_root,
> -                                       ow_inode, cur->dir, cur->name,
> +                                       ow_inode, cur->dir,
> cur->dir_gen, cur->name,
>                                         cur->name_len);
>                         if (ret < 0)
>                                 goto out;
>
I did not apply the patch but instead added a check for dir != tmp_dir
only. The reason to not check for gen is that I have a rule in my
mind: I only pass the generation number to functions where I want to
know the *current* state. is_first_ref is for permanent state, the
return value never changes while sending. I could however not
reproduce the problem with test_1.sh, but it should fix it.
>
> btrfs_test_2.sh
> The last test exposes an interesting issue: when a directory has a
> deleted reference recorded, this deleted reference is not added to the
> 'check_dirs' list. As a result, the upper directory (already
> orphanized) is not rmdir'd.
You'll find a commit in my repo to fix this. The problem was, that
moved directories do not get into the delete_refs loop and thus the
parent of the old location is never added to the check_dirs list.
I have force pushed to for-alex, if you have time I'd be happy if you
test again :)
>
> Thanks,
> Alex.
