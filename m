From: Philip Love <Love_Phil@emc.com>
Subject: Re: btrfs bug while defragmenting
Date: Tue, 9 Mar 2010 12:21:56 -0800
Message-ID: <3AF922DD-01A6-481E-B678-D6BEA6E47D76@emc.com>
References: <D09C8589-EA52-4778-8B29-1B06B27292D0@emc.com> <20100309192516.GQ15485@think>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100309192516.GQ15485@think>
List-ID: <linux-btrfs.vger.kernel.org>

Also the 'file data blocks allocated' in the btrfsck looks wrong.

sentryA:~ # btrfsck /dev/sdc1
found 95418703872 bytes used err is 0
total csum bytes: 92762192
total tree bytes: 430219264
total fs tree bytes: 186494976
btree space waste bytes: 72747390
file data blocks allocated: 193564269821952
 referenced 90613743616
Btrfs Btrfs v0.19


sentryA:~ # df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdc1            292961308  93047288 199914020  32% /mnt/backend

