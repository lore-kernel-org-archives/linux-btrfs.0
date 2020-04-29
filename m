Return-Path: <SRS0=gyFW=6N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA3ACC83000
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 19:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C685C208FE
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 19:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgD2TBA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2TA7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Apr 2020 15:00:59 -0400
Received: from savella.carfax.org.uk (2001-ba8-1f1-f0e6-0-0-0-2.autov6rev.bitfolk.space [IPv6:2001:ba8:1f1:f0e6::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58EDC03C1AE
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2020 12:00:58 -0700 (PDT)
Received: from hrm by savella.carfax.org.uk with local (Exim 4.92)
        (envelope-from <hrm@savella.carfax.org.uk>)
        id 1jTrx3-0004IT-B7; Wed, 29 Apr 2020 20:00:57 +0100
Date:   Wed, 29 Apr 2020 20:00:57 +0100
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: nodatacow questions
Message-ID: <20200429190057.GE30508@savella.carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>,
        linux-btrfs@vger.kernel.org
References: <f2e0ca56-c059-978a-2d47-73204b22945b@peter-speer.de>
 <20200429183344.GD30508@savella.carfax.org.uk>
 <2eca0956-c45a-7d3f-1d04-b05a35db0722@peter-speer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eca0956-c45a-7d3f-1d04-b05a35db0722@peter-speer.de>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 29, 2020 at 08:39:37PM +0200, Stefanie Leisestreichler wrote:
> On 29.04.20 20:33, Hugo Mills wrote:
> > Don't use snapshots, or don't use nodatacow.
> > 
> > Set autodefrag and don't use nodatacow would be my recommendation.
> 
> Thanks for this smart tip.
> 
> I guess, the same applies to a subvolume which will hold images of virtual
> machines, right?

   Correct.

> Do you have more recommendations, especially for these two use cases
> (qemu-images and databases)?

   At least for the VM images, use raw files, not qcow2, and it's
probably best to not use btrfs inside the image -- you want to reduce
the number of layers of CoW.

   Hugo.

-- 
Hugo Mills             | Once is happenstance; twice is coincidence; three
hugo@... carfax.org.uk | times is enemy action.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |
