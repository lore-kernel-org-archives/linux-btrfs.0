Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:19314 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdHFOtu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 10:49:50 -0400
Received: from mordor.fritz.box (x5f74b035.dyn.telefonica.de [95.116.176.53])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id L09e7bt76EnnskT
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Sun, 6 Aug 2017 16:49:49 +0200 (CEST)
Message-ID: <1502030988.13428.5.camel@cloud.haefemeier.eu>
Subject: Save to use 'clear_cache' in mount -o remount?
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Sun, 06 Aug 2017 16:49:48 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
is it safe (has it an effect?) to use the 'clear_cache' option in a
'mount -o remount'? I recognize messages in my kernel log regarding
'BTRFS info (device dm-7): The free space cache file (31215079915520)
is invalid. skip it'. I would like to fix it and would do it (in best
case) without rebooting.
Bye
Frank
