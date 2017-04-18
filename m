Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35394 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753756AbdDRHGI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 03:06:08 -0400
Received: by mail-ua0-f195.google.com with SMTP id g30so12000915uab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 00:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170417032642.30770-10-quwenruo@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com> <20170417032642.30770-10-quwenruo@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Tue, 18 Apr 2017 12:35:23 +0530
Message-ID: <CAKuJGC8vX53NExNAYj-de9vta_y5rdv3fC2z9-fP=rPatv-OOg@mail.gmail.com>
Subject: Re: [PATCH 9/9] btrfs-progs: modify: Introduce option to specify the
 pattern to fill mirror
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nice. With this new option, it should be possible to achieve something
like RAID56 corruption test-script say,
https://patchwork.kernel.org/patch/9583455/  right?
----
Cheers,
Lakshmipathi.G
FOSS Programmer.
http://www.giis.co.in http://www.webminal.org


On Mon, Apr 17, 2017 at 8:56 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Introduce a new option, --pattern, to specify the pattern to fill
> mirror.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  Documentation/btrfs-modify.asciidoc |  5 +++++
>  modify/mirror.c                     | 11 ++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/btrfs-modify.asciidoc b/Documentation/btrfs-modify.asciidoc
> index ae2ada65..d82fb0df 100644
> --- a/Documentation/btrfs-modify.asciidoc
> +++ b/Documentation/btrfs-modify.asciidoc
> @@ -41,6 +41,11 @@ stripe number 1.
>  P for RAID56 1st parity stripe. Only RAID5 and RAID6 support stripe number P.
>  Q for RAID6 2nd parity stripe.
>
> +--pattern <pattern>::::
> +Specify to pattern to modify the mirror data5f536652.
> ++
> +Default value is "0x66524842" (ascii "BHRf", part of the btrfs magic "_BHRfS_M").
> +
>  EXIT STATUS
>  -----------
>  *btrfs-modify* returns a zero exit status if all its operations succeed.
> diff --git a/modify/mirror.c b/modify/mirror.c
> index c89927f6..dd717fbe 100644
> --- a/modify/mirror.c
> +++ b/modify/mirror.c
> @@ -373,13 +373,15 @@ int modify_mirror(int argc, char **argv)
>         char *device;
>         u64 length = (u64)-1;
>         u64 logical = (u64)-1;
> +       u32 pattern = 0x66524842;
>         int stripe = STRIPE_UNINITILIZED;
>         int ret;
>
>         while (1) {
>                 int c;
>                 enum { GETOPT_VAL_LOGICAL = 257, GETOPT_VAL_LENGTH,
> -                       GETOPT_VAL_STRIPE, GETOPT_VAL_ROOT_INO_OFFSET };
> +                       GETOPT_VAL_STRIPE, GETOPT_VAL_ROOT_INO_OFFSET,
> +                       GETOPT_VAL_PATTERN };
>                 static const struct option long_options[] = {
>                         { "logical", required_argument, NULL,
>                                 GETOPT_VAL_LOGICAL },
> @@ -388,6 +390,8 @@ int modify_mirror(int argc, char **argv)
>                         { "stripe", required_argument, NULL, GETOPT_VAL_STRIPE },
>                         { "root-ino-offset", required_argument, NULL,
>                                 GETOPT_VAL_ROOT_INO_OFFSET},
> +                       { "pattern", required_argument, NULL,
> +                               GETOPT_VAL_PATTERN},
>                         { NULL, 0, NULL, 0 }
>                 };
>
> @@ -407,6 +411,9 @@ int modify_mirror(int argc, char **argv)
>                 case GETOPT_VAL_ROOT_INO_OFFSET:
>                         parse_root_ino_offset(&dest, optarg);
>                         break;
> +               case GETOPT_VAL_PATTERN:
> +                       pattern = arg_strtou32(optarg);
> +                       break;
>                 case '?':
>                 case 'h':
>                         usage(modify_mirror_usage);
> @@ -439,6 +446,8 @@ int modify_mirror(int argc, char **argv)
>                 stripe = 0;
>         }
>
> +       memset(write_buf, pattern, sizeof(write_buf) / sizeof(pattern));
> +
>         fs_info = open_ctree_fs_info(device, 0, 0, 0, OPEN_CTREE_WRITES);
>         if (!fs_info) {
>                 error("failed to open btrfs on device %s\n", device);
> --
> 2.12.2
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
