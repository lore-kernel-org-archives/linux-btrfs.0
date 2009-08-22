From: tsuraan <tsuraan@gmail.com>
Subject: Re: RAID[56] with arbitrary numbers of "parity" stripes.
Date: Sat, 22 Aug 2009 14:00:32 -0500
Message-ID: <84fb38e30908221200o19fbb8a0u8016980e57c9de54@mail.gmail.com>
References: <1249502665.23206.5.camel@macbook.infradead.org>
	 <84fb38e30908220834pab3f891we9ca7114a16988c0@mail.gmail.com>
	 <FB53229A-142C-40B1-B946-0AC496D7A2A5@karlsbakk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <FB53229A-142C-40B1-B946-0AC496D7A2A5@karlsbakk.net>
List-ID: <linux-btrfs.vger.kernel.org>

> By the way - how does FUSE ZFS work? Is it stable? Good performance?
> We're using ZFS natively on Solaris 10 now, perhaps moving the storage
> to opensolaris soon.

It's pretty stable; I wouldn't put anything on it that isn't backed
up, but I guess that holds for any other filesystem.  The speed isn't
yet up to par with the ntfs-fuse project, but they're working on it.
On my personal machine, I get 100MB/s writes and 250MB/s reads on an
8-drive RAID-Z2, but I don't know how that compares to anything else,
since OpenSolaris won't boot on my hardware and I don't have the
patience to wait for md to sync 8 TB worth of drives.  I'm reasonably
happy with zfs-fuse, but I'm definitely looking forward to seeing how
it compares with a native filesystem that supports RAID6.
