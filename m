Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:43250 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757285AbeBPCoQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 21:44:16 -0500
Received: by mail-ot0-f169.google.com with SMTP id q12so1598519otg.10
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 18:44:15 -0800 (PST)
MIME-Version: 1.0
From: Sampson Fung <sampsonfung@gmail.com>
Date: Fri, 16 Feb 2018 10:43:54 +0800
Message-ID: <CACEy+ERPPDqAzZEUtuSTS=QROnfHV-_C5Z4y-EZ303PObX94Qg@mail.gmail.com>
Subject: btrfs send/receive in reverse possible?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have snapshot A on Drive_A.
I send snapshot A to an empty Drive_B.  Then keep Drive_A as backup.
I use Drive_B as active.
I create new snapshot B on Drive_B.

Can I use btrfs send/receive to send incremental differences back to Drive_A?
What is the correct way of doing this?

Regards,
Sampson
