Return-Path: <SRS0=psRg=A2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C47D4C433E1
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 21:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF9D206F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 21:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGOVj7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 17:39:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:49310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgGOVj6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jul 2020 17:39:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 20CA0ACC3;
        Wed, 15 Jul 2020 21:40:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1B1FDA790; Wed, 15 Jul 2020 23:39:34 +0200 (CEST)
Date:   Wed, 15 Jul 2020 23:39:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Steven Davies <btrfs-list@steev.me.uk>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Wiki updates - source location
Message-ID: <20200715213934.GA3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Steven Davies <btrfs-list@steev.me.uk>,
        linux-btrfs@vger.kernel.org
References: <2fd9b9626b55cf738dbe81ca45552950@steev.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2fd9b9626b55cf738dbe81ca45552950@steev.me.uk>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jul 15, 2020 at 03:55:53PM +0100, Steven Davies wrote:
> Could someone with the relevant access update the btrfs wiki main 
> page[1] to point at the kdave repository rather than mason? I think a 
> pointer to where to find the misc-next branch could be useful too.
> 
> [1] 
> https://btrfs.wiki.kernel.org/index.php/Main_Page#Source_code_download

I'll update it, thanks.
