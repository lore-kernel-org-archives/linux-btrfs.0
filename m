Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47104 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeICPbu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2018 11:31:50 -0400
Date: Mon, 3 Sep 2018 13:12:04 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        Mark Fasheh <mfasheh@versity.com>
Subject: Re: [PATCH 2/2] btrfs-progs: defrag: open files RO on new enough
 kernels or if root
Message-ID: <20180903111204.ngjj7w2kn4yoxnqb@angband.pl>
References: <20180903101426.14968-1-kilobyte@angband.pl>
 <20180903101426.14968-2-kilobyte@angband.pl>
 <51e331d1-0f61-7ccb-7424-99450658805b@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <51e331d1-0f61-7ccb-7424-99450658805b@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 03, 2018 at 02:01:21PM +0300, Nikolay Borisov wrote:
> On  3.09.2018 13:14, Adam Borowski wrote:
> > Fixes EXTXBSY races.
> 
> You have to be more eloquent than that and explain at least one race
> condition.

If you try to defrag an executable that's currently running:

ERROR: cannot open XXX: Text file busy
total 1 failures

If you try to run an executable that's being defragged:

-bash: XXX: Text file busy

The former tends to be a long-lasting condition but has only benign fallout
(executables almost never get fragmented, not recompressing a single file is
not the end of the world), the latter is only a brief window of time but has
potential for data loss.

> > +static mode_t defrag_ro = O_RDONLY;
> 
> This brings no value whatsoever, just use O_RDONLY directly

On old kernels it gets overwritten with:

> > +	if (get_running_kernel_version() < KERNEL_VERSION(4,19,0) && getuid())
> > +		defrag_ro = O_RDWR;


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ What Would Jesus Do, MUD/MMORPG edition:
⣾⠁⢰⠒⠀⣿⡁ • multiplay with an admin char to benefit your mortal [Mt3:16-17]
⢿⡄⠘⠷⠚⠋⠀ • abuse item cloning bugs [Mt14:17-20, Mt15:34-37]
⠈⠳⣄⠀⠀⠀⠀ • use glitches to walk on water [Mt14:25-26]
