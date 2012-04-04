From: Arnd Hannemann <arnd@arndnet.de>
Subject: hard links
Date: Wed, 04 Apr 2012 18:38:22 +0200
Message-ID: <4F7C78FE.2020508@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

today I experimented with hard links on btrfs and by this used all available inode space of a file.
Interestingly if this happens even a rename of such an filename to  an _equal length_ filename
fails:

arnd@kallisto:/mnt/btrfs/tmp$ mv a b
mv: cannot move `a' to `b': Too many links

Is this expected behavior?
There should be no reason to let this particular case fail?

Best regards,
Arnd
