Return-Path: <SRS0=Mp4+=NN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB55C32789
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30D72081B
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Nov 2018 14:10:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E30D72081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbeKBXRY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 19:17:24 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:60964 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbeKBXRY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 19:17:24 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 417495FD7B;
        Fri,  2 Nov 2018 14:10:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id y0tMDy5HlKsK; Fri,  2 Nov 2018 14:10:05 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-88-3.dynamic.mnet-online.de [82.135.88.3])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Fri,  2 Nov 2018 14:10:05 +0000 (UTC)
Message-ID: <412fc97cf7979251b96c101c87e4ff171049a6dc.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Su Yue <Damenly_Su@gmx.com>
Date:   Fri, 02 Nov 2018 15:10:05 +0100
In-Reply-To: <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
         <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
         <04ccd53107bb11e08baaa8c1ec55b11b00133d3b.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey Su.

Anything further I need to do in this matter or can I consider it
"solved" and you won't need further testing by my side, but just PR the
patches of that branch? :-)

Thanks,
Chris.

On Sat, 2018-10-27 at 14:15 +0200, Christoph Anton Mitterer wrote:
> Hey.
> 
> 
> Without the last patches on 4.17:
> 
> checking extents
> checking free space cache
> checking fs roots
> ERROR: errors found in fs roots
> Checking filesystem on /dev/mapper/system
> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
> found 619543498752 bytes used, error(s) found
> total csum bytes: 602382204
> total tree bytes: 2534309888
> total fs tree bytes: 1652097024
> total extent tree bytes: 160432128
> btree space waste bytes: 459291608
> file data blocks allocated: 7334036647936
>  referenced 730839187456
> 
> 
> With the last patches, on 4.17:
> 
> checking extents
> checking free space cache
> checking fs roots
> checking only csum items (without verifying data)
> checking root refs
> Checking filesystem on /dev/mapper/system
> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
> found 619543498752 bytes used, no error found
> total csum bytes: 602382204
> total tree bytes: 2534309888
> total fs tree bytes: 1652097024
> total extent tree bytes: 160432128
> btree space waste bytes: 459291608
> file data blocks allocated: 7334036647936
>  referenced 730839187456
> 
> 
> Cheers,
> Chris.
> 

