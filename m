From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: checkpoints to often
Date: Thu, 31 Mar 2011 16:30:51 +0200
Message-ID: <AANLkTinr4G=F6msPF=oVDrCU1uz2b-q8Do4f5htzP=ep@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There should be a way to make automatic checkpoints less frequent. On
the busy ssd I have about 7 cp every second. If it were for example
once every 5 minutes then one could set garbage removal every few
days.
Also garbage removal should have option to clean only if like 90% of
drive is used. there is no need to remove cp-s when there is still
many GB of space left.
