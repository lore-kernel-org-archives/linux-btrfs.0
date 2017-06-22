Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40290 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753153AbdFVMdr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 08:33:47 -0400
Date: Thu, 22 Jun 2017 14:33:40 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stability status of btrfs-convert...
Message-ID: <20170622123340.dd6qaaxn75k5z7bc@angband.pl>
References: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 03:07:14PM +0530, Shyam Prasad N wrote:
> I'm planning to use the btrfs-convert tool to convert production data
> in ext4 filesystem into btrfs.
> What is the stability status of this feature?

It has been recently (btrfs-progs 4.6) rewritten nearly from scratch.  This
was a year ago and from the lack of complaints recently it sounds like any
major bugs should be ironed out -- assuming you're using a version of -progs
new enough.

On the other hand, if you'd want use -progs older than that, I'd recommend
also using raid5 and qgroups _and_ cat </dev/urandom >/dev/the_filesystem,
so you have no misguided hopes about the safety of your data. :)

> Can I know the reason why? Is it because most existing ext4
> filesystems are already converted?

Most of us recreate the filesystem from scratch, that's the safer way.
Also, defrag + full-balance are slower than just copying everything in, thus
the only things to gain are short downtime (both defrag and balance work
online) and no need for temp storage.

> Is this tool supported, at least? Can I use this tool as a part of
> software upgrade to change the data filesystem to btrfs?

You do have backups, right?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
