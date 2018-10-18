Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B5CECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 117F8204FD
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 17:56:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="mNAvUjD+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 117F8204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbeJSB6I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 21:58:08 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:52858 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726822AbeJSB57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 21:57:59 -0400
Received: from venice.bhome ([94.38.16.140])
        by smtp-34.iol.local with ESMTPA
        id DCWVgs2H18KmnDCWVgOdUS; Thu, 18 Oct 2018 19:55:52 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1539885352; bh=kU74WwQq0a3/+qvQ716aYO9ikNbdn54lg3cV2chyuNI=;
        h=From:To:Cc:Subject:Date;
        b=mNAvUjD+v3Z3J/n5YvpDSuUQv0SSZZF68byZOy72Uw9O+FXlkGV7sB0+rGXivkWHn
         yf/4B9/eCBjlrHHCNdv2k5awBTxZSDs/Axf/YotDjf03DqcByWUdewBkhCVIYEkpaJ
         YucFTfimUluGnVopAoBDoJ059y2iCbJdwWEda5gThFZk5pj8kQzMCwq4CRMdb48Tz2
         QTPrIX77tj9GS9kOeAp2ZN0/LNrpI04KKSKZu5f2YaeHvLD3G+kBEMRhGeXjbarbwL
         6tcYVVszq+pMCb2IM8m9f6OdHVXmajytGa/uaJdDF+v39aM7AqEjcaI0JVyLnpNiOK
         aulOxMlcuHJag==
X-CNFS-Analysis: v=2.3 cv=ZbLMyfdA c=1 sm=1 tr=0
 a=nqgIlLay6LNLiZJCVl9G2Q==:117 a=nqgIlLay6LNLiZJCVl9G2Q==:17
 a=ao3zGDP3_Vv2xw11vPcA:9
From:   Goffredo Baroncelli <kreijack@libero.it>
To:     grub-devel@gnu.org
Cc:     Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org
Subject: [PATCH V10] Add support for BTRFS raid5/6 to GRUB
Date:   Thu, 18 Oct 2018 19:55:32 +0200
Message-Id: <20181018175541.9532-1-kreijack@libero.it>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfNL1fYobHY7OOyWh4B9XlEOJUJi9iSvu/GgQov9RUz9u22NgLKD6V8GsDuzix3QOuQqUIJ6Qj0tPO56+X4WymHJ1yrwcTLXAOfrplRXQ+T/kPu//lsu2
 rtP6E+e0dUfaoPmXYT7vFrs8GbHIfj/Lp4/6b7KdY5g5XmcU0+YIv52x/rMADtGTENwD6+mpJGFRM5zDR13FMzbRlSlcdjAp5kW9zmGnn9/VuyqF29ZsBmFk
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
    a fully agreement about this text. NB: the update are relate only to
    comments
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

v10:- patch 1: update comments (replace might with can)
    - patch 4: add a Signed off by Daniel
    - patch 7: drop an empty line; changed some text in grub_dprintf;
      reversed the logic of an if (if(!is_raid56) A else B -> if(is_raid5) B
      else A); add a space between the function name and the '('
    - patch 9: update the wording in the comment; s/raid6/RAID 6/ in 
      grub_dprintf()

BR
G.Baroncelli

--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5





