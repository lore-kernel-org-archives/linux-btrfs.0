Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82425C18DF5
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 14:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4393920831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 14:48:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4393920831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbeKUBSK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 20:18:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:38130 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725899AbeKUBSK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 20:18:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16FB7AD3C;
        Tue, 20 Nov 2018 14:48:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0F73ADA8A7; Tue, 20 Nov 2018 15:48:18 +0100 (CET)
Date:   Tue, 20 Nov 2018 15:48:17 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 0/3] btrfs: balance: improve kernel logs
Message-ID: <20181120144817.GK24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 04:12:54PM +0800, Anand Jain wrote:
> v5->v6:
>  Mostly the defines non functional changes.
>  Use goto instead of return in middle of the define.
>  Pls ref individual patches 1/3 and 2/3 for more info.
> 
> v4->v5:
>  Mainly address David review comment [1].
>  [1]
>   https://patchwork.kernel.org/patch/10425987/
>  pls ref to individual patch 2/3 for details.
> 
> v3->v4:
>  Pls ref to individual patches.
> 
> Based on misc-next.
> 
> v2->v3:
>   Inspried by describe_relocation(), improves it, makes it a helper
>   function and use it to log the balance operations.
> 
> Kernel logs are very important for the forensic investigations of the
> issues, these patchs make balance logs easy to review.
> 
> Anand Jain (3):
>   btrfs: add helper function describe_block_group()
>   btrfs: balance: add args info during start and resume
>   btrfs: balance: add kernel log for end or paused

Now in topic branch ext/anand/balance-description in my devel repos, I
made some changes as I don't want to take the rounds through mail. There
are some cosmetic changes like reordering the balance args, added
comments and aligned the \ even farther to the right. Please check the
committed patches for some inspiration.

I'll add that to misc-next after passes some tests, until then it'll be
in for-next. Thanks.
