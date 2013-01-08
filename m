Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab3AHSB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 13:01:57 -0500
Date: Tue, 8 Jan 2013 19:01:26 +0100
From: Karel Zak <kzak@redhat.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Message-ID: <20130108180126.GB9177@x2.net.home>
References: <50E9C267.3050302@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E9C267.3050302@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
> If the first superblock is valid except that the "magic field" is zeroed,
> btrfs skips the check of the other superblocks.
> If the first superblock is fully invalid, btrfs checks for the other
> superblock.

 Hmm... why inconsistent (or missing) superblock is not reported as a
 problem? If I good understand the filesystem is still mountable,
 right?

> So zeroing the first superblock "magic field" at the beginning seems
> that the filesystem is wiped.

 Well, this is exactly the idea behind wipefs(8), just wipe minimal
 number of bytes from the device to make the filesystem invisible for
 libblkid (udev, ...). This concept is relatively safe, if you make a
 mistake than you can restore the magic string, your data should not
 be affected by wipefs(8).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
