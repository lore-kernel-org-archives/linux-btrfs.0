Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64077 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3DOODK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 10:03:10 -0400
Received: by mail-wi0-f176.google.com with SMTP id hm14so1581725wib.15
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 07:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
	<1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
Date: Mon, 15 Apr 2013 16:03:08 +0200
Message-ID: <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
From: Jan Alexander Steffens <jan.steffens@gmail.com>
To: Dan McGrath <danmcgrath.ca@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 15, 2013 at 3:47 PM, Dan McGrath <danmcgrath.ca@gmail.com> wrote:
> As per FAQ: It is safe to and recommended to turn fsck.btrfs into a no-op
>
> Signed-off-by: Dan McGrath <danmcgrath.ca@gmail.com>
> ---
>  btrfs.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/btrfs.c b/btrfs.c
> index 691adef..78161a9 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -272,6 +272,8 @@ int main(int argc, char **argv)
>
>         if (!strcmp(bname, "btrfsck")) {
>                 argv[0] = "check";
> +       } else if (!strcmp(bname, "fsck.btrfsck")) {
> +               exit(0);
>         } else {
>                 argc--;
>                 argv++;
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Shouldn't it be fsck.btrfs, not fsck.btrfsck?

Also, fsck.xfs does a bit more than just an exit(0), maybe there's
some merit to what it does. It's a simple shellscript, so check it
out.
