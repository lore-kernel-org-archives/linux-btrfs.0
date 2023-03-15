Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AD7C6FD1D
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Mar 2023 07:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231754AbjCOHiW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Mar 2023 03:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCOHiE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2023 03:38:04 -0400
X-Greylist: delayed 573 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Mar 2023 00:36:02 PDT
Received: from mail.render-wahnsinn.de (unknown [IPv6:2a01:4f8:13b:3d57::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A510D74324
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2023 00:36:02 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9E38D7087A
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2023 08:26:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=render-wahnsinn.de;
        s=dkim; t=1678865186; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language;
        bh=d89u0JHyEfsVFF750vgH02dMGLZYc1X5mlcMQQYPKcg=;
        b=hWeqA/67WZFUrDz25XPfm7NvmGX7AW58y1gWLrFRYgllCiBUN1HiRsMAuasIotiwSaiPD+
        To/vsMNjwxgiTxxQPlPcgHL2Pnu+1nSkl/Ic8CSOIx+EcyiDf3LSpLvChBjGHgwl2M7wkQ
        VpAcNXwtxm4Fvokp8Rl4SU1MjXQ3tmi9hps4CAYPgZWFJ5av29sqC2/+GyAVyYIIwASUvh
        KnmyfrWAWJYHihfuukE1O2JdaRBRHSBD2Vl6Ah/CDLdqHkI19E+lH5fdsbjcOxcm6okVjh
        CjRWHCMXiSReseuiqTEdHAXehfYFQFwsggBi/z1iLuYpiGKoaNRdljp13iSVOQ==
Message-ID: <dd155011-37a5-b597-a3ff-db63176d8fa1@render-wahnsinn.de>
Date:   Wed, 15 Mar 2023 08:26:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     linux-btrfs@vger.kernel.org
Content-Language: en-US
From:   Robert Krig <robert.krig@render-wahnsinn.de>
Subject: Btrfs Raid10 eating all Ram on Mount
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,


I've got a bit of a strange situation here.  I've got a server with 
4x16TB Drives in a RAID10 for data and a Raid1C4 for metadata 
configuration.
I'm currently retiring that server so I've been transferring and 
deleting snapshots from it.

For some reason, this server (Debian with kernel 6.2.1) suddenly starts 
eating all of my ram (64GB). Even if completely idle. I see that there 
is a btrfs-transaction process and a btrfs-cleaner process that are 
running and using quite a bit of cpu.

Basically, even after a fresh reboot. Once I mount the array, the memory 
usage will slowly start to creep up, until it reaches OOM and the system 
freezes.

I'm currently running a read-only check on the system and as far as I 
recall, I've never enabled Quotas on that system.

Does anyone have any idea what's causing this, or how I can fix it?

