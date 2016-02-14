Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40892 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcBNV1v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 16:27:51 -0500
Date: Sun, 14 Feb 2016 13:27:30 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on top of bcache on top of dmcrypt on top of md raid5
Message-ID: <20160214212730.GG4115@merlins.org>
References: <20160212160441.GH2763@merlins.org> <CAJCQCtT6P15w-uhoYSb038-UJk+8ggpEF0D84CzJt2Ue_ZCaeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtT6P15w-uhoYSb038-UJk+8ggpEF0D84CzJt2Ue_ZCaeA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 14, 2016 at 01:43:05PM -0700, Chris Murphy wrote:
> Use all defaults for everything. Anything new by show should do the
> right thing including 4096 byte alignment.
> 
> gargamel:~# cryptsetup luksDump /dev/md8
> [snip]
> Payload offset: 3072
> 
> This is a bit weird because the default is 4096. But because the LUKS
> offset (header + payload + extra unused space) is 2MiB, so it doesn't
> affect alignment. There may be unpatched (fixes not backported) in the
> tools of current long term supported distros, that can cause
> misalignment. Probably top concern would be parted/libparted, which
> would start partition 1 at LBA 63, which is not aligned. The upstream
> tools for a long time now have set partition 1 to LBA 2048, but these
> crusty old unpatched versions just seem to persist like a booger you
> can't flick off. It's really annoying - this idea of "stable bugs"
> that go on and on for a decade.

Indeed. Thankfully my partitions now start at 2048 like you say.

The only thing I did wrong last time (when using bcache) is
md5 - dmcrypt - bcache - btrfs
ssd - dmcrypt /

This was stupid, I needed to do this:
md5  - bcache - dmcrypt - btrfs
ssd /

So I think at this point, just to be future proof, I'm going to add bcache 
on top of all block devices I have, before putting dmcrypt on top, even if I
don't have a cache device.
That way I can later add a cache device without problems.

Without doing that, adding bcache later is a full re-install :(

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
