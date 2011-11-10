From: "Rieder  Michael" <mr@student.ethz.ch>
Subject: TRIM discard testing
Date: Thu, 10 Nov 2011 19:58:17 +0000
Message-ID: <1EFA45DCD932BC42AB701E5073CC52D41CE5F1@MBX12.d.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I installed a new SSD  in my Macbook running Arch Linux (Kernel 3.1). root partition has btrfs with discard and ssd mount parameters. I wanted to test whether the discard option was actually working, so I performed a testing procedure similar to what is described on various websites.
The test file was the output of "seq 100000 999999" which is about 6MB in size. Instead of looking up the file offset with hdparm (as suggested for ext4, but not working with btrfs), I searched for one of these numbers in /dev/sda2 with "hexedit". After I found it deleted the file, did "sync" and even waited for two minutes (someone suggested sleep 120...), then opened hexedit on /dev/sda2 again, and jumped to the offset to see if the data was still there which it was.
hdparm -I says the drive supports TRIM and does "Deterministic read after TRIM" which I interpret to mean that if the data was really discarded, the drive should return zeros (or something else) but not the previous data.

So I am not familiar with neither internals of btrfs or SATA/IDE standards so I am clueless here. Is my testing procedure wrong? If not, does the discard command get lost somewhere?

Thanks for your help.
