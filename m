Return-Path: <SRS0=TZ5r=2N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A801DC2D0C0
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Dec 2019 13:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E2F2053B
	for <linux-btrfs@archiver.kernel.org>; Mon, 23 Dec 2019 13:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=lesimple.fr header.i=@lesimple.fr header.b="4AAsexld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLWNwE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 23 Dec 2019 08:52:04 -0500
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:41504 "EHLO
        mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726676AbfLWNwE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Dec 2019 08:52:04 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2019 08:52:03 EST
Received: from [10.61.87.69] (unknown [92.184.98.27])
        by box.speed47.net (Postfix) with ESMTPSA id 34B5AF3C
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Dec 2019 14:44:09 +0100 (CET)
Authentication-Results: box.speed47.net; dmarc=fail (p=none dis=none) header.from=lesimple.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesimple.fr;
        s=mail01; t=1577108649;
        bh=JaEwpKd5UaflQRACXfkYqFHukD8MqTgW4RxaXIX6Xxs=;
        h=From:To:Date:Subject;
        b=4AAsexldPJTqam5IGUYehmELzSJUwbnKtWjRuhqAhsJyoifOLCr7EktULVr5QB3fk
         M7dTD3jaVvf10uHmGjCGwV3DYSCjK3JiCqd6lf0vOtEoO3mTQY9BRW4Bp8PLTs393Y
         bexoDy9J3pBJl8zoauGx3BMXQ7Uw20jaJnenkabE=
From:   =?UTF-8?B?U3TDqXBoYW5lIExlc2ltcGxl?= <stephane_btrfs@lesimple.fr>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date:   Mon, 23 Dec 2019 14:44:07 +0100
Message-ID: <16f33002870.2787.faeb54a6cf393cf366ff7c8c6259040e@lesimple.fr>
User-Agent: AquaMail/1.22.0-1511 (build: 102200004)
Subject: Metadata chunks on ssd?
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello btrfs gurus,

Has this ever been considered to implement a feature so that metadata 
chunks would always be allocated on a given set of disks part of the btrfs 
filesystem?

As metadata use can be intensive and some operations are known to be slow 
(such as backref walking), I'm under the (maybe wrong) impression that 
having a set of small ssd's just for the metadata would give quite a boost 
to a filesystem. Maybe even make qgroups more usable with volumes having 10 
snapshots?

This could just be a preference set on the allocator, so that a 6 disks 
raid1 FS with 4 spinning disks and 2 ssds prefer to allocate metadata on 
the ssd than on the slow drives (and falling back to spinning disks if ssds 
are full, with the possibility to rebalance later).

Would such a feature make sense?

-- 
Stephane.


