Return-Path: <SRS0=RMw4=7S=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8B3C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 11:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03603206E6
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jun 2020 11:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgFELgp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jun 2020 07:36:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:35362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgFELgp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jun 2020 07:36:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 652F3AE09;
        Fri,  5 Jun 2020 11:36:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81D5BDA811; Fri,  5 Jun 2020 13:36:39 +0200 (CEST)
Date:   Fri, 5 Jun 2020 13:36:39 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v7 1/2] btrfs: Introduce "rescue=" mount option
Message-ID: <20200605113638.GB27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20200604071807.61345-1-wqu@suse.com>
 <20200604071807.61345-2-wqu@suse.com>
 <3659322f-0687-d179-ff89-f3a303fe2379@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3659322f-0687-d179-ff89-f3a303fe2379@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jun 05, 2020 at 06:04:01PM +0800, Anand Jain wrote:
> On 4/6/20 3:18 pm, Qu Wenruo wrote:
> > This patch introduces a new "rescue=" mount option group for all those
> > mount options for data recovery.
> > 
> > Different rescue sub options are seperated by ':'. E.g
> > "ro,rescue=nologreplay:usebackuproot".
> > (The original plan is to use ';', but ';' needs to be escaped/quoted,
> > or it will be interpreted by bash)
> 
>   I fell ':' isn't suitable here.

What do you suggest then?

> > And obviously, user can specify rescue options one by one like:
> > "ro,rescue=nologreplay,rescue=usebackuproot"
> 
>   This should suffice right?

Setting the rescue= value separately should be supported, but requiring
to write the option name for each value defeats the purpose to make it
compact and user friendly.
