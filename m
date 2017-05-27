Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:52866 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750732AbdE0TeB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 May 2017 15:34:01 -0400
Subject: Re: btrfs-tools/linux 4.11: btrfs-cleaner misbehaving
To: Ivan P <chrnosphered@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <c3d2a91c-6fea-d273-2d58-1f8ea700b942@mendix.com>
Date: Sat, 27 May 2017 21:33:58 +0200
MIME-Version: 1.0
In-Reply-To: <CADzmB23Ytbp4eQcXZstFNM9W76Ug6DuyK-4rm_-VgOKzLsw1mQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 05/27/2017 08:53 PM, Ivan P wrote:
> 
> for a while now, btrfs-cleaner has been molesting my system's btrfs partition,
> as well as my CPU. The behavior is as following:
> 
> After booting, nothing relevant is happening. After about 5-30 minutes,
> a btrfs-cleaner process is spawned, which is constantly using one CPU core.
> The btrfs-cleaner process never seems to finish (I've let it waste CPU cycles
> for 9 hours) and also cannot be stopped or killed.
> 
> Rebooting again usually resolves the issue for some time.
> But on next boot, the issue usually reappears.
> 
> I'm running linux 4.11.2, but the issue is also present on current LTS 4.9.29.
> I am using newest btrfs-tools, as far as I can tell (4.11). The system is an
> arch linux x64 installed on a Transcend 120GB mSATA drive.
> 
> No other disks are present, but the root volume contains several subvolumes
> (@arch<date> snapshots, @home, @data).
> 
> The logs don't contain anything related to btrfs, beside the usual diag output
> on mounting the root partition.
> 
> I am mounting the btrfs partition with the following options:
> 
> subvol=@arch_current,compress=lzo,ssd,noatime,autodefrag
> 
> What information should I provide so we could debug this?

What I usually do first in a similar situation is look at the output of

  watch cat /proc/<pid>/stack

where <pid> is the pid of the btrfs-cleaner thread.

This might already give an idea what kind of things it's doing, by
looking at the stack trace. When it's cleaning up a removed subvolume
for example, there will be a similar function name in the stack somewhere.

-- 
Hans van Kranenburg
