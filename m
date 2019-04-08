Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DFFC10F13
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 18:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CED720833
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 18:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfDHSlA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 14:41:00 -0400
Received: from aquinas.techsquare.com ([75.125.237.226]:45915 "EHLO
        techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726625AbfDHSlA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2019 14:41:00 -0400
Received: from sb by techsquare.com with local (Exim 4.71)
        (envelope-from <sb@techsquare.com>)
        id 1hDZCV-0001Up-CC; Mon, 08 Apr 2019 14:40:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23723.38331.320895.916102@techsquare.com>
Date:   Mon, 8 Apr 2019 14:40:59 -0400
To:     Hugo Mills <hugo@carfax.org.uk>
Cc:     "Scott E. Blomquist" <sb@techsquare.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: checksum error...
In-Reply-To: <20190408162947.GF1084@carfax.org.uk>
References: <23723.27955.359573.44839@techsquare.com>
        <20190408162947.GF1084@carfax.org.uk>
X-Mailer: VM 8.0.13 under 23.1.1 (x86_64-pc-linux-gnu)
From:   "Scott E. Blomquist" <sb@techsquare.com>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: sb@techsquare.com
X-SA-Exim-Scanned: No (on techsquare.com); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hugo Mills writes:
 > On Mon, Apr 08, 2019 at 11:48:03AM -0400, Scott E. Blomquist wrote:
 > > 
 > > Hi All,
 > > 
 > > The weekend btrfs scrub/balance came back with this following...
 > > 
 > > [Sun Apr  7 06:57:10 2019] BTRFS warning (device sdb1): checksum error at logical 274820497408 on dev /dev/sda1, sector 536758784, root 271471, inode 109421914, offset 491520, length 4096, links 1 (path: yyyy/yyyyy)
 > [snip]
 > 
 >    Since there doesn't seem to be anything else wrong (no messages
 > without a filename, which would imply metadata corruption), this is
 > most likely a simple case of on-device corruption.
 > 
 >    Delete yyyy/yyyyy and restore it from backups. At least, do so in
 > the working copy; The snapshots of it can safely remain until they get
 > rotated out normally.
 > 
 >    Check your SMART statistics and see if anything looks wrong there
 > on the hardware side. Also check dmesg and earlier kernel logs for
 > signs of the hardware showing an error on read -- it may have tried
 > several times to read that location before giving up and/or returning
 > bad data.
 > 
 >    Hugo.

Thanks, Hugo.  Very helpful.

Turns out event log from MegaCli is showing some unexpected sense in
the eventlog.

Cheers,

sb. Scott Blomquist
