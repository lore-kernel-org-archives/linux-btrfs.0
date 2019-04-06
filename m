Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA71C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 16:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9742213A2
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 16:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUSEgXDG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfDFQtT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 12:49:19 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36794 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfDFQtT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 12:49:19 -0400
Received: by mail-yb1-f195.google.com with SMTP id s7so3616611ybo.3;
        Sat, 06 Apr 2019 09:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3n9hNEIFtQwoDBMNCYEvNSpecMDbWgpEno5SpqvsFls=;
        b=nUSEgXDGmCqAkkN0YIDI+8+iEHD3uLAt/8H0+GzlbLiqB3veldWK8IF6xlfJg/F6ZJ
         FUedq1cqjFKH5wyMgwrDH63f6jUpWpTVbJOe1kVwJMyeqFyhWfdxLZ8SqWN6AhFXrnLN
         TxvIYKxRkTMV1BNgckk53zGqRrIkcQW2aGQ9zMl4NHtpDoZezQln9WBVJAjZqnZ2SHPy
         CTnOiUqjVmDS7w8pePFmeFEij5wLi0ffgSgwW6M7+9MJzAf4CLcfo+SvZofdXagp1jIj
         OHRXvElJ13m6vlwcvOzKXtVe9A8tUo2XwtKdPl+ENZgcdOtAFZMT08kpc9ZyVYol3xxu
         mDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3n9hNEIFtQwoDBMNCYEvNSpecMDbWgpEno5SpqvsFls=;
        b=eIti9DdCmkNvI3zM3RDlZeIYzasub9FQUKAqVAS/pl2yBlTbikS1tAl2GOiJXSPcEP
         sHCfXoFlZyVKQeWlzCpeWhw+dkjcQSJ2abLlkKo3sfuWqPdNeiGMJVSIQpZ8jvoyToBy
         ZHxoUfI48Sf8Vv/vjpkHVJz8NE6GUamT70hJl11AZ0MQJof2ogsHsQFQWFy31WWfKULg
         Sf0QLrq0JUY2tmNDohoy9Scl/WeZ63P/D5SnX4uXX30FEqgQ5tejNjLj+GTN+3zNxoCN
         vmTrLx0/gGSajP5EBBSP9e0U1+wnDwhKoHTgRjXQL2hCdAzo9Op97gjRZAqS1eYcs8ov
         QRog==
X-Gm-Message-State: APjAAAVnViEsUkFspXq7EHRTjAL18vIYMukkewtuoAblWmV2KE9Ip28F
        hqwTx0Ux18r2bsYKHyGtFzc4iaPvK7/ToFKtlu0G9Yr16rw=
X-Google-Smtp-Source: APXvYqxPerpL1mFc49EoUbSN4KfzGdN9OVxdtX3g2sAV4bkI1k8TX38awZUUninP9FlbKuCzcVShJlTQfbcRz62iKsk=
X-Received: by 2002:a25:dc0f:: with SMTP id y15mr7259517ybe.185.1554569357854;
 Sat, 06 Apr 2019 09:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190328053507.10191-1-wqu@suse.com>
In-Reply-To: <20190328053507.10191-1-wqu@suse.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 6 Apr 2019 19:49:06 +0300
Message-ID: <CAOQ4uxhNe689bzcpTi5LUEiDN4X0JkKSWPtr+1bhYYQCWnowEA@mail.gmail.com>
Subject: Re: [PATCH] fstests: log-writes: Add new option to replay/find next
 write to sector
To:     Qu Wenruo <wqu@suse.com>
Cc:     Linux Btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 28, 2019 at 7:36 AM Qu Wenruo <wqu@suse.com> wrote:
>
> For kernel operation we have METADATA/FUA/FLUSH flags as a beacon, but
> for user space write we don't have any useful flag unless the user space
> tool call fsync() to generate a FLUSH bio.
>
> This means for user space write, we don't really have an equivalent of
> --next-fua to find super block write.
>
> So this patch will add a new option, --next-write <sector> to
> replay/find next write to certain sector.
> And normally the <sector> should be super block sector number.
>
> With that, we can replay to super block write even it's user space
> triggering the write.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

This is useful, but it could be simpler and even more useful.
See suggestion below.

> ---
>  src/log-writes/replay-log.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
> index c16df40e5741..0d0ec49c8a00 100644
> --- a/src/log-writes/replay-log.c
> +++ b/src/log-writes/replay-log.c
> @@ -9,6 +9,7 @@
>  enum option_indexes {
>         NEXT_FLUSH,
>         NEXT_FUA,
> +       NEXT_WRITE,
>         START_ENTRY,
>         END_MARK,
>         LOG,
> @@ -28,6 +29,7 @@ enum option_indexes {
>  static struct option long_options[] = {
>         {"next-flush", no_argument, NULL, 0},
>         {"next-fua", no_argument, NULL, 0},
> +       {"next-write", required_argument, NULL, 0},

Suggest no_argument like next-fua,next-flush and assign
a special flag or something to find WRITE entries
because start/end-sector already gives to the ability
to filter by single sector or range of sectors.
If fact I added these option to debug the exact case you are
describing.

>         {"start-entry", required_argument, NULL, 0},
>         {"end-mark", required_argument, NULL, 0},
>         {"log", required_argument, NULL, 0},
> @@ -53,6 +55,8 @@ static void usage(void)
>         fprintf(stderr, "\t--limit <number> - number of entries to replay\n");
>         fprintf(stderr, "\t--next-flush - replay to/find the next flush\n");
>         fprintf(stderr, "\t--next-fua - replay to/find the next fua\n");
> +       fprintf(stderr, "\t--next-write <sector> - replay to/find the next "
> +                       "write to <sector>\n");
>         fprintf(stderr, "\t--start-entry <entry> - start at the given "
>                 "entry #\n");
>         fprintf(stderr, "\t--start-mark <mark> - mark to start from\n");
> @@ -139,6 +143,7 @@ int main(int argc, char **argv)
>         char *logfile = NULL, *replayfile = NULL, *fsck_command = NULL;
>         struct log_write_entry *entry;
>         u64 stop_flags = 0;
> +       u64 stop_sector = 0;
>         u64 start_entry = 0;
>         u64 start_sector = 0;
>         u64 end_sector = -1ULL;
> @@ -173,6 +178,14 @@ int main(int argc, char **argv)
>                 case NEXT_FUA:
>                         stop_flags |= LOG_FUA_FLAG;
>                         break;
> +               case NEXT_WRITE:
> +                       stop_sector = strtoull(optarg, &tmp, 0);
> +                       if (tmp && *tmp != '\0') {
> +                               fprintf(stderr, "Invalid sector number\n");
> +                               exit(1);
> +                       }
> +                       tmp = NULL;
> +                       break;
>                 case START_ENTRY:
>                         start_entry = strtoull(optarg, &tmp, 0);
>                         if (tmp && *tmp != '\0') {
> @@ -324,7 +337,8 @@ int main(int argc, char **argv)
>                 while ((ret = log_seek_next_entry(log, entry, 1)) == 0) {
>                         num_entries++;
>                         if ((run_limit && num_entries == run_limit) ||
> -                           should_stop(entry, stop_flags, end_mark)) {
> +                           should_stop(entry, stop_flags, end_mark) ||
> +                           (stop_sector && entry->sector == stop_sector)) {

You seem to have only implemented "find" mode and not "replay" mode
(the log_replay_next_entry() loop).
I suggest that you work log_should_skip() into both "find" and "replay"
loops. i.e. (!log_should_skip() && should_stop()).

Thanks,
Amir.
