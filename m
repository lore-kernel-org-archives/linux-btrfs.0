Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9901CC2BA83
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 16:14:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 773A0217BA
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 16:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgBGQON (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 11:14:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:37176 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgBGQON (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Feb 2020 11:14:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 20762AD07;
        Fri,  7 Feb 2020 16:14:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 33531DA790; Fri,  7 Feb 2020 17:13:58 +0100 (CET)
Date:   Fri, 7 Feb 2020 17:13:58 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Sterba <dsterba@suse.cz>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] btrfs: use the page-cache for super block reading
Message-ID: <20200207161358.GH2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
References: <20200205143831.13959-1-johannes.thumshirn@wdc.com>
 <20200205143831.13959-2-johannes.thumshirn@wdc.com>
 <20200205165319.GA6326@infradead.org>
 <SN4PR0401MB359854D81C504BBE28B8B2EB9B1D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200206145759.GA24780@infradead.org>
 <SN4PR0401MB359856AB4365DC83FBE99E0A9B1D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB359856AB4365DC83FBE99E0A9B1D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 06, 2020 at 03:29:57PM +0000, Johannes Thumshirn wrote:
> On 06/02/2020 15:58, Christoph Hellwig wrote:
> > Also I just noticed don't even need the kmap/kunmap at all given that the
> > block device mapping is never in highmem.
> > 
> 
> This potentially touches more places, I'll cover that in a dedicated 
> patchset.

Are the kmap/kunmaps anywhere on the buffer_head call paths? I can't
find it anywhere, and given that the mapping does not contain highmem
pages we could rather avoid adding it from the beginning.
