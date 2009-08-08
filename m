From: Adrian Ulrich <adrian@blinkenlights.ch>
Subject: btrfs-cache processes
Date: Sun, 9 Aug 2009 00:17:23 +0200
Message-ID: <20090809001723.223a0962.adrian@blinkenlights.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've upgraded my system to 2.6.31-rc5 some days ago. Yesterday i've discovered that
this kernel produces some berserk btrfs-cache processes:

There are about 4 of them and they use ~95% sys-cputime.
About 20 seconds after they started 'freaking out' all writes to BTRFS will
block and umounting also doesn't work anymore. Reading the volume
still works (mostly) and there appers to be no disk activity (iostat/top
reports nothing unusual).

This isn't normal, isn't it? ;-)

Everything appears to work fine on Linux 2.6.31-rc3

Regards,
 Adrian






