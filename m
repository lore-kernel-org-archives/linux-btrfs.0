Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:48185 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbdLJKuu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 05:50:50 -0500
Date: Sun, 10 Dec 2017 11:49:30 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exclusive subvolume space missing
Message-ID: <20171210104930.GA22022@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <20171201213614.GE29898@carfax.org.uk>
 <20171202005338.GA20205@polanet.pl>
 <20171202162812.GA5324@polanet.pl>
 <20171202171819.GA4629@polanet.pl>
 <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <pan$4b81d$3ba1cf57$e9dd4e05$8cf6db12@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 03, 2017 at 01:45:45 +0000, Duncan wrote:

> OTOH, it's also quite possible that people chose btrfs at least partly
> for other reasons, say the "storage pool" qualities, and would rather

Well, to name some:

1. filesystem-level backups via snapshot/send/receive - much cleaner and
faster than rsyncs or other old-fashioned methods. This obviously requires the CoW-once feature;

- caveat: for btrfs-killing usage patterns all the snapshots but the
  last one need to be removed;


2. block-level checksums with RAID1-awareness - in contrary to mdadm
RAIDx, which chooses random data copy from underlying devices, this is
much less susceptible to bit rot;

- caveats: requires CoW enabled, RAID1 reading is dumb (even/odd PID
  instead of real balancing), no N-way mirroring nor write-mostly flag.


3. compression - there is no real alternative, however:

- caveat: requires CoW enabled, which makes it not suitable for
  ...systemd journals, which compress with great ratio (c.a. 1:10),
  nor for various databases, as they will be nocowed sooner or later;


4. storage pools you've mentioned - they are actually not much superior to
LVM-based approach; until one could create subvolume with different
profile (e.g. 'disable RAID1 for /var/log/journal') it is still better
to create separate filesystems, meaning one have to use LVM or (the hard
way) paritioning.


Some of the drawbacks above are immanent to CoW and so shouldn't be
expected to be fixed internally, as the needs are conflicting, but their
impact might be nullified by some housekeeping.

-- 
Tomasz Pala <gotar@pld-linux.org>
