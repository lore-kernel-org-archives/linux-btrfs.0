Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2849C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 18:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D8E220643
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 18:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389842AbfDRSaP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 14:30:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:35878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390096AbfDRSB6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 14:01:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BBE5B112;
        Thu, 18 Apr 2019 18:01:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5EE34DA991; Thu, 18 Apr 2019 20:03:04 +0200 (CEST)
Date:   Thu, 18 Apr 2019 20:03:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL REQUEST v2] btrfs-progs updates, the main part
Message-ID: <20190418180304.GQ20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <cb2ed110-4ad0-6f72-2dcb-fe150bab461e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb2ed110-4ad0-6f72-2dcb-fe150bab461e@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 16, 2019 at 10:23:59AM +0800, Qu Wenruo wrote:
> Hi David,
> 
> Here is my pull request for the btrfs-progs:
> https://github.com/adam900710/btrfs-progs/tree/for_devel
> 
> The basis is the following commit from your devel branch:
> commit cfa470d5a6b6b305fed4898b64db31c125b4dcbc (david/devel)
> Author: Nikolay Borisov <nborisov@suse.com>
> Date:   Mon Mar 11 12:20:56 2019 +0200
> 
>     btrfs-progs: Remove get_argv0_buf
> 
> The commit on the top is going to revert 7a12d8470e5f ("btrfs-progs: Do
> metadata preallocation as long as we're not modifying extent tree").
> 
> You can drop that commit if you have discarded that commit.

Oh sorry, I forgot to push an updated devel without the broken patch so
you don't have to revert it. I see how can I fix it locally so you don't
need to resend the pull again.
