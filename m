From: Magicloud Magiclouds <magicloud.magiclouds@gmail.com>
Subject: Interesting problem with write data.
Date: Thu, 18 Nov 2010 14:19:40 +0800
Message-ID: <AANLkTinTtvN6T6Ykjs6-UzHi3XYgimM92Pa5wSPrF3sZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
  Recently, I made a btrfs to use. And I met slowness problem. Trying
to diag it. I found this:
1. dd if=/dev/zero of=test count=1024 bs=1MB
This is fast, at about 25MB/s, and reasonable iowait.
2. dd if=/dev/zero of=test count=1 bs=1GB
This is pretty slow, at about 1.5MB/s, and 90%+ iowait, constantly.
  May I know why it works like this? Thanks.
