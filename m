Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2017AC7618B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 11:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1932238C
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 11:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391257AbfGYLVj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 07:21:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:53850 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389393AbfGYLVi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 07:21:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E02C2AFF9;
        Thu, 25 Jul 2019 11:21:37 +0000 (UTC)
Date:   Thu, 25 Jul 2019 13:21:37 +0200
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] btrfs: turn checksum type define into a union
Message-ID: <20190725112137.GD8976@x250.microfocus.com>
References: <cover.1564046812.git.jthumshirn@suse.de>
 <6601e14425550304e1ba8b5317e74a5f806d6a34.1564046812.git.jthumshirn@suse.de>
 <CAMU1PDgcQhvQcc-=Q8XZcr5XLjVUxHpx7xD328JZBKTh3QGFHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMU1PDgcQhvQcc-=Q8XZcr5XLjVUxHpx7xD328JZBKTh3QGFHw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 25, 2019 at 12:08:44PM +0100, Mike Fleetwood wrote:
> On Thu, 25 Jul 2019 at 10:34, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> >
> > Turn the checksum type definition into a union. This eases later addition
> > of new checksums.
> 
> I think you meant to say "Turn the checksum type definition into an
> _enum_." in the title and commit message.

Indeed I did want to write 'enum'. No idea why I wrote union o.O

Thanks for spotting,
	JOhannes
-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
