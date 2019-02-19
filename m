Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DAAC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 17:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE1F62075A
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 17:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfBSRxF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 12:53:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:43338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725807AbfBSRxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 12:53:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4F05AB16E;
        Tue, 19 Feb 2019 17:53:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4FFC4DA83C; Tue, 19 Feb 2019 18:54:23 +0100 (CET)
Date:   Tue, 19 Feb 2019 18:54:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Peter Becker <floyd.net@gmail.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>
Subject: Re: [PATCH v2.1] btrfs: ensure that a DUP or RAID1 block group has
 exactly two stripes
Message-ID: <20190219175421.GS9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Peter Becker <floyd.net@gmail.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        Liu Bo <obuil.liubo@gmail.com>
References: <210585b9-99e9-1548-f2b1-66445ab179bb@suse.de>
 <20190218102837.15219-1-jthumshirn@suse.de>
 <CAEtw4r2tHWRNSOP6OiAfBHPdGpwZsckL9KOd3vkogDAk+gsz8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEtw4r2tHWRNSOP6OiAfBHPdGpwZsckL9KOd3vkogDAk+gsz8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 19, 2019 at 08:33:23AM +0100, Peter Becker wrote:
> I would prefer "< 2" .. in both cases (RAID1 and DUP) because this
> allow us to implement N-Copy RAID1 in the future.

The n-copy raid has or will have own block group type so there will be a
separate check for the constraints.
