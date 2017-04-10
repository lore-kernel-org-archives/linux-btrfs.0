Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51337 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752151AbdDJWVb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 18:21:31 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.88)
        (envelope-from <kilobyte@angband.pl>)
        id 1cxhgf-0005Xw-2r
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 00:21:29 +0200
Date: Tue, 11 Apr 2017 00:21:29 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Message-ID: <20170410222128.vpkyjr67jb775zdi@angband.pl>
References: <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
 <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
 <20170410184444.08ced097@jupiter.sol.local>
 <20170410185437.235b3b86@jupiter.sol.kaishome.de>
 <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
 <20170410201842.216893be@jupiter.sol.kaishome.de>
 <ce3ddbc7-da26-9fc7-e783-e9d566009ae8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ce3ddbc7-da26-9fc7-e783-e9d566009ae8@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 10, 2017 at 03:43:57PM -0400, Austin S. Hemmelgarn wrote:
> On 2017-04-10 14:18, Kai Krakow wrote:

> * strictatime, lazytime: Both atime and mtime updates happen, but they
> actual update may not hit the disk for up to 24 hours (this will let mutt
> work correctly as long as your system shuts down cleanly, but still improve
> performance noticeably on at least ext4).

> > Well, relatime is mostly the same thus not perfectly resembling the
> > POSIX standard. I think the only software that relies on atime is
> > mutt...

Well, about that mutt thing...  Neomutt actually, but that's the codebase
Debian uses:

https://github.com/neomutt/neomutt/commit/816095bfdb72caafd8845e8fb28cbc8c6afc114f

-- 
⢀⣴⠾⠻⢶⣦⠀ Meow!
⣾⠁⢠⠒⠀⣿⡁
⢿⡄⠘⠷⠚⠋⠀ Collisions shmolisions, let's see them find a collision or second
⠈⠳⣄⠀⠀⠀⠀ preimage for double rot13!
