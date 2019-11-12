Return-Path: <SRS0=1fJ+=ZE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EF2C43331
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D665F2084E
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Nov 2019 21:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfKLV1E (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:27:04 -0500
Received: from briare1.fullpliant.org ([78.227.24.35]:34002 "HELO
        briare1.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727151AbfKLV1D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Nov 2019 16:27:03 -0500
From:   Hubert Tonneau <hubert.tonneau@fullpliant.org>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Avoiding BRTFS RAID5 write hole
Date:   Tue, 12 Nov 2019 22:27:04 GMT
Message-ID: <0JG92D511@briare1.fullpliant.org>
X-Mailer: Pliant 114
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Goffredo Baroncelli wrote:
>
> Instead I would like to investigate the idea of COW-ing the stripe: instead of updating the stripe on place, why not write the new stripe in another place and then update the data extent to point to the new data ? Of course would work only for the data and not for the metadata.

We are saying the same.
What I am suggesting is to write it as RAID1 instead of RAID5, so that if it's changed a lot of times, you pay only once.

The background process would then turn it back to RAID5 at a later point.
Adjusting how aggressively this background process works enables to adjust the extra write cost versus saved disk space compromise.
