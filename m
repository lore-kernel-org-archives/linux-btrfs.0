Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A55C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 19:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0CD120827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 19:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="OAGiRxrH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0CD120827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbeKJE5r (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 23:57:47 -0500
Received: from mail.virtall.com ([46.4.129.203]:50438 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbeKJE5r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 23:57:47 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 04ECE3553E4F;
        Fri,  9 Nov 2018 19:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1541790949;
        bh=CHU/wviaUCVR1qL5DjnSncajtkk9cqzXFP02aObB/Yc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=OAGiRxrH9QUfKDaddN0xAeaDn13QUJ0iqiYIlWxqpI86LEkVp+pXsvkvByoBgqUoF
         LOsAm9imakm+YiBq1/bHlNNBG66F/yrf0qi++E+gf6OJa9kt10r2h8iZ9VA2geDCWo
         21aD5p5giZGYpLPU4AWPwutJA8EE2LjcJ7c3Y0ZCKSWjL4nNKCCAM10JiEoF0x+8EB
         vuPrZRYIoUmJYamaem2U1Eh7iUx+h6zAZqE0oEL0Qpfw2375lyVM9Sa3d2vk3IzqKB
         8mfFoTrpTPbPEuwHp2coVFFMvmg/BANnrP2cJLGJXLtKeCdD1ob22CRmQwkc8fzL2u
         /BWKRFWrA8PDg==
X-Fuglu-Suspect: d38099705b1448f79d25df718550c92c
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Fri,  9 Nov 2018 19:15:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 10 Nov 2018 04:15:47 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount btrfs after upgrading from 4.16.1 to 4.19.1
In-Reply-To: <20181109232052.19233269@natsu>
References: <2442f641ad54ce98361cf40b70e4d18d@virtall.com>
 <20181109232052.19233269@natsu>
Message-ID: <62812fe46b56258a47dc9df38c76e7f0@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-11-10 03:20, Roman Mamedov wrote:
> On Sat, 10 Nov 2018 03:08:01 +0900
> Tomasz Chmielewski <tch@virtall.com> wrote:
> 
>> After upgrading from kernel 4.16.1 to 4.19.1 and a clean restart, the 
>> fs
>> no longer mounts:
> 
> Did you try rebooting back to 4.16.1 to see if it still mounts there?

Yes, just did.

Interestingly, it does mount when I boot back to 4.16.1 - side note - it 
takes some 50 (!) minutes and ~8 GB of reads (according to iostat -m) to 
mount... device size is 16 TB, on HDD.



Tomasz Chmielewski
https://lxadm.com
