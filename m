Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F255CC43334
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jun 2022 14:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiFUOT1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jun 2022 10:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349027AbiFUOTY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jun 2022 10:19:24 -0400
X-Greylist: delayed 428 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Jun 2022 07:19:23 PDT
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AB9B1A05C
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2022 07:19:23 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id CA281CD80A; Tue, 21 Jun 2022 10:12:14 -0400 (EDT)
References: <f5cc6c6f-2238-b126-3b0e-00e9e49b0706@gmail.com>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Zhang Boyang <zhangboyang.id@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [IDEA RFC] Forward error correction (FEC) / Error correction
 code (ECC) for BTRFS
Date:   Tue, 21 Jun 2022 09:56:48 -0400
In-reply-to: <f5cc6c6f-2238-b126-3b0e-00e9e49b0706@gmail.com>
Message-ID: <87zgi65cn5.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Zhang Boyang <zhangboyang.id@gmail.com> writes:

> Here are some detailed approaches:
>
> 1) Zero-cost approach

<snip>

> 2) Low-cost approach:

Both of these home brew methods rely on guess and check to repair, which
has a high computational cost and the possibility of false repair.  It
also requires that only a minescule amount of silent corruption has
occured.  Disk drives already have highly robust error correction and
detection in place, so it is almost unheard of for them to silently
corrupt data, but rather they refuse to read the whole sector.  If
corrupt data somehow managed to pass the error detection code in the
drive, it is highly likely that a lot more than one or two bytes will be wrong.


> 3) Reed-Solomon approach:

If you are going to do error correction, this or another real FEC
altorithm is the way to go.  Also since the drive reports corrupt
sectors, you can use RS in erasure mode where it can correct T errors
instead of T/2.  There is a handy tool called par2 that lets you create
a small RS FEC archive of a file that you can later use to repair damaged
portions of it.

Another common behavior of drives is for them to fail outright with 100%
data loss rather than just have a few bad sectors.  For that reason, I
think that anyone who really cares about their data should be using a
raid and making regular backups rather than relying on an automatic on
the fly FEC in the filesystem.  If they don't care enough to do that
then they probably don't care enough to think the cost of online FEC is
worth it either.
