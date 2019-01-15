Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5227EC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BA3920656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388355AbfAORcf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:32:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:54694 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726022AbfAORce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:32:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC352AF3C;
        Tue, 15 Jan 2019 17:32:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E27ADA83D; Tue, 15 Jan 2019 18:32:05 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:32:04 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: handle balance and replace concurrency
Message-ID: <20190115173204.GJ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1545148904-32714-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545148904-32714-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 19, 2018 at 12:01:44AM +0800, Anand Jain wrote:
> Test case:
> Run replace
>  btrfs repl start -B -f /dev/sdd /dev/sdb /btrfs;
> while replace is still running, from another terminal try to start
> balance
>  btrfs bal start  --full-balance /btrfs; echo ...:$?
>  Done, had to relocate 0 out of 0 chunks
>  ...:0
> 
> which fails to report that balance failed to relocate because another
> exclusive operation is running.
> In fact kernel ioctl BTRFS_IOC_BALANCE(_V2) does return error code 8,
> but progs recast it to 0. Fix it by checking for the error code > 0.
> 
> After:
>  btrfs bal start --full-balance /btrfs; echo ...:$?
>  ERROR: balance: add/delete/balance/replace/resize operation in progress
>  ...:8
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
