Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785CCC67839
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 05:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37324206BA
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 05:16:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37324206BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbeLNFQ5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 00:16:57 -0500
Received: from [195.159.176.226] ([195.159.176.226]:39476 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeLNFQ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 00:16:57 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gXfoB-0007j0-Iv
        for linux-btrfs@vger.kernel.org; Fri, 14 Dec 2018 06:14:43 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: SATA/SAS mixed pool
Date:   Fri, 14 Dec 2018 05:14:37 +0000 (UTC)
Message-ID: <pan$a6302$5fc2e266$9dae146a$696f7df5@cox.net>
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
        <20181213072905.ac352nclowixfhpt@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; ba6322f87)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Adam Borowski posted on Thu, 13 Dec 2018 08:29:05 +0100 as excerpted:

> On Wed, Dec 12, 2018 at 09:31:02PM -0600, Nathan Dehnel wrote:
>> Is it possible/safe to replace a SATA drive in a btrfs RAID10 pool with
>> an SAS drive?
> 
> For btrfs, a block device is a block device, it's not "racist".
> You can freely mix and/or replace.  If you want to, say, extend a SD
> card with NBD to remote spinning rust, it works well -- tested :p

FWIW (mostly for other readers not so much this particular case) the 
known exception/caveat to that is USB block devices, which do tend to 
have problems, tho some hardware is fine.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

