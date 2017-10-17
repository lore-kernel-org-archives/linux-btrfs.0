Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:16831 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759656AbdJQR67 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 13:58:59 -0400
Received: from mordor.fritz.box (x5f749cb2.dyn.telefonica.de [95.116.156.178])
        by smtp.strato.de (RZmta 42.6 DYNA|AUTH)
        with ESMTPSA id i0a928t9HHwtHhO
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Tue, 17 Oct 2017 19:58:55 +0200 (CEST)
Message-ID: <1508263135.2887.1.camel@cloud.haefemeier.eu>
Subject: Best strategie to remove devices from pool
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Tue, 17 Oct 2017 19:58:55 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I want to remove two devices from a BTRFS RAID 1 pool. It should be
enough free space to do it, but what is the best strategie. Remove both
device in one call 'btrfs dev rem /dev/sda1 /dev/sdb1' (for example) or
should it be better in two separate calls? What is faster? Are there
other constraints to think about?
Bye
	Frank
