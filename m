Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:59275 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3JVQEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:04:24 -0400
Date: Wed, 23 Oct 2013 01:04:11 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1543 at fs/btrfs/ctree.c:1322
 btrfs_search_old_slot+0x338/0x81d [btrfs]()
Message-ID: <20131023010411.42d30c97@virtall.com>
In-Reply-To: <20131022154619.GW1032@twin.jikos.cz>
References: <20131021122123.43b3aa50@virtall.com>
	<20131021151032.708cc7d2@virtall.com>
	<20131021125317.GK1032@twin.jikos.cz>
	<20131022025025.169941de@virtall.com>
	<20131022154619.GW1032@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 22 Oct 2013 17:46:19 +0200
David Sterba <dsterba@suse.cz> wrote:

> On Tue, Oct 22, 2013 at 02:50:25AM +0900, Tomasz Chmielewski wrote:
> > I'm getting these every few seconds when running scrub - expected?
> 
> The system probably locked up again due to the corrupted data. Looking
> at the stacktraces again, this is due to a BUG_ON in
> btrfs_merge_bio_hook, and it does not look like an easy one to fix.
> 
> The filesystem is damaged, but we don't know to what extent. It's
> possible that 'btrfs restore' will be able to get to the data.

Actually it's still working.

If I run this:

# btrfs scrub status /mnt/lxc1
scrub status for 8d08ad6d-4543-4fe5-8b1b-640dc1423d41
        scrub started at Tue Oct 22 09:53:34 2013, running for 22101 seconds
        total bytes scrubbed: 2.61TB with 0 errors


the number of bytes scrubbed is growing every now and then (still, 0 errors).


However, it's not possible to work with this system via SSH, because these keep popping up few times every minute:

Message from syslogd@bkp010 at Oct 22 16:02:10 ...
 kernel:[22219.117012] BUG: soft lockup - CPU#2 stuck for 23s! [btrfs:5673]

Message from syslogd@bkp010 at Oct 22 16:02:38 ...
 kernel:[22247.100515] BUG: soft lockup - CPU#0 stuck for 23s! [btrfs:5674]

Message from syslogd@bkp010 at Oct 22 16:02:38 ...
 kernel:[22247.100519] BUG: soft lockup - CPU#2 stuck for 23s! [btrfs:5673]


Will wait to see if it finishes or if it locks up at some point.

-- 
Tomasz Chmielewski
http://wpkg.org
