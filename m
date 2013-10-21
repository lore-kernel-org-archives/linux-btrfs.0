Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52770 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3JUMxT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 08:53:19 -0400
Date: Mon, 21 Oct 2013 14:53:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131021125317.GK1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131021122123.43b3aa50@virtall.com>
 <20131021151032.708cc7d2@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131021151032.708cc7d2@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 21, 2013 at 03:10:32PM +0900, Tomasz Chmielewski wrote:
> Note the "BTRFS critical (device sdd1): unable to find logical
> 7598242613674844160 len 4096" there; after that, the fs freezes and
> system won't reboot; has to be power cycled.

>From the first mail:
[67893.390592] BTRFS critical (device sdb5): unable to find logical 69225652694147072 len 4096

> [ 9138.480011] BTRFS critical (device sdd1): unable to find logical 7598242613674844160 len 4096

  69225652694147072 = 0xf5f05d462de000 = something that looks like inctruction fragments
7598242613674844160 = 0x6972616661532000 = "irafaS" -> Safari?

Something has corrupted the memory and stored the bytes on disk where
btrfs finds the garbage and chokes. Try read-only mount and run scrub.

david
