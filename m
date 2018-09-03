Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42830 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbeICOmo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 10:42:44 -0400
Date: Mon, 3 Sep 2018 12:23:03 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: Pierre Couderc <pierre@couderc.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: IO errors when building RAID1.... ?
Message-ID: <20180903102303.6jver7oxvwlq6yhc@angband.pl>
References: <83a74213-e66c-238c-43e4-8333c678e588@couderc.eu>
 <CAJCQCtQso9Lvw-33DmLDuOxnMcsRPzq6Ya9oo_n2_LvsvFVYqA@mail.gmail.com>
 <1d04b9a0-ae0f-267c-11ec-722c2be279aa@couderc.eu>
 <CAJCQCtS6dy4JUqdQEuTNAxDeCVSsRPOhM-yNqq0c4BjQrkbDzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAJCQCtS6dy4JUqdQEuTNAxDeCVSsRPOhM-yNqq0c4BjQrkbDzw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 02, 2018 at 09:15:25PM -0600, Chris Murphy wrote:
> For > 10 years drive firmware handles bad sector remapping internally.
> It remaps the sector logical address to a reserve physical sector.
> 
> NTFS and ext[234] have a means of accepting a list of bad sectors, and
> will avoid using them. Btrfs doesn't. But also ZFS, XFS, APFS, HFS+
> and I think even FAT, lack this capability.

<nitpick>
FAT entry FF7 (FAT12)/FFF7 (FAT16)/...
</nitpick>


-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal [Mt3:16-17]
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs [Mt14:17-20, Mt15:34-37]
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water [Mt14:25-26]
