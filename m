Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55391 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbcBKGbl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 01:31:41 -0500
Date: Wed, 10 Feb 2016 22:31:32 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Message-ID: <20160211063132.GX13969@merlins.org>
References: <20160123170354.GA10113@merlins.org>
 <56A57C59.1040203@cn.fujitsu.com>
 <20160125205500.GK23751@merlins.org>
 <56A6C5CB.5060406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56A6C5CB.5060406@cn.fujitsu.com>
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2016 at 09:03:07AM +0800, Qu Wenruo wrote:
> If the fs is small enough, would you please do a btrfs-image dump?
> That would help a lot to locate the direct cause.
 
I started making a dump, image was growing past 3GB, and then it failed
and the image got deleted:

gargamel:~# btrfs-image -s -c 9 /dev/mapper/dshelf1old /mnt/dshelf1/ds1old.dump
Error adding space cache blocks -5
Error flushing pending -5
create failed (Success)

gargamel:~# dpkg --status btrfs-tools
Package: btrfs-tools
Status: install ok installed
Priority: optional
Section: admin
Installed-Size: 3605
Maintainer: Dimitri John Ledkov <xnox@debian.org>
Architecture: amd64
Version: 4.4-1

Is there a 4G file size limit, or did I hit another problem?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
