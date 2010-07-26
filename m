From: Alex Cavnar <alc6379@gmail.com>
Subject: bad tree block after power loss during rebalance
Date: Mon, 26 Jul 2010 16:09:22 -0500
Message-ID: <AANLkTikog8ukHjdQjAA6d6S6egrXbNFPjKD2xuTW71Gn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey all,

I have a 3TB array I'm running via MD with a BTRFS filesystem on it. I
lost power during a rebalance, and now when I attempt to mount it, I
get this error in dmesg:

(This is attempting to mount with -o degraded option)

Jul 26 15:56:36 NASBOX kernel: [234228.548197] btrfs: open_ctree failed
Jul 26 16:00:37 NASBOX kernel: [234469.584064] device fsid
fb481f12aed8508d-bf298b2f357984bf devid 1 transid 36802
/dev/mapper/vg--raid-lv--storage
Jul 26 16:00:37 NASBOX kernel: [234469.584490] btrfs: allowing degraded mounts
Jul 26 16:00:39 NASBOX kernel: [234471.703955] btrfs bad tree block
start 6949838612584515097 241665916928
Jul 26 16:00:39 NASBOX kernel: [234471.724204] btrfs: open_ctree failed

Any pointers to get this to mount? I know that btrfsck doesn't fix
anything, but is there something I can do to recover this volume?
There is some data I'd like to get off that I'd placed on between
backups.

Thanks!
Alex Cavnar
