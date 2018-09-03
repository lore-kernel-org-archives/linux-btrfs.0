Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:48416 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbeICPsi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 11:48:38 -0400
Date: Mon, 3 Sep 2018 13:28:48 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: defrag: open files RO on new enough
 kernels or if root
Message-ID: <20180903112848.dinguob7clx4m6g7@angband.pl>
References: <20180903101426.14968-1-kilobyte@angband.pl>
 <20180903101426.14968-2-kilobyte@angband.pl>
 <61784cbe-719b-a83f-8535-bb622c39edcb@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <61784cbe-719b-a83f-8535-bb622c39edcb@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 02:04:23PM +0300, Nikolay Borisov wrote:
> On  3.09.2018 13:14, Adam Borowski wrote:
> > -		fd = open(fpath, O_RDWR);
> > +		fd = open(fpath, defrag_ro);
> 
> Looking at the kernel code I think this is in fact incorrect, because in
> ioctl.c we have:
> 
>                 if (!(file->f_mode & FMODE_WRITE)) {
> 
>                         ret = -EINVAL;
> 
>                         goto out;
> 
>                 }
> 
> So it seems a hard requirement to have opened a file for RW when you
> want to defragment it.

Oif!  I confused this with dedup, which does allow root to dedup RO even on
old kernels.  Good catch.


-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal [Mt3:16-17]
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs [Mt14:17-20, Mt15:34-37]
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water [Mt14:25-26]
