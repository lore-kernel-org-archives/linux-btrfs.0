Return-Path: <SRS0=LXly=V4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A69C433FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Jul 2019 08:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A829C206A2
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Jul 2019 08:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfGaIGp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Jul 2019 04:06:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:50156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfGaIGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jul 2019 04:06:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF9A3AFF2
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2019 08:06:43 +0000 (UTC)
Date:   Wed, 31 Jul 2019 10:06:42 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] btrfs: sysfs: export supported checksums
Message-ID: <20190731080642.GA3856@x250>
References: <cover.1564046812.git.jthumshirn@suse.de>
 <e377ded65e4f2799776596ead308658710e4c8c1.1564046812.git.jthumshirn@suse.de>
 <20190730171904.GE28208@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190730171904.GE28208@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 30, 2019 at 07:19:04PM +0200, David Sterba wrote:
> On Thu, Jul 25, 2019 at 11:33:51AM +0200, Johannes Thumshirn wrote:
> > From: David Sterba <dsterba@suse.com>
> > 
> > Export supported checksum algorithms via sysfs.
> 
> I wonder if we should also export the implementation that would be used.
> This could be crross referenced with /proc/crypto, but having it in one
> place would be IMHO convenient.  Also for the case when the kernel
> module is missing.
> 
> Currently the hash names are printed as comma separated values so we'd
> need bit something structured:
> 
> crc32c: crc32c-intel
> xxhash64: xxhash-generic
> 
> or if there's some other format in common use.

Sounds good, will do.

-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
