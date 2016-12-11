Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:53648 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753870AbcLKV7X (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 16:59:23 -0500
MIME-Version: 1.0
Message-ID: <trinity-d5f70dd5-70da-4b78-8748-0e6d84c42139-1481493557992@3capp-mailcom-bs05>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline
 extents
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Dec 2016 22:59:18 +0100
In-Reply-To: <20161211051641.GA21290@hungrycats.org>
References: <1480309392-4786-1-git-send-email-ce3g8jdj@umail.furryterror.org>
 <20161128172710.202587ce@natsu>, <20161211051641.GA21290@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zygo,
Since the corruption happens after I/O and checksum,
could it be possible to add some bug catcher code in code path for debug build,
to help narrowing down the issue?
Thanks,
Xin
 
 

Sent: Saturday, December 10, 2016 at 9:16 PM
From: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>
To: "Roman Mamedov" <rm@romanrm.net>, "Filipe Manana" <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix hole read corruption for compressed inline extents
Ping?

I know at least two people have read this patch, but it hasn't appeared in
the usual integration branches yet, and I've seen no actionable suggestion
to improve it. I've provided two non-overlapping rationales for it.
Is there something else you are looking for?

This patch is a fix for a simple data corruption bug. It (or some
equivalent fix for the same bug) should be on its way to all stable
kernels starting from 2.6.32.

Thanks

On Mon, Nov 28, 2016 at 05:27:10PM +0500, Roman Mamedov wrote:
> On Mon, 28 Nov 2016 00:03:12 -0500
> Zygo Blaxell <ce3g8jdj@umail.furryterror.org> wrote:
>
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 8e3a5a2..b1314d6 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6803,6 +6803,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
> > max_size = min_t(unsigned long, PAGE_SIZE, max_size);
> > ret = btrfs_decompress(compress_type, tmp, page,
> > extent_offset, inline_size, max_size);
> > + WARN_ON(max_size > PAGE_SIZE);
> > + if (max_size < PAGE_SIZE) {
> > + char *map = kmap(page);
> > + memset(map + max_size, 0, PAGE_SIZE - max_size);
> > + kunmap(page);
> > + }
> > kfree(tmp);
> > return ret;
> > }
>
> Wasn't this already posted as:
>
> btrfs: fix silent data corruption while reading compressed inline extents
> https://patchwork.kernel.org/patch/9371971/
>
> but you don't indicate that's a V2 or something, and in fact the patch seems
> exactly the same, just the subject and commit message are entirely different.
> Quite confusing.
>
> --
> With respect,
> Roman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html[http://vger.kernel.org/majordomo-info.html]
