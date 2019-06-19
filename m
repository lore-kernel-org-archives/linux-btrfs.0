Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55D9C31E5B
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 16:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C083521783
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 16:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfFSQjV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 12:39:21 -0400
Received: from [195.159.176.226] ([195.159.176.226]:43998 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFSQjV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 12:39:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1hddcF-000t1q-3V
        for linux-btrfs@vger.kernel.org; Wed, 19 Jun 2019 18:39:19 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: "no space left on device" from tar on ppc64le
Date:   Wed, 19 Jun 2019 06:39:09 -1000
Message-ID: <qedoff$6e0d$1@blaine.gmane.org>
References: <405184D6-3E29-4308-B2CA-BF5644A6CED7@storix.com>
 <CAJCQCtQtpHbe=in8V+-iYCxZhsnRfxpcde0SJkBH-1ajc=e72w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
In-Reply-To: <CAJCQCtQtpHbe=in8V+-iYCxZhsnRfxpcde0SJkBH-1ajc=e72w@mail.gmail.com>
Content-Language: fr-FR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Rich,

Le 18/06/2019 à 13:19, Chris Murphy a écrit :
> On Tue, Jun 18, 2019 at 4:23 PM Rich Turner <rturner@storix.com> wrote:
>>
>> tar: ./lib/modules/4.4.73-7-default/kernel/drivers/md/faulty.ko: Cannot open: No space left on device
> 
> If this really is a 4.4.73 based kernel, I expect the report is out of
> scope for this list. There have been 109 subsequent stable releases of
> the 4.4 kernel since. There nearly 3000 commits between 4.4 and 5.1.

I would also recommend using a newer kernel. I'm the one who reported
the problem back in October, and I had to make new SD cards 2 weeks ago.
I used the exact same script on kernel 5.1.x and the problem did not
come up again, ie I was able to untar without the hack to slow down
write speed.

Thanks to Btrfs developpers!


Best regards,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527

