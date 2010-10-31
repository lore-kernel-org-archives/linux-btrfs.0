From: =?windows-1252?Q?Andreas_Bauer?= <ab@voltage.de>
Subject: Kernel 2.6.36 btrfs csum bugreport
Date: Sun, 31 Oct 2010 13:55:28 +0100
Message-ID: <vmime.4ccd6740.445d.4b0252c0586bb40@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

Today while playing around with btrfs I uncovered what must be a bug in the btrfs checksum code. My kernel log received a couple of these messages with various ino and off numbers:

btrfs csum failed ino 5098 off 524288 csum 2981133980 private 959545494
[..]

This happens on reading from the btrfs filesystem.

The funny thing is that the files are read correct, as verified by md5sum. I have cross-checked this on another machine (with same kernel and btrfs utils): same result. A full filesystem md5sum check showed no errors. The md5sums obviously were computed before the data was copied to the btrfs.

So I conclude that these messages are faulty because data is read correctly. In addition, when you have more than one btrfs you cannot see from the message which fs it is refering to.

Here is my setup, maybe it has something to do with the (nowadays) unusual kernel target:

- unmodified upstream 2.6.36 kernel
- Debian Squeeze
- Standard Debian gcc 4.3.5 with target i486
- CPU AMD Geode LX800 on ALIX board
- btrfs on USB-ATA connected IDE drive Seagate Barracuda 7200.8 ST3400832A
- btrs utils v0.19
- about 300GB of data of all sorts in 50000+ files on the fs
- data gets rsynced to another btrfs volume of 1TB when on read the csum errors occur

Hope that some of this informations rings a bell on someones mind. If so, please let me know ;)

bye, Andreas
