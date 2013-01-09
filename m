Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506Ab3AIM7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Jan 2013 07:59:38 -0500
Date: Wed, 9 Jan 2013 13:59:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs fs not mounting or being identified after power loss.
Message-ID: <20130109125936.GT20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACCfv7ouftvEwAg0HWxCVSaOh+Q=K0+T65n0L4KJRqVa-e2_NA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 04:10:13PM +1030, Jordan Windsor wrote:
> /dev/sdb1 is the lost btrfs fs.
> 
> [root@archpc ~]# btrfs-find-root -v /dev/sdb1
> No valid Btrfs found on /dev/sdb1

> [root@archpc ~]# btrfsck /dev/sdb1
> No valid Btrfs found on /dev/sdb1

Looks like the first superblock is partially or completely damaged.
Btrfsck is able to operate starting from a different superblock

  btrfsck --super 1 /dev/sdb1

to see if there are other valid copies.

david
