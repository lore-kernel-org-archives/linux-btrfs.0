Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab3AJLfM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Jan 2013 06:35:12 -0500
Date: Thu, 10 Jan 2013 12:35:10 +0100
From: David Sterba <dsterba@suse.cz>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs fs not mounting or being identified after power loss.
Message-ID: <20130110113510.GB20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
 <20130109125936.GT20089@twin.jikos.cz>
 <CACCfv7qAMJGix0phr-XCE2d22zOfvvywNfY2FVou65N0FnmgZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACCfv7qAMJGix0phr-XCE2d22zOfvvywNfY2FVou65N0FnmgZA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 10, 2013 at 01:27:33AM +1030, Jordan Windsor wrote:
> [root@archpc btrfs-progs]# ./btrfsck --super 1 /dev/sdb1
> using SB copy 1, bytenr 67108864
> No valid Btrfs found on /dev/sdb1

Please dump the existing superblocks to files and send them to me (they
do not contain any sensitive information) with commands

dd if=/dev/sdb1 bs=1k count=4 skip=64 of=sdb1-sb0
dd if=/dev/sdb1 bs=1k count=4 skip=65536 of=sdb1-sb1

to see if the data at least resemble a superblock.


david
