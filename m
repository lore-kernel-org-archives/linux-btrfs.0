Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:50829 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbdKALE6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 07:04:58 -0400
Received: by mail-wm0-f43.google.com with SMTP id s66so3998154wmf.5
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 04:04:57 -0700 (PDT)
Received: from debox (bzq-109-64-142-30.red.bezeqint.net. [109.64.142.30])
        by smtp.gmail.com with ESMTPSA id v15sm770509wmf.25.2017.11.01.04.04.55
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Nov 2017 04:04:56 -0700 (PDT)
Message-ID: <1509534294.1662.91.camel@gmail.com>
Subject: Reasonable amount of snapshots
From: ST <smntov@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Wed, 01 Nov 2017 13:04:54 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I read in different places that one should keep amount of snapshots low
- around 15-20. My question - is this limitation on total number of
snapshots on the system or only on related (parent<->child) chain of
snapshots?
What I want to do is the following: create (and then rotate) last 7
daily snapshots (and maybe 4 weekly) for each user in his /home dir. For
around 100 users. So if limitation is only on related snapshots then I'm
OK since only each 7 (or maybe 7+4) of them are related which is well
under the 15-20 limit. However in total there could be 700 snapshots. So
what is true?

Thank you!

