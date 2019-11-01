Return-Path: <SRS0=DXG0=YZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AA9CA9ECF
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Nov 2019 10:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C45F32086D
	for <linux-btrfs@archiver.kernel.org>; Fri,  1 Nov 2019 10:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfKAKzT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Nov 2019 06:55:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:57198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbfKAKzS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Nov 2019 06:55:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FD1AB2BA;
        Fri,  1 Nov 2019 10:55:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D933EDA783; Fri,  1 Nov 2019 11:55:25 +0100 (CET)
Date:   Fri, 1 Nov 2019 11:55:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: receive: make option quiet work
Message-ID: <20191101105525.GK3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20191025102520.41170-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025102520.41170-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 25, 2019 at 06:25:20PM +0800, Anand Jain wrote:
> Even when -q option specified, the receive sub-command is not quiet as
> show below.
> 
>  btrfs receive -q -f /tmp/t /btrfs1
>  At snapshot ss3
> 
> It must be quiet atlest when its been asked to be quiet.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> This is how I checked if fstests/btrfs-progs-tests is using receive -q option.
>    find  ./xfstests-devel -type f -exec grep --color -i -I "receive" {} \; \
> 	-print | grep "\-q"
>    find  ./btrfs-progs/tests -type f -exec grep --color -i -I "receive" {} \; \
> 	-print | grep "\-q"
> 
>  they aren't using it. So its fine.
> 
>  cmds/receive.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/cmds/receive.c b/cmds/receive.c
> index 4b03938ea3eb..c4827c1dd999 100644
> --- a/cmds/receive.c
> +++ b/cmds/receive.c
> @@ -269,7 +269,8 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>  		goto out;
>  	}
>  
> -	fprintf(stdout, "At snapshot %s\n", path);
> +	if (g_verbose)
> +		fprintf(stdout, "At snapshot %s\n", path);

Right, this seems to be forgotten in commit 33b4acc7df00bf "btrfs-progs:
receive: add option for quiet mode" that updated the verbosity.
Added to devel, thanks.
