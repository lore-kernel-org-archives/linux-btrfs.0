Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42111 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab3AUSkS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 13:40:18 -0500
Date: Mon, 21 Jan 2013 19:40:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/13] Btrfs-progs: more patches for integration
 (integration-20130121)
Message-ID: <20130121184016.GC7971@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 20, 2013 at 04:04:05PM -0500, Gene Czarcinski wrote:
> I have done some additional scraping of the mailing list to
> identify some "low hanging fruit" which I consider should
> be merged into the btrfs-progs repository.

Thanks, I went through them and put together into an integration branch

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130121

I've modified the signed-off-by lines when I knew who was the author or
contributed to the patch. Please let me know if I've messed the credits
and fame attribution.

There are three more patches that I've picked from my distro patch queue (and
were sent to the list long ago) they're placed at the top of the shortlog.

Arne Jansen (1):
      Btrfs-progs: bugfix for scrubbing single devices

Wang Sheng-Hui (1):
      btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction

Goffredo Baroncelli (1):
      Ignore the error ENXIO and ENOMEDIUM during a devs scan

Arvin Schnell (1):
      btrfs-progs: initialize data before send ioctl

Danny Kukawka (1):
      btrfs-progs: Handle errors returned from open_ctree

Jan Schmidt (2):
      Btrfs-progs: correcting misnamed parameter options for btrfs send
      Btrfs-progs: bugfix for subvolume parent determination in btrfs send

Josef Bacik (2):
      Btrfs-progs: detect if the disk we are formatting is a ssd
      Btrfs-progs: add btrfs device ready command

Nirbheek Chauhan (1):
      Btrfs-progs: fix resolving of loop devices

Stefan Behrens (1):
      btrfs-progs: Add btrfs-show-super

Ulrik (1):
      Btrfs-progs: correct btrfs receive usage string

Wang Shilong (3):
      Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
      Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi with strtoull
      Btrfs-progs: check the relation of two group by real level numbers

david
