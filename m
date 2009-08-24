From: Markus Suvanto <markus.suvanto@gmail.com>
Subject: Re: [PATCH]Re: The first character disappears
Date: Mon, 24 Aug 2009 19:42:04 +0300
Message-ID: <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
	 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
	 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
	 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
	 <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Atila <atila.alr@dpf.gov.br>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Now I notice that I can reproduce this index file corrupt only if
compress is enabled.

lvm lvcreate -L 5G -n btrfs_test /dev/vg_md1
mkbtrfs /dev/mapper/vg_md1-btrfs_test
mount -t btrfs -o subvol=.,compress  /dev/mapper/vg_md1-btrfs_test /tmp/btrfs/
btrfsctl -S test /tmp/btrfs/
cd /tmp/btrfs/test/
git clone /usr/src/linux-2.6/
/tmp/btrfs-progs-unstable/bcp linux-2.6/ linux-2.6_copy
cd linux-2.6_copy/
git status

error: bad index file sha1 signature
fatal: index file corrupt


But without compress:

mkbtrfs /dev/mapper/vg_md1-btrfs_test
mount -t btrfs -o subvol=.  /dev/mapper/vg_md1-btrfs_test /tmp/btrfs/
btrfsctl -S test /tmp/btrfs/
cd /tmp/btrfs/test/
git clone /usr/src/linux-2.6/
/tmp/btrfs-progs-unstable/bcp linux-2.6/ linux-2.6_copy
cd linux-2.6_copy/
git status

# On branch master
nothing to commit (working directory clean)


2009/8/24 Markus Suvanto <markus.suvanto@gmail.com>:
> Ok, the first problem is fixed but after bcp
> git status
> error: bad index file sha1 signature
> fatal: index file corrupt
