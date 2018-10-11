Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DBEC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02D952075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="s889riXH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 02D952075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbeJLCTp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 22:19:45 -0400
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:46145 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729128AbeJLCTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 22:19:44 -0400
Received: from venice.bhome ([94.38.186.31])
        by smtp-33.iol.local with ESMTPA
        id Ag3FgMwlrQGOzAg3FgbXzR; Thu, 11 Oct 2018 20:51:14 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539283874; bh=TrDTA/GOD4T5Wg0Vw7DJs+CI4/aXkyWVXo20gj8Ok00=;
        h=From:To:Cc:Subject:Date;
        b=s889riXH/teyM2AOrFeNd8dSsXe+niyrv/5UmN/S+KOX5LEKzSXBjDZiCaPdrL5Ch
         I+N3XyJwzOTuMzrz9JgaBj7iBzwF/+ur69X6sTJqdsU0Im9uOSv9el09wcxFRgIazi
         XzQ85paMz+tX6ISfBJ7/QaKDM33doDZFuaPFp8kGRsajvGHslFW3l2TyZZyikskkEf
         VoS5N5JhYy3b82Ci64hihbWtDXNg2VDXyf/AeeNfO8P1A6xOHddKFPF76+ZH4aWX8V
         kHmuAkItnXisLVsj7JiPAkRyuBK/Hsg/76676u839XgmNfvqlnjGDnydMLbuJn11cy
         2fdEaJ8cAZUWg==
X-CNFS-Analysis: v=2.3 cv=OvCeNB3t c=1 sm=1 tr=0
 a=I+JNyrl7/zjgsFWlY3jFdA==:117 a=I+JNyrl7/zjgsFWlY3jFdA==:17
 a=Y2wJVeidm641J4seITcA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org
Subject: [PATCH V9] Add support for BTRFS raid5/6 to GRUB
Date:   Thu, 11 Oct 2018 20:50:54 +0200
Message-Id: <20181011185103.23146-1-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfB7r80I6B/TEVG9LJ70otK81y11lHjrb4zovuSXGQQOHlAqDr+PKfbm0hvVeB8RyuOopAxLsMNNUmMDCH3W9Ad/5N5PCJCR1zIQMYhWEefoEa84A14Ba
 fribfUjH2tDYs72vdjUy0rxt+Ip/z9Kt6nsCY5PEH1FForiyGfKwTGR6w067o1hu8Shh72vsyxUBnVl51/7RDCuE1sx3wsxBU0kSDcCzZ57i3vWpzkpSZNMQ
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hi All,

the aim of this patches set is to provide support for a BTRFS raid5/6
filesystem in GRUB.

The first patch, implements the basic support for raid5/6. I.e this works when
all the disks are present.

The next 5 patches, are preparatory ones.

The 7th patch implements the raid5 recovery for btrfs (i.e. handling the
disappearing of 1 disk).
The 8th patch makes the code for handling the raid6 recovery more generic.
The last one implements the raid6 recovery for btrfs (i.e. handling the
disappearing up to two disks).

I tested the code in grub-emu, and it works both with all the disks,
and with some disks missing. I checked the crc32 calculated from grub and
from linux and these matched. Finally I checked if the support for md raid6
still works properly, and it does (with all drives and with up to 2 drives
missing)

Comments are welcome.

Changelog
v1: initial support for btrfs raid5/6. No recovery allowed
v2: full support for btrfs raid5/6. Recovery allowed
v3: some minor cleanup suggested by Daniel Kiper; reusing the
    original raid6 recovery code of grub
v4: Several spell fix; better description of the RAID layout
    in btrfs, and the variables which describes the stripe
    positioning; split the patch #5 in two (#5 and #6)
v5: Several spell fix; improved code comment in patch #1, small
    clean up in the code
v6: Small cleanup; improved the wording in the RAID6 layout
    description; in the function raid6_recover_read_buffer() avoid
    a unnecessary memcpy in case of invalid data;
v7: - patch 2,3,5,6,8 received an Review-by Daniel, and were unchanged from
    the last time (only minor cleanup in the commit description requested by
    Daniel)
    - patch 7 received some small update rearranging a for(), and some
    bracket around if()
    - patch 4, received an update message which explains better why NULL
    is stored in data->devices_attached[]
    - patch 9, received a blank line to separate better a code line from
    a previous comment. A description of 'parities_pos' was added
    - patch 1, received a major update about the variable meaning description
    in the comment. However I suspect that we need some further review to reach
    a fully agreement about this text. NB: the update are relate only to comments
v8: - patch 2,5,6,8 received an Review-by Daniel, and were unchanged from
    the last time (only minor cleanup in the commit description requested by
    Daniel)
    - patch 1 received some adjustement to the variables description due to
      the different terminology between BTRFS and other RAID implementatio.
      Added a description for the "nparities" variable.
    - patch 3 removed some unnecessary curly brackets (change request by Daniel)
    - patch 4 received an improved commit description about why and how 
      the function find_device() is changed
    - patch 7 received an update which transforms a i = 0; while(i..) i++; in
      for( i = 0..... ; i++);
    - patch 9 received an update to the comment
v9: - patch 1: update comments
    - patch 4: update commit messages
    - patch 7: added a comment about accessing an array of structs
      after another structs; changed if(err == GRUB_ERR_NONE) in if(!err)
      changed if(err != GRUB_ERR_NONE) in if(err)



BR
G.Baroncelli

--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5





