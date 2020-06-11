Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7822C433DF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 14:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3DF2083E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 14:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFKOLH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 10:11:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:41724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgFKOLG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 10:11:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 40745AFE6;
        Thu, 11 Jun 2020 14:11:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E3900DA82A; Thu, 11 Jun 2020 16:10:58 +0200 (CEST)
Date:   Thu, 11 Jun 2020 16:10:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/8] btrfs-progs: quota rescan: add quiet option
Message-ID: <20200611141058.GQ27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20200608063851.8874-1-anand.jain@oracle.com>
 <20200608063851.8874-2-anand.jain@oracle.com>
 <20200610083044.GF27795@twin.jikos.cz>
 <743a28a8-0ab2-0aa6-6c83-f4702d97597f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <743a28a8-0ab2-0aa6-6c83-f4702d97597f@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 11, 2020 at 09:16:37PM +0800, Anand Jain wrote:
> On 10/6/20 4:30 pm, David Sterba wrote:
> > On Mon, Jun 08, 2020 at 02:38:44PM +0800, Anand Jain wrote:
> >> Enable the quiet option to the btrfs(8) quota rescan command.
> >> Does the job quietly. For example:
> >>    btrfs --quiet quota rescan
> >>
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >>   cmds/quota.c | 4 +++-
> >>   1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/cmds/quota.c b/cmds/quota.c
> >> index 075fc79816ad..4a68f9db081b 100644
> >> --- a/cmds/quota.c
> >> +++ b/cmds/quota.c
> >> @@ -108,6 +108,8 @@ static const char * const cmd_quota_rescan_usage[] = {
> >>   	"",
> >>   	"-s   show status of a running rescan operation",
> >>   	"-w   wait for rescan operation to finish (can be already in progress)",
> >> +	HELPINFO_INSERT_GLOBALS,
> >> +	HELPINFO_INSERT_QUIET,
> >>   	NULL
> >>   };
> >>   
> >> @@ -172,7 +174,7 @@ static int cmd_quota_rescan(const struct cmd_struct *cmd, int argc, char **argv)
> >>   	}
> >>   
> >>   	if (ret == 0) {
> >> -		printf("quota rescan started\n");
> >> +		pr_verbose(-1, "quota rescan started\n");
> > 
> > That the raw value -1 is used here is not nice, I assume it means print
> > unless there was another setting of the verbosity (nothing if -q,
> > otherwise yes).
> 
>   Yes that's right. In v3 I have defined -1 as
> 
>   #define MUST_LOG  -1
> 
>   I ran out of ideas to name it more sensibly, open to suggestions.

Ok, sounds reasonable to me. It can be documented and used only for the
messages that must be printed due to backward compatibility.

I have merged the first part to devel, so please send this patchset once
you have it ready.
