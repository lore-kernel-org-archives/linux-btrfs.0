Return-Path: <SRS0=Gb2+=PB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3692C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 11:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1B3A2173C
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Dec 2018 11:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=petezilla.co.uk header.i=@petezilla.co.uk header.b="K/7mleso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbeLXLgU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:36:20 -0500
Received: from phi.wiserhosting.co.uk ([77.245.66.218]:41650 "EHLO
        phi.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbeLXLgU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Dec 2018 06:36:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=petezilla.co.uk; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UHo6naQBD+0U837dqq4ax6h/62x3uRcB78mqCdXI4rQ=; b=K/7mlesomKDCcXw2MOHO5jh2Qq
        jII/q3YGDOhCnMwvVe6WAmPSfM0TlpBJkRvHYL0qrMAUaKRGg3BM7/FoEHFV+QhY8yYraeLdM24U5
        w4Cc/LJSVyBGZMZSkZxG34fo6at3MNBHNR6+aVd8Kl4rhtI2ZjwDMRT8f3vRL2/ofsuNx8I86QXAB
        cBFm0RuMBtbIBU8PdS18A0xGakmLkQeXkxKiiPXAsaNG+H2QSxvS/4q1NPskY0xWfXQIExkRCC4Au
        eqnmj2ZjnLkucaRWQ9t7gVy5FoaBvlwJKixeM/sNpr4wuredi38fDTl3cqglEeHZJoF1NgkFEbph6
        0Q9uCAyg==;
Received: from cpc75874-ando7-2-0-cust841.15-1.cable.virginm.net ([86.12.75.74]:56078 helo=[172.16.100.1])
        by phi.wiserhosting.co.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <pete@petezilla.co.uk>)
        id 1gbOWu-007jZ7-Th; Mon, 24 Dec 2018 11:36:18 +0000
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
 <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
 <3b4d0ed3-4151-50b9-b1da-6be240bb58b3@petezilla.co.uk>
 <CAJCQCtRv2NOabzMB0A9A7hoZcu_-6Fy2+umc8+qYcWnv=wn7bQ@mail.gmail.com>
 <2dfe1853-07bc-2db4-9797-5409ff74114d@gmx.com>
From:   Peter Chant <pete@petezilla.co.uk>
Message-ID: <0847f627-d918-3b63-2074-5a8313b163ab@petezilla.co.uk>
Date:   Mon, 24 Dec 2018 11:36:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2dfe1853-07bc-2db4-9797-5409ff74114d@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-0.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - phi.wiserhosting.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - petezilla.co.uk
X-Get-Message-Sender-Via: phi.wiserhosting.co.uk: authenticated_id: pete+petezilla.co.uk/only user confirmed/virtual account not confirmed
X-Authenticated-Sender: phi.wiserhosting.co.uk: pete@petezilla.co.uk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/24/18 2:00 AM, Qu Wenruo wrote:

> I'd recommend to use "btrfs check -r 1113911951360" to verify if it's
> only superblock generation corrupted.

(cancelled  "btrfs-image -ss -c9 -t4 -w /dev/sdd2
/mnt/backup/btrfs_issue_dec_2018/btrfs_root_image_error_with_w_20181224.img"

as it said it was generating garbage).

OK, running the command:

bash-4.3# btrfs check -r 1113911951360 /dev/sdd2
Opening filesystem to check...
parent transid verify failed on 1113911951360 wanted 7937947 found 7937937
parent transid verify failed on 1113911951360 wanted 7937947 found 7937937
Ignoring transid failure
parent transid verify failed on 1113906003968 wanted 7937933 found 7937942
parent transid verify failed on 1113906003968 wanted 7937933 found 7937942
Ignoring transid failure
ERROR: cannot open file system
bash-4.3#


Not a dev so don't know what that means, but I'm assuming it is not good.


Pete




