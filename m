From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: no space left on device
Date: Mon, 7 Feb 2011 21:21:51 +0000
Message-ID: <AANLkTi=KNt1JVq82FR-u9CGA1TcXiknz0c3bbD186U43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey all,

I run into no space left on device on a virtualbox

After installing Debian 6 on a virtual machine
I tried installing the KDE desktop

The system HDD is 8Gb
Both root (/) and /home are btrfs
over LVM.

While installing the packages I run into:

no space left, need 4096, 4096 dealloc bytes, 1776283648 bytes_used, 0
bytes_reserved,
0 bytes_pinned, 0 bytes_readonly, 0 may use 1776287744 total

df shows only 74% used space on /

kernel used: stock debian 6 2.6.32-5-686

At the moment I cannot access it with normal boot, only recovery mode.

I can provide whatever info you would like as long as you think of a
way to load the normal system and not the recovery mode.




-- 
Caution: breathing may be hazardous to your health.
