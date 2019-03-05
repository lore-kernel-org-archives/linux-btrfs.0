Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBAC43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D4820842
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 12:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfCEMkn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Mar 2019 07:40:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:40670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728152AbfCEMkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Mar 2019 07:40:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66CBAAF95;
        Tue,  5 Mar 2019 12:40:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A4783DA7F5; Tue,  5 Mar 2019 13:41:59 +0100 (CET)
Date:   Tue, 5 Mar 2019 13:41:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Steven Davies <btrfs@steev.me.uk>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs-progs: Quiet mode for btrfs-receive
Message-ID: <20190305124157.GW31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Steven Davies <btrfs@steev.me.uk>,
        linux-btrfs@vger.kernel.org
References: <7573fc8cc0e99d8815f1616d9503c2b6@steev.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7573fc8cc0e99d8815f1616d9503c2b6@steev.me.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 20, 2019 at 09:16:04AM +0000, Steven Davies wrote:
> Provide an option in `btrfs receive` to suppress the informational
> messages when writing files.

Thank, looks ok to me, the 'receive' command already has the verbosity
option so it makes sense to have both.

> Signed-off-by: Steven Davies <btrfs@steev.me.uk>
> ---
>   cmds-receive.c | 67 ++++++++++++++++++++++++++++++--------------------
>   1 file changed, 40 insertions(+), 27 deletions(-)
> 
> diff --git a/cmds-receive.c b/cmds-receive.c
> index 3888149a..96411bac 100644
> --- a/cmds-receive.c
> +++ b/cmds-receive.c
> @@ -52,7 +52,11 @@
>   #include "send-dump.h"
>   #include "help.h"
> 
> -static int g_verbose = 0;
> +/*
> + * Default is 1 for historical reasons, changing may break scripts that 
> expect
> + * the 'At subvol' message.
> + */
> +static int g_verbose = 1;
> 
>   struct btrfs_receive
>   {
> @@ -194,12 +198,14 @@ static int process_subvol(const char *path, const 
> u8 *uuid, u64 ctransid,
>                  goto out;
>          }
> 
> -       fprintf(stderr, "At subvol %s\n", path);
> +       if (g_verbose) {
> +               fprintf(stdout, "At subvol %s\n", path);
> +       }

This changes stderr to stdout.

> 
>          memcpy(rctx->cur_subvol.received_uuid, uuid, BTRFS_UUID_SIZE);
>          rctx->cur_subvol.stransid = ctransid;
> 
> -       if (g_verbose) {
> +       if (g_verbose >= 2) {
>                  uuid_unparse((u8*)rctx->cur_subvol.received_uuid, 
> uuid_str);
>                  fprintf(stderr, "receiving subvol %s uuid=%s, 
> stransid=%llu\n",
>                                  path, uuid_str,
> @@ -263,12 +269,14 @@ static int process_snapshot(const char *path, 
> const u8 *uuid, u64 ctransid,
>                  goto out;
>          }
> 
> -       fprintf(stdout, "At snapshot %s\n", path);
> +       if (g_verbose) {
> +               fprintf(stderr, "At snapshot %s\n", path);

And this stdout -> stderr.

That's inconsistent in the original code too, that may need some care to
fix. The stderr is used for all the verbosity levels and it's been like
that since the beginning. I doubt that it has a good reason and that
everybody does 'btrfs receive 2>&1' anyway, but we can never be sure
with that.

So for sake of backward compatibility I'll fix it to keep using the same
output streams and add to devel. Thanks.
