From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: no space left on device
Date: Fri, 30 Jul 2010 05:31:06 +0000 (UTC)
Message-ID: <i2to2q$b3m$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

kerner 2.6.35-rc6

btrfs filesystem df /home 
Data: total=1.68TB, used=987.62GB
Metadata: total=56.01GB, used=48.16GB
System: total=12.00MB, used=200.00KB

touch: cannot touch `/home/x': No space left on device

Any ideas what I should do?

Thank you

Lubos

