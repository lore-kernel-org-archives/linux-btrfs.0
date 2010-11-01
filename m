From: =?windows-1252?Q?Andreas_Bauer?= <ab@voltage.de>
Subject: RE: Kernel 2.6.36 btrfs csum bugreport
Date: Mon, 1 Nov 2010 11:39:33 +0100
Message-ID: <vmime.4cce98e5.53be.3dea104351d19eb5@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

To follow up on this matter, I have created another two btrfs volumes (also plain - no options - also on two external USB-SATA disks), and am at the moment copying heaps of data between these two. No errors as of yet. All copies are verified by md5sum after the deed.

The volume in question can still "reliably" reproduce the csum errors on read, though. Aprox. 30 csum errors occur when the whole fs is read. The data is still fine. I can put it aside for further debugging until at most Wednesday morning.

If someone wants me to run diagnostics on it, please let me know. I am glad to be of help (until Wednesday morning).

Andreas
