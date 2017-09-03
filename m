Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:34692 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753061AbdICRfQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 13:35:16 -0400
Received: from mordor.fritz.box (xd93289c4.dyn.telefonica.de [217.50.137.196])
        by smtp.strato.de (RZmta 41.4 DYNA|AUTH)
        with ESMTPSA id g0434bt83HW1DHp
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Sun, 3 Sep 2017 19:32:01 +0200 (CEST)
Message-ID: <1504459921.8809.3.camel@cloud.haefemeier.eu>
Subject: How to disable/revoke 'compression'?
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: linux-btrfs@vger.kernel.org
Date: Sun, 03 Sep 2017 19:32:01 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I used the mount option 'compression' on some mounted sub volumes. How
can I revoke the compression? Means to delete the option and get all
data uncompressed on this volume.
Is it enough to remount the sub volume without this option? Or is it
necessary to do some addional step (balancing?) to get all stored data
uncompressed. Beside of it, is it possible to find out what the real
and compressed size of a file, for example or the ratio?
Bye
   Frank
