Return-Path: <SRS0=Qnmz=NA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363EFC67863
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Oct 2018 19:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3DA520869
	for <linux-btrfs@archiver.kernel.org>; Sat, 20 Oct 2018 19:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3DA520869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sysnux.pf
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbeJUDMA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 20 Oct 2018 23:12:00 -0400
Received: from [195.159.176.226] ([195.159.176.226]:55814 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbeJUDMA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Oct 2018 23:12:00 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gDwS6-0001pE-KS
        for linux-btrfs@vger.kernel.org; Sat, 20 Oct 2018 20:58:22 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Untar on empty partition returns ENOSPACE
Date:   Sat, 20 Oct 2018 09:00:25 -1000
Message-ID: <pqfts8$6a6$1@blaine.gmane.org>
References: <pq90ft$hso$1@blaine.gmane.org>
 <CAPmG0jbaKvK-xvkQ+sBVsCGiVdxDJA-o_rFDCxH1CJN-dW6-iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
In-Reply-To: <CAPmG0jbaKvK-xvkQ+sBVsCGiVdxDJA-o_rFDCxH1CJN-dW6-iA@mail.gmail.com>
Content-Language: fr-FR
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 17/10/2018 à 20:43, Henk Slager a écrit :
> On Thu, Oct 18, 2018 at 6:04 AM Jean-Denis Girard <jd.girard@sysnux.pf> wrote:
> This looks like to have a similar root cause as this:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg81536.html

Yes, seems similar.

> For 50 clones, you could prepare 1 master (sparse) image and change
> the UUID with btrfstune for every SD-card you have after written the
> image (optionally sparse write with e.g. dd_rescue).

Thanks for suggestion, I may try this another time, but I can live with
my workaround.

> But it looks like some change is needed in the kernel code, although I
> have no clue at the moment where exactly.

Right, this is why I send this message, try to motivate a dev to look at
this issue ;)


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


