Return-Path: <SRS0=3fkC=C5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3134C43465
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Sep 2020 16:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CADD20723
	for <linux-btrfs@archiver.kernel.org>; Sun, 20 Sep 2020 16:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgITQPi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 20 Sep 2020 12:15:38 -0400
Received: from out20-85.mail.aliyun.com ([115.124.20.85]:41125 "EHLO
        out20-85.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgITQPi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 20 Sep 2020 12:15:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1422122|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.0170882-0.000895094-0.982017;FP=0|0|0|0|0|-1|-1|-1;HT=e01a16378;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.IZn5PZR_1600618532;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.IZn5PZR_1600618532)
          by smtp.aliyun-inc.com(10.147.42.197);
          Mon, 21 Sep 2020 00:15:33 +0800
Date:   Mon, 21 Sep 2020 00:15:32 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fstests@vger.kernel.org" <fstests@vger.kernel.org>
Subject: Re: [PATCH] btrfs: remove stale test for alien devices
Message-ID: <20200920161532.GP3853@desktop>
References: <20200917141353.28566-1-johannes.thumshirn@wdc.com>
 <f4606506-78a1-4771-96cd-6bc28e6a7074@oracle.com>
 <SN4PR0401MB35987D9F6868271DAD0A05009B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR0401MB35987D9F6868271DAD0A05009B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 18, 2020 at 07:06:42AM +0000, Johannes Thumshirn wrote:
> On 18/09/2020 02:15, Anand Jain wrote:
> > The fix is not too far. It got stuck whether to use EUCLEAN or not.
> > Its better to fix the fix rather than killing the messenger in this case.
> 
> OK how about removing the test from the auto group then until the fix is merged?
> It's a constant failure and hiding real regressions. And having to maintain an
> expunge list doesn't scale either.
> 
> Thoughts?

Yeah, please remove it from the auto group then.

Thanks,
Eryu
> 
