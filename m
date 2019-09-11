Return-Path: <SRS0=wB72=XG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF671ECDE20
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 07:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF0F5222BF
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Sep 2019 07:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfIKHDL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Sep 2019 03:03:11 -0400
Received: from hawking.davidnewall.com ([203.20.69.83]:43194 "EHLO
        hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfIKHDL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Sep 2019 03:03:11 -0400
Received: from [172.30.0.109] (ppp14-2-96-129.adl-apt-pir-bras32.tpg.internode.on.net [::ffff:14.2.96.129])
  (AUTH: PLAIN davidn, SSL: TLSv1/SSLv3,128bits,AES128-SHA)
  by hawking.rebel.net.au with ESMTPSA; Wed, 11 Sep 2019 16:33:09 +0930
  id 0000000000064FBC.5D789C2D.00002192
Subject: Re: Mount/df/PAM login hangs during rsync to btrfs subvolume, or
 maybe doing btrfs subvolume snapshot
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <c00dfaf7-81a4-5e79-6279-b4af53f7f928@davidnewall.com>
 <1a651f17-ba40-2f17-403e-69999e927b2d@suse.com>
From:   David Newall <btrfs@davidnewall.com>
Message-ID: <3523c6f1-4972-8e17-341b-0bcd0410b75b@davidnewall.com>
Date:   Wed, 11 Sep 2019 16:33:09 +0930
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1a651f17-ba40-2f17-403e-69999e927b2d@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-AU
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

> provide your exact kernel version.

I apologise.  I included that in bugzilla but forgot to include it in my 
message to this list.  It's 4.4.0-159.

