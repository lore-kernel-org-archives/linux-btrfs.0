Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ED7C43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 16:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D62620666
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 16:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D62620666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=giis.co.in
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbeJBWud (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 18:50:33 -0400
Received: from p3nlsmtpcp01-04.prod.phx3.secureserver.net ([184.168.200.145]:39856
        "EHLO p3nlsmtpcp01-04.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbeJBWud (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Oct 2018 18:50:33 -0400
Received: from p3plcpnl0639.prod.phx3.secureserver.net ([50.62.176.166])
        by : HOSTING RELAY : with ESMTP
        id 7NAsg5f7edPt87NAsgBCBD; Tue, 02 Oct 2018 09:05:26 -0700
Received: from [223.182.205.161] (port=3855 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1g7NAr-00Bwk9-Bf; Tue, 02 Oct 2018 09:05:25 -0700
Date:   Tue, 2 Oct 2018 21:35:15 +0530
From:   "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To:     Adam Borowski <kilobyte@angband.pl>, ce3g8jdj@umail.furryterror.org
Cc:     Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: dduper - Offline btrfs deduplication tool
Message-ID: <20181002160515.GA28265@giis.co.in>
References: <20180824043139.GA8263@giis.co.in>
 <CAGqmi74eMiHe7HK_oueaj0JZmy1Kp1NoOCrU0yheEE8MjngLKA@mail.gmail.com>
 <20180907035728.GA7717@giis.co.in>
 <20180907143107.gsixosfbswlqcbly@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180907143107.gsixosfbswlqcbly@angband.pl>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - p3plcpnl0639.prod.phx3.secureserver.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - giis.co.in
X-Get-Message-Sender-Via: p3plcpnl0639.prod.phx3.secureserver.net: authenticated_id: lakshmipathi.g@giis.co.in
X-Authenticated-Sender: p3plcpnl0639.prod.phx3.secureserver.net: lakshmipathi.g@giis.co.in
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-CMAE-Envelope: MS4wfJUFXE8XXJuMjBtz4wgAj8OPhgVn6rkupPB9/yQntvpMFD2VGt0sD/qwZVt0SKROyeVbbZFykH4gpZSUHfxS05Vvle7BqdAYWxLY2YHZ/fUIinAXzD2N
 c7T12BQI035EWFYH4SvDk20yhsDsFNqLf1wcRTaIb2/2/PJtKbjm3pBchAAw2T/g4yf+ZOFdQ0l0J8o1amxgxMzAN+VkLFuQsnAZk5ZGZegO7/KTKozIKURz
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Apologies for pretty delay in response.  Thanks for the suggestions 
and comments.

>On the other hand, full bit-to-bit comparison is faster and 100% safe

>With fideduperange the risk is more than minimized--it's completely
>eliminated.

Okay got it, will use fideduperange() as default option for the tool and
keep ficlonerange() as secondary option. Will make the code changes and
send a new patch soon. thanks! 

Cheers.
Lakshmipathi.G 
