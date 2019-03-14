Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1ACFC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 07:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 980242087C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 07:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfCNH4d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:56:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35091 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727078AbfCNH4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 03:56:33 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andrea.righi@canonical.com>)
        id 1h4LE6-0002tq-Ly
        for linux-btrfs@vger.kernel.org; Thu, 14 Mar 2019 07:56:30 +0000
Received: by mail-wr1-f69.google.com with SMTP id i9so1996255wrx.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 00:56:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3wEfAYg5QBUqj9nE6RjRQVWJUb1j9NoqfFItG/uFkbk=;
        b=LAwenvvxB5ePwxhnIswz79wF7uLUDFW5VzWMgkRMMrNudjhL6wORh1ziHPKW0aXJ1y
         lhXekdBvKcb5u5xtUq3Ec5G1CP6xwPPj580w3VM5qY77kMuu0PSGvRPUc1WWxZMrG5oi
         XVD5En/O4h2Bn64+e5NC/aYB1f7IZL3clbC3LmkTVaYTln3FA7eNknKVO9H8MK4V93if
         BgRTbN8F7YOTkfSjERYPyfhre6rpAzmwykLTcyOqPClOFC2flE41BQ/nC+HJdd+CEVCv
         QbW1dTsHUKKERMsP5VrHcoTmuEVNBEh2DkFib0/UrnvstdHNbXUu/6xKm9SmijjAsPAf
         MTsw==
X-Gm-Message-State: APjAAAWwqZ0NV1OsuYnANuhVHEK+AsyjTpRAfRX0xp+MHW9R15VtSihr
        4CHlUk8s+pM+YIxrUgXxQ62slJg/mxfJrGYpC2X5r+QYUumXqDeL/8xvw1TqAeUzr0if5lzAWU2
        6QeGGCa4OlrrY9v/UOCXnWW+dmlxVzEFtzanesWsT
X-Received: by 2002:a1c:be14:: with SMTP id o20mr1425779wmf.110.1552550190356;
        Thu, 14 Mar 2019 00:56:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw1jID0w+vi+OxtwsnMY7KZFcOPbMJpxrJVfzHsBQ5aSjLyptshrS3XfRt985ZTInpcp11UdQ==
X-Received: by 2002:a1c:be14:: with SMTP id o20mr1425757wmf.110.1552550190017;
        Thu, 14 Mar 2019 00:56:30 -0700 (PDT)
Received: from localhost (host82-131-dynamic.21-87-r.retail.telecomitalia.it. [87.21.131.82])
        by smtp.gmail.com with ESMTPSA id g81sm1438122wmf.7.2019.03.14.00.56.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 00:56:29 -0700 (PDT)
Date:   Thu, 14 Mar 2019 08:56:28 +0100
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: raid56: properly unmap parity page in
 finish_parity_scrub()
Message-ID: <20190314075628.GA11282@xps-13>
References: <20190313101703.GA9155@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190313101703.GA9155@xps-13>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Parity page is incorrectly unmapped in finish_parity_scrub(), triggering
a reference counter bug on i386, i.e.:

 [ 157.662401] kernel BUG at mm/highmem.c:349!
 [ 157.666725] invalid opcode: 0000 [#1] SMP PTI

The reason is that kunmap(p_page) was completely left out, so we never
did an unmap for the p_page and the loop unmapping the rbio page was
iterating over the wrong number of stripes: unmapping should be done
with nr_data instead of rbio->real_stripes.

Test case to reproduce the bug:

 - create a raid5 btrfs filesystem:
   # mkfs.btrfs -m raid5 -d raid5 /dev/sdb /dev/sdc /dev/sdd /dev/sde

 - mount it:
   # mount /dev/sdb /mnt

 - run btrfs scrub in a loop:
   # while :; do btrfs scrub start -BR /mnt; done

BugLink: https://bugs.launchpad.net/bugs/1812845
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
Changes in v2:
 - added a better description about this fix (thanks to Johannes)

 fs/btrfs/raid56.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1869ba8e5981..67a6f7d47402 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2430,8 +2430,9 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			bitmap_clear(rbio->dbitmap, pagenr, 1);
 		kunmap(p);
 
-		for (stripe = 0; stripe < rbio->real_stripes; stripe++)
+		for (stripe = 0; stripe < nr_data; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
+		kunmap(p_page);
 	}
 
 	__free_page(p_page);
-- 
2.19.1

