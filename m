Return-Path: <SRS0=zJiL=XU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C24C432C2
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 16:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E21BD207E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 25 Sep 2019 16:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437675AbfIYQsP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:48:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:50376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731087AbfIYQsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Sep 2019 12:48:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 83987AF3B;
        Wed, 25 Sep 2019 16:48:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E0264DA835; Wed, 25 Sep 2019 18:48:33 +0200 (CEST)
Date:   Wed, 25 Sep 2019 18:48:33 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 1/7] btrfs-progs: add option for checksum type to mkfs
Message-ID: <20190925164833.GJ2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20190925133728.18027-1-jthumshirn@suse.de>
 <20190925133728.18027-2-jthumshirn@suse.de>
 <2cf167d7-eafc-b538-c254-525140e65ce3@suse.de>
 <1c4ad941-3b48-64ad-a485-2de7acf33edd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c4ad941-3b48-64ad-a485-2de7acf33edd@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 25, 2019 at 04:01:48PM +0200, Johannes Thumshirn wrote:
> On 25/09/2019 15:50, Johannes Thumshirn wrote:
> [...]
> > This looks like it's a rebasing error. I'll investigate what went wrong
> > here.
> 
> Yup that's a rebase error, please ignore this patch

No problem. I moved the option to the 'features' sections, so the rebase
on your side kept it in the 'creation' section.
