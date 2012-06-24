Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53893 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab2FXWOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Jun 2012 18:14:23 -0400
Received: by pbbrp8 with SMTP id rp8so5730732pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Jun 2012 15:14:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340572808-30281-5-git-send-email-ablock84@googlemail.com>
References: <1340572808-30281-1-git-send-email-ablock84@googlemail.com>
	<1340572808-30281-5-git-send-email-ablock84@googlemail.com>
Date: Mon, 25 Jun 2012 00:14:22 +0200
Message-ID: <CAB9VWqAaRiso-nO5R_Q2zKjfe8VH9ER7N2Te_TtqEi+enzqB_w@mail.gmail.com>
Subject: Re: [PATCH 4/5] Btrfs-progs: make filesystem_cmd_group non const
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've removed this patch in the mean time. It was needed to build the
usage string
for btrfs fi props at runtime but I found a solution to do this at
compile time now.

On Sun, Jun 24, 2012 at 11:20 PM, Alexander Block
<ablock84@googlemail.com> wrote:
> Make filesystem_cmd_group non const so that btrfs fi prop can
> generate the usage string at runtime. The commands member of
> struct cmd_group is also non const now.
>
> Signed-off-by: Alexander Block <ablock84@googlemail.com>
> ---
>  cmds-filesystem.c |    2 +-
>  commands.h        |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> index a8f63b3..4c61233 100644
> --- a/cmds-filesystem.c
> +++ b/cmds-filesystem.c
> @@ -536,7 +536,7 @@ static int cmd_label(int argc, char **argv)
>  }
>  }
>
> -const struct cmd_group filesystem_cmd_group = {
> +struct cmd_group filesystem_cmd_group = {
>        filesystem_cmd_group_usage, NULL, {
>                { "df", cmd_df, cmd_df_usage, NULL, 0 },
>                { "show", cmd_show, cmd_show_usage, NULL, 0 },
> diff --git a/commands.h b/commands.h
> index 64acf17..9405806 100644
> --- a/commands.h
> +++ b/commands.h
> @@ -54,7 +54,7 @@ struct cmd_group {
>        const char * const *usagestr;
>        const char *infostr;
>
> -       const struct cmd_struct commands[];
> +       struct cmd_struct commands[];
>  };
>
>  /* btrfs.c */
> @@ -81,7 +81,7 @@ void help_command_group(const struct cmd_group *grp, int argc, char **argv);
>  int open_file_or_dir(const char *fname);
>
>  extern const struct cmd_group subvolume_cmd_group;
> -extern const struct cmd_group filesystem_cmd_group;
> +extern struct cmd_group filesystem_cmd_group;
>  extern const struct cmd_group balance_cmd_group;
>  extern const struct cmd_group device_cmd_group;
>  extern const struct cmd_group scrub_cmd_group;
> --
> 1.7.10
>
