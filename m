Return-Path: <SRS0=GUsV=ZY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24DCC432C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Dec 2019 18:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 722B120717
	for <linux-btrfs@archiver.kernel.org>; Mon,  2 Dec 2019 18:19:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="WKNEIjMu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfLBSTg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 13:19:36 -0500
Received: from smtp-18.italiaonline.it ([213.209.10.18]:50457 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727670AbfLBSTg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Dec 2019 13:19:36 -0500
Received: from venice.bhome ([84.220.25.30])
        by smtp-18.iol.local with ESMTPA
        id bqIHizXEsNNGebqIHidLf1; Mon, 02 Dec 2019 19:19:34 +0100
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1575310774; bh=Ti4jT7kv1e6aGYIU5onLkxPdWno74c48D0qxxQirqrA=;
        h=From:To:Cc:Subject:Date;
        b=WKNEIjMueP/mtGHCovUztj+Wz7l3lUCphycv5sCaqrvPFYLY42F5OkCuQUFir/ZYq
         5g1aM/7GOyTTB6ESfolRL6QjMlNb0EbijdfgJImQ/ZRLz6NdRTNswfB3UiHa6RUJ0r
         uLbxuNdt1Gib52qjUo612xqfqub6uCt0MB6HnA0Z5u9Kzrbfpmu+etboi9UevTCGSb
         HMx/U2B5y/UrgujXjMiOWh6eUVZPzEkOtHGGddz7obgjKVzzv1Dp6q6n66YRwcclw3
         PYqDbZC7nIcD3wxZ4tGutvhsF7+2pMZb5C9VQENDOOZo3PWHhJYDprHfb7BK8ijTwd
         XzjXEF38jqlnQ==
X-CNFS-Analysis: v=2.3 cv=B4jHL9lM c=1 sm=1 tr=0
 a=zfQl08sXljvZd6EmK9/AFg==:117 a=zfQl08sXljvZd6EmK9/AFg==:17
 a=NxtcBlksYuj6QNs_dvAA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     David Sterba <dsterba@suse.cz>
Cc:     linux-btrfs@vger.kernel.org
Subject: [RFC] GRUB: add support for RAID1C3 and RAID1C4
Date:   Mon,  2 Dec 2019 19:19:27 +0100
Message-Id: <20191202181928.3098-1-kreijack@libero.it>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBtZ8+d5evT+aAQb5+VPyGdO2xixP9IO1c3C4fWVCTfLFgfzVzcx9Zf/wM20tnu6U/y3AhmRARybpI2VrbF6SMj6YO40aCi4KAVwn4w1sayx5qv+Ridm
 TMw+t5XNSULMo32jQeKmURqH5p/M7lwySHIuRM0CJ0ABiCUN65rUbfU8+qJCth/lmVvQoEU/BXT1JE4u/CYyv5cUay9tc5smSdZiNPiMt+ncGsZjrODw9Yay
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


The enclosed patch adds support for RAID1C3 and RAID1C4 to grub.
I know that David already told that he want to write one; however
recently I looked to the grub source and so I make a patch.

I tested the patch as following:
- computing the checksum of a file bigger than 64KB in a RAID1C3 
  filesystem (so the file is in a data bG)
- computing the checksum of a file smaller than 64KB in a RAID1C3
  filesystem (so the file is in the metadata BG)
- computing the checksum of a file bigger than 64KB in a RAID1C4 
  filesystem (so the file is in a data bG)
- computing the checksum of a file smaller than 64KB in a RAID1C4
  filesystem (so the file is in the metadata BG)
- perform the tests abowe removing some disks in order to test all the
  possible missing disks combination

Of course the test is considered passed if the checksum matches with
its correct value.

Comments are welcome.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

