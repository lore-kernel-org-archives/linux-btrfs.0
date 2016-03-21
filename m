Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34282 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcCUPFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 11:05:50 -0400
Received: by mail-ig0-f172.google.com with SMTP id av4so85921243igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 08:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
References: <1458562991-6882-1-git-send-email-ahferroin7@gmail.com>
Date: Mon, 21 Mar 2016 16:05:49 +0100
Message-ID: <CAM1AHpS+fBDaiJdotFi5Qw1HVdAocunctK_0b7B0uv8_4PdFqg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: fix fi du so it works in more cases
From: Martin Volf <martin.volf.42@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Works for me, thanks.

Martin Volf

On Mon, Mar 21, 2016 at 1:23 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> Currently, btrfs fi du uses open_file_or_dir(), which tries to open
> it's argument with o_RDWR.  Because of POSIX semantics, this fails for
> non-root users when the file is read-only or is an executable that
> is being run currently, or for all users (including root) when the
> filesystem is read-only.  THis results in a somewhat confusing 'Unknown
> error -1' message when trying to check such files.  Switch to using
> open_file_or_dir3() with O_RDONLY passed in the flags, as this avoids
> the limitations listed above, and we have no need to write to the files
> anyway (and thus shouldn't be opening them writable).
>
> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> ---
> Build and runtime tested on x86-64 with glibc.
>
> I intend to take the time at some point this week to audit all users of
> open_file_or_dir() and similarly change any that don't need to write
> to what they're opening, possibly adding a helper function to do a
> read-only open.
>
>  cmds-fi-du.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/cmds-fi-du.c b/cmds-fi-du.c
> index 2ffd917..168fc72 100644
> --- a/cmds-fi-du.c
> +++ b/cmds-fi-du.c
> @@ -438,7 +438,7 @@ static int du_add_file(const char *filename, int dirfd,
>                 ret = sprintf(pathp, "/%s", filename);
>         pathp += ret;
>
> -       fd = open_file_or_dir(path, &dirstream);
> +       fd = open_file_or_dir3(path, &dirstream, O_RDONLY);
>         if (fd < 0) {
>                 ret = fd;
>                 goto out;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Martin Volf
