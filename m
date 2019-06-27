Return-Path: <SRS0=F9iR=U2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2D4C48BD7
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Jun 2019 10:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B3DC2083B
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Jun 2019 10:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0KGt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:06:49 -0400
Received: from mail5.windriver.com ([192.103.53.11]:47160 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbfF0KGt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jun 2019 06:06:49 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id x5RA5RWP011488
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Thu, 27 Jun 2019 03:05:47 -0700
Received: from [128.224.162.188] (128.224.162.188) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 27 Jun
 2019 03:05:37 -0700
Subject: Re: Bug Report: Btrfs can't allocate space for delete
To:     Cyril Hrubis <chrubis@suse.cz>
CC:     <linux-btrfs@vger.kernel.org>, <josef@toxicpanda.com>,
        <dsterba@suse.com>
References: <824d3859-3437-1064-d187-97f4737dee98@windriver.com>
 <20190627095149.GB13189@rei.lan>
From:   "Hongzhi, Song" <hongzhi.song@windriver.com>
Message-ID: <03306288-e956-08fd-04e5-5531696ccfe4@windriver.com>
Date:   Thu, 27 Jun 2019 18:05:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190627095149.GB13189@rei.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [128.224.162.188]
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I am very very sorry about that.

Because the my thunderbirds app always sends email with HTML,

which is rejected by linux-btrfs@vger.kernel.org. So I send a few.


I didn't notice you received email again and again.

But now, all is normal.

Sorry about that again.


--Hongzhi


On 6/27/19 5:51 PM, Cyril Hrubis wrote:
> Hi!
> Looks like something is wrong with your email setup, you were sending
> slightly modified versions of this email every few minutes. Please do
> not spam us.
>
