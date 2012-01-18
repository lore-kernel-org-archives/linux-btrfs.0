From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Premature ENOSPC only with zlib Compression
Date: Wed, 18 Jan 2012 10:13:22 -0600
Message-ID: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a Btrfs partition that is reliably reproducing premature ENOSPC
when restoring the disk from a tar file, but it is only happening with
zlib compression (lzo or no compression proceeds normally).

I've had the same issue at least back through the 3.1 kernel series,
and I've been having intermittent issues even further back.

I am currently using a 3.2.1 kernel merged with Chris' latest
integration branch.

I've performed about 12 trials trying to explore various combinations
of compress, compress-force, compress[-force]=[zlib,lzo] and
autodefrag.

If I use no compression, or if I explicitly declare lzo compression, I
don't receive the premature ENOSPC when untarring my restoration
archive to the empty partition.

If I don't specify compression (zlib is the default) or specify zlib,
I get consistent premature ENOSPC errors regardless of other
combinations.

I apologize if this is already general knowledge, but I couldn't see
where this has been posted to the list before.

As time allows, I will try to capture exactly where this ENOSPC is
being issued in btrfs by inserting WARN_ON's in my local version
where-ever ENOSPC is set.
