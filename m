Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab3JVQUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:20:21 -0400
Date: Tue, 22 Oct 2013 18:20:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131022162019.GY1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131021122123.43b3aa50@virtall.com>
 <20131021151032.708cc7d2@virtall.com>
 <20131021125317.GK1032@twin.jikos.cz>
 <20131022025025.169941de@virtall.com>
 <20131022154619.GW1032@twin.jikos.cz>
 <20131023010411.42d30c97@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131023010411.42d30c97@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 23, 2013 at 01:04:11AM +0900, Tomasz Chmielewski wrote:
> Actually it's still working.
> 
> If I run this:
> 
> # btrfs scrub status /mnt/lxc1
> scrub status for 8d08ad6d-4543-4fe5-8b1b-640dc1423d41
>         scrub started at Tue Oct 22 09:53:34 2013, running for 22101 seconds
>         total bytes scrubbed: 2.61TB with 0 errors

This looks promising.

> However, it's not possible to work with this system via SSH, because
> these keep popping up few times every minute:

Probably only some of the files that get accessed during ssh login is
corrupted, but the scrub does not get far enough to let you know the
filenames. You can try to look into 'lsof' output which files are open
by sshd or it's children.

>  kernel:[22219.117012] BUG: soft lockup - CPU#2 stuck for 23s! [btrfs:5673]
>  kernel:[22247.100515] BUG: soft lockup - CPU#0 stuck for 23s! [btrfs:5674]
>  kernel:[22247.100519] BUG: soft lockup - CPU#2 stuck for 23s! [btrfs:5673]

Cpus 0 and 2 are stuck and every other attempt to access the broken
files will pin another cpu.
