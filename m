Return-Path: <SRS0=i7A4=AU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C75C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jul 2020 03:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A238206E2
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 Jul 2020 03:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=schramm.by header.i=@schramm.by header.b="P/rwaeEN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgGIDwf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 23:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgGIDwf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2020 23:52:35 -0400
X-Greylist: delayed 485 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jul 2020 20:52:35 PDT
Received: from ulnar.ocb.by (ulnar.ocb.by [IPv6:2a01:4f8:192:2464:2:237:ffff:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA42C061A0B
        for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2020 20:52:34 -0700 (PDT)
Received: from ulnar.ocb.by (localhost [127.0.0.1])
        by ulnar.ocb.by (Postfix) with ESMTP id B24AE40161
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2020 05:44:24 +0200 (CEST)
Authentication-Results: ulnar.ocb.by;
        dkim=pass (2048-bit key; unprotected) header.d=schramm.by header.i=@schramm.by header.b="P/rwaeEN";
        dkim-atps=neutral
Received: from [IPv6:2a02:8106:f:37fc:329c:23ff:fe9a:9e57] (unknown [IPv6:2a02:8106:f:37fc:329c:23ff:fe9a:9e57])
        (Authenticated sender: lists@schramm.by)
        by ulnar.ocb.by (Postfix) with ESMTPSA id 8E588400E2
        for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2020 05:44:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=schramm.by;
        s=20200415; t=1594266264;
        bh=0Ep3jQ+ueG1U5q7GUFrgbhVVqsaBMWcepAMJfr1KHkQ=;
        h=To:From:Subject:Message-ID:Date:From;
        b=P/rwaeEN4AbWtkZWroYsv+vRJaFXiAmELVhLujwLP7Eox4NmVgCtF0sAqpg+6hvPW
         Wxnd3f1g/bdIkjiSZKWYgpvpMtVPee1R+a+1q00szeKaWZxNtBMsaLnNgyinc8XNBk
         mYexSddnn4//1kWw4Kn+Sd5BRy3UW2x3mZhheVBWPJAJ4mlKSbJB2NItTHzNFzDS/e
         de8N6kl2yNKkJ1UIGKlHqm2+zUrdlgQE+tBtNV2RDkrf/GT5l44DWPGZu8t+SqWNqb
         UlmCvnzNLX7GmHAsxSB2fsA7jU/lrV0C4RqaD1Z2+alqrcPF1z361aYwFIXTf79WwN
         1Xg1XT7T8kOag==
To:     linux-btrfs@vger.kernel.org
From:   Hans von Stoffeln <lists@schramm.by>
Subject: btrfs and system df
Message-ID: <3ffa3a38-0e98-886f-2cfb-3aeb9f2c1c7c@schramm.by>
Date:   Thu, 9 Jul 2020 05:44:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamSMTP @ Ulnar
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

current situation is that the linux system df thinks the drive is full:

/dev/mapper/HyVol002-hy002_data    3,0T    655G     0  100% 
/home/pyloor/data

But its not:

Overall:
     Device size:                   3.00TiB
     Device allocated:            655.07GiB
     Device unallocated:            2.36TiB
     Device missing:                  0.00B
     Used:                        654.34GiB
     Free (estimated):              2.36TiB      (min: 1.18TiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:653.01GiB, Used:652.74GiB (99.96%)
    /dev/mapper/HyVol002-hy002_data       653.01GiB

Metadata,DUP: Size:1.00GiB, Used:818.20MiB (79.90%)
    /dev/mapper/HyVol002-hy002_data         2.00GiB

System,DUP: Size:32.00MiB, Used:96.00KiB (0.29%)
    /dev/mapper/HyVol002-hy002_data        64.00MiB

Unallocated:
    /dev/mapper/HyVol002-hy002_data         2.36TiB


I searched for the answer in the internet and a balance was suggested. I 
did it:

btrfs fi balance start -dusage=5 .
Done, had to relocate 3 out of 659 chunks

I increment the value at usage to 95 but it says no chunks relocated.

Thanks for the help and sry for the newbie question.

Kind regards,
Holger
