Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:52776 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3JURuh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 13:50:37 -0400
Date: Tue, 22 Oct 2013 02:50:25 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131022025025.169941de@virtall.com>
In-Reply-To: <20131021125317.GK1032@twin.jikos.cz>
References: <20131021122123.43b3aa50@virtall.com>
	<20131021151032.708cc7d2@virtall.com>
	<20131021125317.GK1032@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 21 Oct 2013 14:53:17 +0200
David Sterba <dsterba@suse.cz> wrote:

> On Mon, Oct 21, 2013 at 03:10:32PM +0900, Tomasz Chmielewski wrote:
> > Note the "BTRFS critical (device sdd1): unable to find logical
> > 7598242613674844160 len 4096" there; after that, the fs freezes and
> > system won't reboot; has to be power cycled.
> 
> From the first mail:
> [67893.390592] BTRFS critical (device sdb5): unable to find logical
> 69225652694147072 len 4096
> 
> > [ 9138.480011] BTRFS critical (device sdd1): unable to find logical
> > 7598242613674844160 len 4096
> 
>   69225652694147072 = 0xf5f05d462de000 = something that looks like
> inctruction fragments 7598242613674844160 = 0x6972616661532000 =
> "irafaS" -> Safari?
> 
> Something has corrupted the memory and stored the bytes on disk where
> btrfs finds the garbage and chokes. Try read-only mount and run scrub.

I'm getting these every few seconds when running scrub - expected?

 kernel:[ 3809.964073] BUG: soft lockup - CPU#6 stuck for 23s! [btrfs:13127]

Message from syslogd@bkp010 at Oct 21 17:49:22 ...
 kernel:[ 3809.964075] BUG: soft lockup - CPU#3 stuck for 23s! [btrfs:13128]

Message from syslogd@bkp010 at Oct 21 17:49:30 ...
 kernel:[ 3817.959359] BUG: soft lockup - CPU#4 stuck for 22s! [btrfs:13189]

Message from syslogd@bkp010 at Oct 21 17:49:30 ...
 kernel:[ 3817.959362] BUG: soft lockup - CPU#1 stuck for 22s! [btrfs:13190]

Message from syslogd@bkp010 at Oct 21 17:49:50 ...
 kernel:[ 3837.947582] BUG: soft lockup - CPU#6 stuck for 22s! [btrfs:13127]

Message from syslogd@bkp010 at Oct 21 17:49:50 ...
 kernel:[ 3837.947585] BUG: soft lockup - CPU#3 stuck for 22s! [btrfs:13128]


-- 
Tomasz Chmielewski
http://wpkg.org
