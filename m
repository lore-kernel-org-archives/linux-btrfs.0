Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE72C64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 846C72075C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 16:21:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 846C72075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbeJIXi4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:38:56 -0400
Received: from len.romanrm.net ([91.121.75.85]:39192 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbeJIXiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:38:55 -0400
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by len.romanrm.net (Postfix) with SMTP id E3A74202C7;
        Tue,  9 Oct 2018 16:21:11 +0000 (UTC)
Date:   Tue, 9 Oct 2018 21:21:12 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     "Gervais, Francois" <FGervais@distech-controls.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: CoW behavior when writing same content
Message-ID: <20181009212112.044f716b@natsu>
In-Reply-To: <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com>
References: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
        <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 9 Oct 2018 09:52:00 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> You'll be left with three files. /big_file and root/big_file will
> share extents, and snapshot/big_file will have its own extents. You'd
> need to copy with --reflink for snapshot/big_file to have shared
> extents with /big_file - or deduplicate.

Or use rsync for copying, in the mode where it reads and checksums blocks of
both files, to copy only the non-matching portions.

rsync --inplace

              This  option  is  useful  for  transferring  large  files   with
              block-based  changes  or appended data, and also on systems that
              are disk bound, not network bound.  It  can  also  help  keep  a
              copy-on-write filesystem snapshot from diverging the entire con‐
              tents of a file that only has minor changes.

-- 
With respect,
Roman
