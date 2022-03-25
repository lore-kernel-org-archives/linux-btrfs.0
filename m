Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0057C433F5
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Mar 2022 07:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241927AbiCYHvu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Mar 2022 03:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233984AbiCYHvt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Mar 2022 03:51:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093319E9F4
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2022 00:50:13 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1E96368B05; Fri, 25 Mar 2022 08:50:10 +0100 (CET)
Date:   Fri, 25 Mar 2022 08:50:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs zoned fixlets
Message-ID: <20220325075009.GA7096@lst.de>
References: <20220324165210.1586851-1-hch@lst.de> <PH0PR04MB74167494E27155CC7667BF969B1A9@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74167494E27155CC7667BF969B1A9@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 25, 2022 at 07:35:57AM +0000, Johannes Thumshirn wrote:
> On 24/03/2022 17:55, Christoph Hellwig wrote:
> > Hi all,
> > 
> > this series fixes a minor and slightly less minor problem in the btrfs
> > zoned device code.  Note that for the second patch the comment might
> > not be correct any more - AFAICS 5.18 added support for the dup
> > profile for zoned devices, which means we do have a real issue now
> > if different devices have different hardware limitations.
> 
> It's not a problem, as a) DUP is not spanning multiple devices, but
> only used on one device and b) DUP is (as of now) only used on meta-data
> which can't use zone append.

Ok, in that case the comment that I wrote based on the 5.17-ish code
is still correct.
