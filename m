Return-Path: <SRS0=dUu7=AK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765C5C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57071214F1
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Jun 2020 21:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgF2VXY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:23:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgF2SvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jun 2020 14:51:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC6A1AAD0;
        Mon, 29 Jun 2020 15:36:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 508ABDA703; Mon, 29 Jun 2020 17:36:24 +0200 (CEST)
Date:   Mon, 29 Jun 2020 17:36:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH v3 02/16] btrfs-progs: add global verbose and quiet
 options and helper functions
Message-ID: <20200629153624.GJ27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <1574678357-22222-3-git-send-email-anand.jain@oracle.com>
 <20200612105606.18210-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612105606.18210-1-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 12, 2020 at 06:56:06PM +0800, Anand Jain wrote:
> Add btrfs(8) global --verbose and --quiet command options to show
> verbose or no output from the sub-commands.
> By introducing global a %bconf::verbose memeber to transpire the same
> down to the sub-command.
> Further the added helper function pr_verbose() helps to logs the verbose
> messages, based on the state of the %bconf::verbose. And further HELPINFO_
> defines are provides for the usage.
> 
> Suggested-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v3:
>   Add define MUST_LOG
>   Add comment about the argument %level in the function pr_verbose()

So the v2 got merged and v3 is not usable as replacement because I did a
lot of fixups to v2 that would be lost. The updated help text and
documentation need to reflect that the subcommand specific options are
deprecated but still kept as an alias.

+	"-q|--quiet       suppress all messages, except errors. This option is",
+	"                 merged to the global quiet option.

In particular, I find the use of word 'merged' to be confusing here.
The final wording is:

-v       deprecated, alias for global -v option

or

-q       deprecated, alias for global -q option

and the options are last in the list. Similar for the documentation,
plus several fixup of spacing. All these things are just help text
updates but user-facing and it has its own importance. I had not
anticipated that merging that would be such time sink despite the
relative simplicity.
