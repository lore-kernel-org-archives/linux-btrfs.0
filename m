From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: btrfsctl -A not returning useful information
Date: Fri, 18 Jul 2008 20:28:40 +0300
Message-ID: <3da3b5b40807181028p42e1a15di938dc62cccbc766c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[root@btrfs progs-unstable]# btrfsctl -A /dev/sdb
ioctl returns 0
[root@btrfs progs-unstable]# btrfsctl -A /dev/sdc
ioctl returns 0


/dev/sdb has a btrfs, while /dev/sdc is blank. What's that output
supposed to mean ? Is it a bug ?
