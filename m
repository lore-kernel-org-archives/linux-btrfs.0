Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37419C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D614208A3
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wpkg.org header.i=@wpkg.org header.b="lbky5AQT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D614208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wpkg.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbeLDFoN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 00:44:13 -0500
Received: from mail.virtall.com ([46.4.129.203]:54290 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbeLDFoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 00:44:12 -0500
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2018 00:44:11 EST
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 30B7337B30B4
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 05:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wpkg.org; s=default;
        t=1543901823; bh=otDLeMaMsWHly/CcBid/e/NOu/tfncW9LgXiez4v0oY=;
        h=Date:From:To:Subject;
        b=lbky5AQTmGuZQrShjT9oKjgnx6gnIy6++hUT4ffY2VVhzIWwPgPkVDaN3NkM2RKa1
         2vJhVnp2HFRV+c9Uqkt9uqPwkHXGr1QKokUTvt37vqSnFN99PACrsr1T9DDQtmH9s4
         xAB6+KGB48XvoN42nOZdH9X+lZcqf1uoLluZegtYHmWVB26XjQHd8pnGoTv+B/O007
         6r77N8VegaEa0PJDQ+GSVguxPh/l2CMEYVzm9Fn4IUCd62ZXOeHP73moIclgmbQkRb
         zBAeNf/Wjsu416ai6aa5+WEq6dXFVpwlzxjWtnPws/xOqQa6LFbcrChYF41bNqPp0R
         d3TEBQUF6CqpA==
X-Fuglu-Suspect: 3b0a69983dca42848a27d56cf22d2445
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 05:37:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 Dec 2018 14:37:02 +0900
From:   Tomasz Chmielewski <mangoo@wpkg.org>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: experiences running btrfs on external USB disks?
Message-ID: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
X-Sender: mangoo@wpkg.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'm trying to use btrfs on an external USB drive, without much success.

When the drive is connected for 2-3+ days, the filesystem gets remounted 
readonly, with BTRFS saying "IO failure":

[77760.444607] BTRFS error (device sdb1): bad tree block start, want 
378372096 have 0
[77760.550933] BTRFS error (device sdb1): bad tree block start, want 
378372096 have 0
[77760.550972] BTRFS: error (device sdb1) in __btrfs_free_extent:6804: 
errno=-5 IO failure
[77760.550979] BTRFS info (device sdb1): forced readonly
[77760.551003] BTRFS: error (device sdb1) in 
btrfs_run_delayed_refs:2935: errno=-5 IO failure
[77760.553223] BTRFS error (device sdb1): pending csums is 4096


Note that there are no other kernel messages (i.e. that would indicate a 
problem with disk, cable disconnection etc.).

The load on the drive itself can be quite heavy at times (i.e. 100% IO 
for 1-2 h and more) - can it contribute to the problem (i.e. btrfs 
thinks there is some timeout somewhere)?

Running 4.19.6 right now, but was experiencing the issue also with 4.18 
kernels.



# btrfs device stats /data
[/dev/sda1].write_io_errs    0
[/dev/sda1].read_io_errs     0
[/dev/sda1].flush_io_errs    0
[/dev/sda1].corruption_errs  0
[/dev/sda1].generation_errs  0



Tomasz Chmielewski
