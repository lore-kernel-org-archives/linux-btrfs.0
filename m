Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34296 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdHDHtk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 03:49:40 -0400
Received: by mail-oi0-f48.google.com with SMTP id x3so8527379oia.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Aug 2017 00:49:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804072229.4h534hr54ne3d764@angband.pl>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <20170804060007.blgcu5khfo4juwfe@angband.pl> <CANT5p=qvu9tCf73+_PuAj9Ryy69p3JjAyHFY_pAA9eUsTz_ELA@mail.gmail.com>
 <20170804072229.4h534hr54ne3d764@angband.pl>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 4 Aug 2017 13:19:39 +0530
Message-ID: <CANT5p=r9gMUu1F8Vkgs6=O1UBfBLn=96XAZBzB6OsHnSQw0C5A@mail.gmail.com>
Subject: Re: Power down tests...
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh ok. I read this in the man page and assumed that it's on by default:
       flushoncommit, noflushoncommit
           (default: on)

           This option forces any data dirtied by a write in a prior
transaction to commit as part of the current commit. This makes the
committed state a fully consistent view of the file system from the
           application’s perspective (i.e., it includes all completed
file system operations). This was previously the behavior only when a
snapshot was created.

           Disabling flushing may improve performance but is not crash-safe.


Maybe this needs a correction?

On Fri, Aug 4, 2017 at 12:52 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Fri, Aug 04, 2017 at 12:15:12PM +0530, Shyam Prasad N wrote:
>> Is flushoncommit not a default option on version
>> 4.4? Do I need specifically set this option?
>
> It's not the default.
>
> --
> ⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
> ⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal
> ⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs (the five fishes + two breads affair)
> ⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water



-- 
-Shyam
