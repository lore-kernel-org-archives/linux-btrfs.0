Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA032C433EF
	for <linux-btrfs@archiver.kernel.org>; Sun, 29 May 2022 11:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiE2Lez convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 29 May 2022 07:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiE2Ley (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 May 2022 07:34:54 -0400
Received: from pio-pvt-msa2.bahnhof.se (pio-pvt-msa2.bahnhof.se [79.136.2.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BB19A9A1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2022 04:34:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTP id 2EFAB3F779
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2022 13:34:49 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at bahnhof.se
Received: from pio-pvt-msa2.bahnhof.se ([127.0.0.1])
        by localhost (pio-pvt-msa2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FKf5ekZkZIV6 for <linux-btrfs@vger.kernel.org>;
        Sun, 29 May 2022 13:34:48 +0200 (CEST)
Received: by pio-pvt-msa2.bahnhof.se (Postfix) with ESMTPA id 7DD083F772
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2022 13:34:48 +0200 (CEST)
Received: from [192.168.0.113] (port=49226)
        by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <forza@tnonline.net>)
        id 1nvHC3-000JFs-Sl
        for linux-btrfs@vger.kernel.org; Sun, 29 May 2022 13:34:47 +0200
Date:   Sun, 29 May 2022 13:34:51 +0200 (GMT+02:00)
From:   Forza <forza@tnonline.net>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <c31c664.705b352f.1810f98f3ee@tnonline.net>
Subject: What mechanisms protect against split brain?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Mailer: R2Mail2
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Recently there have been some discussions, both here on the mailing list and on #btrfs IRC, about the consequences of mounting one RAID1 mirror as degraded and then later re-introduce the missing device. But also on having degraded mount option in fstab and kernel command line.

So I wonder if Btrfs has some protective mechanisms against data loss/corruption if a drive is missing for a bit but later re-introduced. There is also the case of split brain where each mirror might be independently updated and then recombined.

Is there an official recommendation to have with regards to degraded mounts from kernel command line? I understand the use case as it allows the system to boot even if a device goes missing or dead after a reboot.

Thanks,
Forza
