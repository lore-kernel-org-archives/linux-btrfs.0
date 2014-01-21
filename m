Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:57335 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 01:42:32 -0500
Received: by mail-qa0-f52.google.com with SMTP id j15so6370216qaq.11
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jan 2014 22:42:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52DD148E.3060200@gmail.com>
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>
	<52DD148E.3060200@gmail.com>
Date: Tue, 21 Jan 2014 01:42:31 -0500
Message-ID: <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
Subject: Re: Working on Btrfs as topic for master thesis
From: Sandy McArthur <sandymac@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 20, 2014 at 7:20 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> On 2014-01-16 14:23, Toggenburger Lukas wrote:
> > 3. Improving subvolume handling regarding taking recursive snapshots ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots ) and taking snapshots of arbitrary directories ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories )
>
> Another option that I would personally love to see would be support for
> write-mostly devices (that is, devices in a RAID1/RAID10 setup that only
> get written too unless the data can't be found elsewhere).  This would
> in particular provide an alternative to using bcache/dm-cache (namely an
> SSD and HDD in RAID1 with the HDD set to write-mostly).
> Based on the current development focus, I don't think anybody is working
> on this already (I would be, but I don't have either the time or the
> skills with kernel programming that would be needed).

Maybe this happens already: Might a similar effect be automatically
achieved by tracking per-device I/O load averages and distributing
reads based on the I/O loads of possible read devices?

-- 
Sandy McArthur
