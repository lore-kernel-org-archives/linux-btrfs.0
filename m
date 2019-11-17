Return-Path: <SRS0=VfBG=ZJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C34C432C0
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Nov 2019 18:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A8B52075C
	for <linux-btrfs@archiver.kernel.org>; Sun, 17 Nov 2019 18:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfKQStb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 17 Nov 2019 13:49:31 -0500
Received: from dc2.fullpliant.org ([213.186.44.166]:45266 "HELO
        dc2.fullpliant.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726067AbfKQStb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Nov 2019 13:49:31 -0500
Date:   Sun, 17 Nov 2019 19:49:07 +0000
From:   Hubert Tonneau <hubert.tonneau@fullpliant.org>
To:     Goffredo Baroncelli <kreijack@libero.it>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Avoiding BRTFS RAID5 write hole
Message-ID: <copliant/KV8E24Q0/0JGI3HI@copliant.storga.com>
In-Reply-To: <ba3a73e8-d009-48f6-a6b0-e6ba57752798@libero.it>
References: <0JGAX5Q12@briare1.fullpliant.org> <7723feea-c3cd-b1eb-b882-aa782bbc6e2a@libero.it> <hubert_tonneau/4RYCU6X4/0JGEB54@hubert-tonneau.storga.com> <ba3a73e8-d009-48f6-a6b0-e6ba57752798@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Goffredo Baroncelli wrote:
>
> You are suggesting to keep the "hot" data in a RAID1 block group, and write/update the RAID5 block group only when the data is "cold" in the RAID1 cache.

That's it.
Just remove the last word 'cache' because in some cases, the data might also remain as RAID1 forever, as an exemple if the nocow flag is set and the partition has enough free space.

Regards,
Hubert Tonneau
