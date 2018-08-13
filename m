Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45476 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729087AbeHMUUg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Aug 2018 16:20:36 -0400
Date: Mon, 13 Aug 2018 19:37:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] btrfs: Remove 'objectid' member from struct
 btrfs_root
Message-ID: <20180813173715.GA24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1533531264.git.misono.tomohiro@jp.fujitsu.com>
 <432b7e99-dd88-4724-083f-a4b7ab5efe31@jp.fujitsu.com>
 <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188cc84-3116-e7e6-ae80-00b6bf4a424d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 02:17:54PM +0800, Qu Wenruo wrote:
> > -	u64 objectid;
> 
> Off topic crazy idea here.
> 
> I think it is a little crazy, but it should save a lot of objectid
> related modification:
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 118346aceea9..e6d70f2309a3 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1166,7 +1166,10 @@ struct btrfs_root {
> 
>         unsigned long state;
>         struct btrfs_root_item root_item;
> -       struct btrfs_key root_key;
> +       union {
> +               struct btrfs_key root_key;
> +               u64 objectid;
> +       };
>         struct btrfs_fs_info *fs_info;
>         struct extent_io_tree dirty_log_pages;
> 
> @@ -1198,7 +1201,6 @@ struct btrfs_root {
>         int last_log_commit;
>         pid_t log_start_pid;
> 
> -       u64 objectid;
>         u64 last_trans;
> 
>         u32 type;
> 
> I'm not sure if this is a really crazy idea or a dirty hack to reduce
> some modification.

Be wary of such tricks. This might make you feel good for a moment how
good your C knowlege is, and also might save a few keystrokes. And a few
years later this costs somebody a week of debugging a mysterious memory
corrupption under circumstances not imagined right now.

Try to write understandable code. If there is a reason to use tricks,
like the struct page has to do for performance reasons, then it must be
documented and justified.
