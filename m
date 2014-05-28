Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:56890 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932337AbaE1VHb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 17:07:31 -0400
Received: by mail-ve0-f182.google.com with SMTP id sa20so13301797veb.13
        for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 14:07:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400572305-19818-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1400572305-19818-1-git-send-email-quwenruo@cn.fujitsu.com>
Date: Wed, 28 May 2014 22:07:30 +0100
Message-ID: <CAMU1PDji4xbA7fj34bK2Ke8EDiTEo89n9FEnW-R49=bNEjxf=Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: Improve the parse_size() error message.
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 May 2014 08:51, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> When using parse_size(), even non-numeric value is passed, it will only
> give error message "ERROR: size value is empty", which is quite
> confusing for end users.
>
> This patch will introduce more meaningful error message for the
> following new cases
> 1) Invalid size string (non-numeric string)
> 2) Minus size value (like "-1K")
>
> Also this patch will take full use of endptr returned by strtoll() to
> reduce unneeded loop.
>
> Reported-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  utils.c | 53 +++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 33 insertions(+), 20 deletions(-)
>
> diff --git a/utils.c b/utils.c
> index 392c5cf..1cbe102 100644
> --- a/utils.c
> +++ b/utils.c
> @@ -1612,18 +1612,20 @@ scan_again:
>
>  u64 parse_size(char *s)
>  {
> -       int i;
>         char c;
>         u64 mult = 1;
> -
> -       for (i = 0; s && s[i] && isdigit(s[i]); i++) ;
> -       if (!i) {
> -               fprintf(stderr, "ERROR: size value is empty\n");
> -               exit(50);
> -       }
> -
> -       if (s[i]) {
> -               c = tolower(s[i]);
> +       long long int ret = 0;
> +       char *endptr;
> +
> +       if (!s)
> +               goto empty;
> +       ret = strtoll(s, &endptr, 10);
> +       if (endptr == s)
> +               goto invalid;
> +       if (endptr[0] && endptr[1])
> +               goto suffix;
> +       if (endptr[0]) {
> +               c = tolower(endptr[0]);
>                 switch (c) {
>                 case 'e':
>                         mult *= 1024;
> @@ -1646,18 +1648,29 @@ u64 parse_size(char *s)
>                 case 'b':
>                         break;
>                 default:
> -                       fprintf(stderr, "ERROR: Unknown size descriptor "
> -                               "'%c'\n", c);
> -                       exit(1);
> +                       goto descriptor;
>                 }
>         }
> -       if (s[i] && s[i+1]) {
> -               fprintf(stderr, "ERROR: Illegal suffix contains "
> -                       "character '%c' in wrong position\n",
> -                       s[i+1]);
> -               exit(51);
> -       }
> -       return strtoull(s, NULL, 10) * mult;
> +       ret *= mult;
> +       if (ret <= 0)
> +               goto minus;
> +       return (u64) ret;
> +empty:
> +       fprintf(stderr, "ERROR: Size value is empty\n");
> +       exit(50);
> +suffix:
> +       fprintf(stderr, "ERROR: Illegal suffix contains character '%c' in wrong position\n",
> +               endptr[1]);
> +       exit(51);
> +descriptor:
> +       fprintf(stderr, "ERROR: Unknown size descriptor '%c'\n", c);
> +       exit(52);
> +invalid:
> +       fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
> +       exit(53);
> +minus:
> +       fprintf(stderr, "ERROR: Size value '%s' is less equal than 0\n", s);
> +       exit(54);
>  }
>
>  int open_file_or_dir3(const char *fname, DIR **dirstream, int open_flags)
> --
> 1.9.2
>

IMHO use of this "if condition goto print error exit" pattern makes
the code harder to read.  Use of gotos is used when a function creates
state which needs tearing down in reverse on error before returning.
I think the errors should be printed at the point of detection.  Like
this:

+       if (!s) {
+               fprintf(stderr, "ERROR: Size value is empty\n");
+               exit(1);
+       }
+       ret = strtoll(s, &endptr, 10);
+       if (endptr == s) {
+               fprintf(stderr, "ERROR: Size value '%s' is invalid\n", s);
+               exit(1);
+       }

etc.

Thanks,
Mike
