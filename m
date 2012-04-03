From: Andy Spencer <andy753421@gmail.com>
Subject: btrfs sync(2) performance
Date: Tue, 3 Apr 2012 06:08:36 +0000
Message-ID: <20120403060836.GA11096@c.gateway.2wire.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been testing (using) btrfs for a little while and noticed some
performance issues a couple months ago whenever I called sync(2). After
some googling it seem some other people have had similar issues:

  http://comments.gmane.org/gmane.comp.file-systems.btrfs/13511
  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/601299

The odd part for me was that it seemed to work reasonably well at first
but then it got progressively worse until I reboot. I ended up writing a
quick program that runs `sync(); sleep(60);' in a loop to record the
time spent in each call to sync(). This was with an older kernel, but
you can see how it got worse over several days and never really
recovered:

  http://andy753421.ath.cx/linked/btrfs/btrfs-sync-3.2.0-rc1.png

I updated my kernel after that to the latest stable version at the time,
3.2.6, and started recording data again. With the new version, most of
the problems seemed to go away (thank you!), but the graph still looks
a little odd to me so I'm posting here anyway :)

  http://andy753421.ath.cx/linked/btrfs/btrfs-sync-3.2.6.png

To me, the strangest part seems to be the bump around days 4-6. I
remember what happened there too. At around 4 days I ran an apt-get
update which caused the initial spike, then when that finished the sync
times where around 3 seconds as opposed to the 1.5s before. Then at 6
days I ran apt-get update again, but when that finished the sync times
went back down to 1.5 seconds! I tried it again a day later, but
couldn't reproduce the 3 second bump in sync times.. After that it seems
to gets slowly slower for a while, but nothing quite as strange as the 3
second bump around days 4-5.


For reference, this is running on a Core 2 Quad with 2GB of ram. Btrfs
is running on a raid 5 array of 3 1TB disks. I've included the sections
of /etc/fstab and df -h for all my mounted partitions as well.

I've had btrfs running on a laptop as well, but didn't notice any issues
there. Could it be something to do with the raid array? Any other
thoughts on what could cause this, or should I just assume it's normal
and ignore it? :)


/etc/fstab:
  /dev/md3   /            btrfs     noatime  0 1
  /dev/md4   /mnt/x       btrfs     noatime  0 0
  /dev/sdd4  /mnt/backup  reiserfs  noatime  0 0

df -h:
  Filesystem      Size  Used Avail Use% Mounted on
  rootfs           80G   16G   59G  21% /
  /dev/root        80G   16G   59G  21% /
  /dev/md4        1.8T  1.4T  330G  82% /mnt/x
  /dev/sdd4       313G  177G  137G  57% /mnt/backup
