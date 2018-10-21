Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=3.0 tests=FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43681ECDE44
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 19:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA95F20838
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 19:06:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA95F20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sysnux.pf
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbeJVDVg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 23:21:36 -0400
Received: from [195.159.176.226] ([195.159.176.226]:60637 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbeJVDVf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 23:21:35 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gEJ1C-0005So-0k
        for linux-btrfs@vger.kernel.org; Sun, 21 Oct 2018 21:04:06 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Jean-Denis Girard <jd.girard@sysnux.pf>
Subject: Re: Untar on empty partition returns ENOSPACE
Date:   Sun, 21 Oct 2018 09:06:10 -1000
Message-ID: <pqiiiv$7fl$1@blaine.gmane.org>
References: <pq90ft$hso$1@blaine.gmane.org>
 <CAPmG0jbaKvK-xvkQ+sBVsCGiVdxDJA-o_rFDCxH1CJN-dW6-iA@mail.gmail.com>
 <pqfts8$6a6$1@blaine.gmane.org>
 <CAN4oSBfHiez22uNVsST8Cnzyiiic8Q+9yxw=2LJs4wu_ADVxQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
In-Reply-To: <CAN4oSBfHiez22uNVsST8Cnzyiiic8Q+9yxw=2LJs4wu_ADVxQw@mail.gmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 20/10/2018 à 10:39, Cerem Cem ASLAN a écrit :
> You don't even need dd_rescue or something for RaspberryPi creation,
> you may use https://github.com/aktos-io/dcs-tools#cloning-a-target-into-a-new-target

That's interesting, but a bit overkill for my needs : I'll stay with my
simple script for this project.


Thanks,
-- 
Jean-Denis Girard

SysNux                   Systèmes   Linux   en   Polynésie  française
https://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.797.527


