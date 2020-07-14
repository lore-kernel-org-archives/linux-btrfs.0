Return-Path: <SRS0=9Op2=AZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA267C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jul 2020 09:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F3B9217A0
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jul 2020 09:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lechevalier.se header.i=@lechevalier.se header.b="dCnbdqdD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgGNJ4h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 05:56:37 -0400
Received: from mailrelay2-3.pub.mailoutpod1-cph3.one.com ([46.30.212.11]:31874
        "EHLO mailrelay2-3.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgGNJ4h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Jul 2020 05:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lechevalier.se; s=20191106;
        h=content-transfer-encoding:content-type:mime-version:date:message-id:subject:
         from:to:from;
        bh=zDbJeV/SfFUIjC9DHiVjPUl3HU1ZoKgP6BdzPjamN54=;
        b=dCnbdqdDViQpJpArkD0xYH0mJ+b1QMPLAQB93gAzIzDAEOSCDfturhLXMQp9ZrStDdF3Y4ztJGqyw
         qgTHBSWdHyqIFz2i9iJdeBh8PePQrf507sOR+OpESI3PvgQdtugCRb1wjB4TElNWzw/5odapR3sajN
         /ACA3NYT7LCr0F+xn9u03YHrpRWrfO597YZfo3Bx0ZSf5owyWIBuaonKZp4EbPjDPXOVWmWLH9pINb
         9OkuJwOC9WMXdIiwKsezGMVtVIDvNqaHO3sdJnTN6au7VxWJrS335Vt3QGEVRPQZ+RrccymZveLTgJ
         T0dFk8E5T2gVWrHLaNTxA9qDsdjqhRA==
X-HalOne-Cookie: 034e1b179038a5df23777fbe14e86083b93629f4
X-HalOne-ID: 4cc7d0f5-c5b8-11ea-8888-d0431ea8a290
Received: from [10.0.88.22] (unknown [98.128.186.116])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 4cc7d0f5-c5b8-11ea-8888-d0431ea8a290;
        Tue, 14 Jul 2020 09:56:34 +0000 (UTC)
To:     linux-btrfs@vger.kernel.org
From:   A L <mail@lechevalier.se>
Subject: df diskspace calculation
Message-ID: <ddb33661-2d71-5046-7b6a-4a601dc2df44@lechevalier.se>
Date:   Tue, 14 Jul 2020 11:56:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I am wondering if the calculations for disk space can be improved?

If we look at my current root filesystem, the available space is 
reported as 163GiB, but I think it would be more reasonable to report 
this as 158GiB. This is because we have to deduct any metadata 
allocation what would happen when filling up the filesystem.

df and btrfs fi usage numbers:
==============
# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3       234G   71G  163G  31% /

# btrfs fi us /
Overall:
     Device size:                 233.47GiB
     Device allocated:             75.03GiB
     Device unallocated:          158.44GiB
     Device missing:                  0.00B
     Used:                         70.36GiB
     Free (estimated):            162.55GiB      (min: 162.55GiB)
     Data ratio:                       1.00
     Metadata ratio:                   1.00
     Global reserve:              192.73MiB      (used: 0.00B)
     Multiple profiles:                  no

Data,single: Size:73.00GiB, Used:68.88GiB (94.36%)
    /dev/sda3      73.00GiB

Metadata,single: Size:2.00GiB, Used:1.47GiB (73.63%)
    /dev/sda3       2.00GiB

System,single: Size:32.00MiB, Used:16.00KiB (0.05%)
    /dev/sda3      32.00MiB

Unallocated:
    /dev/sda3     158.44GiB
==============

If we follow the numbers:
* Data / Metadata ratio = 68.88/1.47 = 46.54.
* Estimated metadata usage when full: Unallocated + (73.00-68.88) / 
46.54 + 1,47 = 4.96, round up to 5.00 GiB

So I think that df's "Avail:" and btrfs fi usage's "Free (estimated):" 
should be:
* Estimated available user data space: 158.44 + (73.00-68.88) - 5.00 ~ 
157,56GiB

This calculation is probably harder with multiple devices. But I think 
we can use same principle of estimating based on current allocation 
ratios between data and metadata.



  ~ Anders



