Return-Path: <SRS0=V0ug=RN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819FBC43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 21:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 466DD206BA
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Mar 2019 21:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbfCJVuo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Mar 2019 17:50:44 -0400
Received: from endor150-229.endor.pl ([91.194.229.150]:56203 "EHLO
        naboo.endor.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726796AbfCJVun (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Mar 2019 17:50:43 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Mar 2019 17:50:42 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by naboo.endor.pl (Postfix) with ESMTP id CC8081A1054
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 22:44:55 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at 
Received: from naboo.endor.pl ([91.194.229.149])
        by localhost (naboo.endor.pl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8c-8aNoml26n for <linux-btrfs@vger.kernel.org>;
        Sun, 10 Mar 2019 22:44:54 +0100 (CET)
Received: from orion.dubielvitrum.pl (91-231-23-50.studiowik.net.pl [91.231.23.50])
        (Authenticated sender: postmaster@dubielvitrum.pl)
        by naboo.endor.pl (Postfix) with ESMTPSA id 231E11A0FED
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2019 22:44:54 +0100 (CET)
Received: from [83.4.120.99] (helo=[192.168.1.16])
        by orion.dubielvitrum.pl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <leszek.dubiel@dubielvitrum.pl>)
        id 1h36FZ-0007FR-1N
        for linux-btrfs@vger.kernel.org; Sun, 10 Mar 2019 22:44:53 +0100
To:     linux-btrfs@vger.kernel.org
From:   Leszek Dubiel <leszek.dubiel@dubielvitrum.pl>
Subject: btrfs error: cmds-check.c:4869: add_data_backref: Assertion `!back`
 failed. no space left on device
Message-ID: <4f9e08e3-09af-cbe6-8b06-8e622559d706@dubielvitrum.pl>
Date:   Sun, 10 Mar 2019 22:44:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl-PL
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Hello!

I have a problem with btrfs device.
Shows 355Gb free space.
Done scrub on that.

It shows that there is no space left on device.
Doing simple operations (mkdir, touch, find) are extremely slow.
Checking btrfsck show add_data_backref error (see below).


Do you think I could do :  btrfs check —repair ?


root@gamma:~# btrfsck -p /dev/sda1
Checking filesystem on /dev/sda1
UUID: 666a7089-d716-44ff-8081-56b969b58eff
cmds-check.c:4869: add_data_backref: Assertion `!back` failed.



root@gamma:~# df -h /dev/sda1
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       1.9T  1.5T  355G  81% /tmp/rescue



root@gamma:~# btrfs --version
btrfs-progs v4.7.3







