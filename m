Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFE5C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 12:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63E59205F4
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 12:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 63E59205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbeJ0U4D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 16:56:03 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:58795 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728029AbeJ0U4C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 16:56:02 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 0856C5FD27;
        Sat, 27 Oct 2018 12:15:14 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id vyN3mw2mak9b; Sat, 27 Oct 2018 12:15:12 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-88-3.dynamic.mnet-online.de [82.135.88.3])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Sat, 27 Oct 2018 12:15:12 +0000 (UTC)
Message-ID: <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Su Yue <Damenly_Su@gmx.com>
Date:   Sat, 27 Oct 2018 14:15:11 +0200
In-Reply-To: <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
         <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey.


Without the last patches on 4.17:

checking extents
checking free space cache
checking fs roots
ERROR: errors found in fs roots
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
found 619543498752 bytes used, error(s) found
total csum bytes: 602382204
total tree bytes: 2534309888
total fs tree bytes: 1652097024
total extent tree bytes: 160432128
btree space waste bytes: 459291608
file data blocks allocated: 7334036647936
 referenced 730839187456


With the last patches, on 4.17:

checking extents
checking free space cache
checking fs roots
checking only csum items (without verifying data)
checking root refs
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
found 619543498752 bytes used, no error found
total csum bytes: 602382204
total tree bytes: 2534309888
total fs tree bytes: 1652097024
total extent tree bytes: 160432128
btree space waste bytes: 459291608
file data blocks allocated: 7334036647936
 referenced 730839187456


Cheers,
Chris.

