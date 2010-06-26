From: Daniel Baumann <daniel@debian.org>
Subject: mkfs.btrfs creates file system with default permissions 555
Date: Sat, 26 Jun 2010 19:18:57 +0200
Message-ID: <4C263681.9060902@debian.org>
Reply-To: daniel@debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is basically a forward from
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=574748:

"mkfs.btrfs creates a file system with permisions set to 555 on the file
system root. Please change this to 755 as it is done for other file
systems because an empty file system where not even root can write does
not make much sense."

It would be nice if you could fix.

Regards,
Daniel

-- 
Address:        Daniel Baumann, Burgunderstrasse 3, CH-4562 Biberist
Email:          daniel.baumann@panthera-systems.net
Internet:       http://people.panthera-systems.net/~daniel-baumann/
