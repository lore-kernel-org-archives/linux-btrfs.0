Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:35428 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751490AbdHPGKA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 02:10:00 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: slow btrfs with a single kworker process using 100% CPU
Message-ID: <eab2f725-ab6e-d2ac-30e1-d9c964ce8be8@profihost.ag>
Date: Wed, 16 Aug 2017 08:04:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've one system where a single kworker process is using 100% CPU
sometimes a second process comes up with 100% CPU [btrfs-transacti]. Is
there anything i can do to get the old speed again or find the culprit?

Greets,
Stefan
