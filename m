Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45075 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448AbaAUMZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 07:25:44 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so3371223ieb.33
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 04:25:43 -0800 (PST)
Message-ID: <52DE6747.4050404@gmail.com>
Date: Tue, 21 Jan 2014 07:25:43 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Sandy McArthur <sandymac@gmail.com>
CC: Toggenburger Lukas <Lukas.Toggenburger@htwchur.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Working on Btrfs as topic for master thesis
References: <8E968DF3B7EC0D40B67B5A9D25675A6A03FC70@MBXSRV03EDU.edu.local>	<52DD148E.3060200@gmail.com> <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
In-Reply-To: <CAPs0BijBB0JTJd_-89Jo3OUozDKN8cCWA27=irBD+UoRShxPiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-21 01:42, Sandy McArthur wrote:
> On Mon, Jan 20, 2014 at 7:20 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>>
>> On 2014-01-16 14:23, Toggenburger Lukas wrote:
>>> 3. Improving subvolume handling regarding taking recursive snapshots ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Take_recursive_snapshots ) and taking snapshots of arbitrary directories ( https://btrfs.wiki.kernel.org/index.php/Project_ideas#Snapshot_arbitrary_directories )
>>
>> Another option that I would personally love to see would be support for
>> write-mostly devices (that is, devices in a RAID1/RAID10 setup that only
>> get written too unless the data can't be found elsewhere).  This would
>> in particular provide an alternative to using bcache/dm-cache (namely an
>> SSD and HDD in RAID1 with the HDD set to write-mostly).
>> Based on the current development focus, I don't think anybody is working
>> on this already (I would be, but I don't have either the time or the
>> skills with kernel programming that would be needed).
> 
> Maybe this happens already: Might a similar effect be automatically
> achieved by tracking per-device I/O load averages and distributing
> reads based on the I/O loads of possible read devices?
> 
That might be the case, it depends on how the I/O load averages are
calculated.  I actually hadn't realized BTRFS did this, I thought it
behaved more like MD RAID (that is, distributing the reads among devices
in a un-weighted round-robin fashion).
