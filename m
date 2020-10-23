Return-Path: <SRS0=6VRt=D6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0773BC4363A
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 12:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B016720874
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Oct 2020 12:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463950AbgJWMhl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 08:37:41 -0400
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:42229 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373146AbgJWMhl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Oct 2020 08:37:41 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2677288|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.0689123-0.000655791-0.930432;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047187;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=8;RT=8;SR=0;TI=SMTPD_---.InSC3YF_1603456657;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.InSC3YF_1603456657)
          by smtp.aliyun-inc.com(10.147.42.197);
          Fri, 23 Oct 2020 20:37:38 +0800
Date:   Fri, 23 Oct 2020 20:37:43 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs: add ssd_metadata mode
Cc:     Adam Borowski <kilobyte@angband.pl>,
        Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs@vger.kernel.org, Michael <mclaud@roznica.com.ua>,
        Hugo Mills <hugo@carfax.org.uk>,
        Martin Svec <martin.svec@zoner.cz>,
        Goffredo Baroncelli <kreijack@inwind.it>
In-Reply-To: <d7ee1c25-ceea-0471-9702-0622a5ef4453@gmx.com>
References: <20201023101145.GB19860@angband.pl> <d7ee1c25-ceea-0471-9702-0622a5ef4453@gmx.com>
Message-Id: <20201023203742.B13F.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Can we add the feature of 'Storage Tiering' to btrfs for these use cases?

1) use faster tier firstly for metadata

2) only the subvol with higher tier can save data to 
    the higher tier disk?

3) use faster tier firstly for mirror selection of RAID1/RAID10

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/23


