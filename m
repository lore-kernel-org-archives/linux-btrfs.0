Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48065 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbcBWRfP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 12:35:15 -0500
Date: Tue, 23 Feb 2016 09:34:44 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>, Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20160223173444.GJ22487@merlins.org>
References: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
 <20160223172635.GI22487@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160223172635.GI22487@merlins.org>
Subject: Re: Major HDD performance degradation on btrfs receive
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 09:26:35AM -0800, Marc MERLIN wrote:
> Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
>         Total devices 1 FS bytes used 4.25TiB
>         devid    1 size 7.28TiB used 4.44TiB path /dev/mapper/dshelf2
> 
> btrfs fi df /mnt/btrfs_pool2/
> Data, single: total=4.29TiB, used=4.18TiB
> System, DUP: total=64.00MiB, used=512.00KiB
> Metadata, DUP: total=77.50GiB, used=73.31GiB
> GlobalReserve, single: total=512.00MiB, used=31.22MiB
> 
> Currently, it's btrfs on top of dmcrpyt on top of swraid5

Sorry, I forgot to give the mount options:
/dev/mapper/dshelf2 on /mnt/dshelf2/backup type btrfs (rw,noatime,compress=lzo,space_cache,skip_balance,subvolid=257,subvol=/backup)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
