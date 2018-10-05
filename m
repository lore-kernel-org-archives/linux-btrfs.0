Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB419C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 20:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AD3420652
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 20:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AD3420652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbeJFDmg convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 23:42:36 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46811 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729220AbeJFDmg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 23:42:36 -0400
Authentication-Results: auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 4F29C3C4B85;
        Fri,  5 Oct 2018 22:42:12 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS related kernel backtrace on boot on 4.18.7 after blackout due to discharged battery
Date:   Fri, 05 Oct 2018 22:42:11 +0200
Message-ID: <1788048.LBgZkGOCjK@merkaba>
In-Reply-To: <CAL3q7H5Hi_C7Qe1Tv2ig7HX0rj+p0g8ipCqDYoNfNoHu+LWKmw@mail.gmail.com>
References: <3666619.NTnn27ZJZE@merkaba> <CAL3q7H5Hi_C7Qe1Tv2ig7HX0rj+p0g8ipCqDYoNfNoHu+LWKmw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Filipe Manana - 05.10.18, 17:21:
> On Fri, Oct 5, 2018 at 3:23 PM Martin Steigerwald 
<martin@lichtvoll.de> wrote:
> > Hello!
> > 
> > On ThinkPad T520 after battery was discharged and machine just
> > blacked out.
> > 
> > Is that some sign of regular consistency check / replay or something
> > to investigate further?
> 
> I think it's harmless, if anything were messed up with link counts or
> mismatches between those and dir entries, fsck (btrfs check) should
> have reported something.
> I'll dig a big further and remove the warning if it's really harmless.

I just scrubbed the filesystem. I did not run btrfs check on it.

> > I already scrubbed all data and there are no errors. Also btrfs
> > device stats reports no errors. SMART status appears to be okay as
> > well on both SSD.
> > 
> > [    4.524355] BTRFS info (device dm-4): disk space caching is
> > enabled [… backtrace …]
-- 
Martin


