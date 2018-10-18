Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1B3C5ACCC
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 14:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC85721476
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 14:48:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC85721476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=scientia.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbeJRWtj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 18:49:39 -0400
Received: from mailgw-02.dd24.net ([193.46.215.43]:34889 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbeJRWtj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 18:49:39 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2018 18:49:38 EDT
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 61F3B5FD41;
        Thu, 18 Oct 2018 14:41:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id HClcknW6z-34; Thu, 18 Oct 2018 14:41:53 +0000 (UTC)
Received: from gar-nb-etp23.garching.physik.uni-muenchen.de (unknown [141.84.41.132])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Thu, 18 Oct 2018 14:41:53 +0000 (UTC)
Message-ID: <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Su Yue <suy.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Su Yue <Damenly_Su@gmx.com>
Date:   Thu, 18 Oct 2018 16:41:52 +0200
In-Reply-To: <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
         <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
         <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
         <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey.

So I'm back from a longer vacation and had now the time to try out your
patches from below:

On Wed, 2018-09-05 at 15:04 +0800, Su Yue wrote:
> I found the errors should blame to something about inode_extref check
> in lowmem mode.
> I have writeen three patches to detect and report errors about
> inode_extref. For your convenience, it's based on v4.17:
> https://github.com/Damenly/btrfs-progs/tree/ext_ref_v4.17
> 
> This repo should report more errors. Because one of those is just
> Whac-A-Mole, I will make it better and send them later to ML.


This is the output it gives:
checking extents
checking free space cache
checking fs roots
checking only csum items (without verifying data)
checking root refs
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
found 617228185600 bytes used, no error found
total csum bytes: 600139124
total tree bytes: 2516172800
total fs tree bytes: 1639890944
total extent tree bytes: 156532736
btree space waste bytes: 455772589
file data blocks allocated: 7431727771648
 referenced 732073979904

(just a bit strange that the UUID line is not in the beginngin)... but
other than that, no longer an error message as it seems)


Cheers,
Chris.

