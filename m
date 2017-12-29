Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout1.hostsharing.net ([83.223.95.204]:36297 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdL2SRk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 13:17:40 -0500
Received: from h06.hostsharing.net (h06.hostsharing.net [83.223.95.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id ABDF41034B8F4
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 19:17:39 +0100 (CET)
Received: from mail.home.lxtec.de (HSI-KBW-5-56-176-248.hsi16.kabel-badenwuerttemberg.de [5.56.176.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h06.hostsharing.net (Postfix) with ESMTPSA id 7B895629DB07
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 19:17:39 +0100 (CET)
Received: from localhost ([127.0.0.1])
        by mail.home.lxtec.de with esmtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUzDu-0005QW-O0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 19:17:38 +0100
Received: from mail.home.lxtec.de ([127.0.0.1])
        by localhost (baumbart.home.lxtec.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1H4KzVOISX6G for <linux-btrfs@vger.kernel.org>;
        Fri, 29 Dec 2017 19:17:38 +0100 (CET)
Received: from galadriel.home.lxtec.de ([192.168.200.207])
        by mail.home.lxtec.de with smtp (Exim 4.90_RC4 4 (LXTEC))
        id 1eUzDu-0005QQ-FK
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 19:17:38 +0100
Date: Fri, 29 Dec 2017 19:17:38 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
Message-ID: <20171229181738.gdsdgcu2yicritu4@galadriel.home.lxtec.de>
References: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
 <0a34347a-ae74-dbab-98bd-08d822347c9b@applied-asynchrony.com>
 <0b81a3bf-958a-7c82-eea0-a04c916703b1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0b81a3bf-958a-7c82-eea0-a04c916703b1@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks,

* Nikolay Borisov <nborisov@suse.com> [2017-12-29 19:23 +0200]:

[...]

> So OP:
> 
> Update your btrfs-progs package to latest 4.14 and run btrfs rescue :
> 
> btrfs rescue fix-device-size <device>

I installed btrfs-progs 4.14. Can't run 
'btrfs rescue fix-device-size /dev/sd(a|b)3'. The devices are mounted
including my root... 

How to accomplish?

Thanks in advance

Elimar
-- 
  Excellent day for drinking heavily.
  Spike the office water cooler;-)
