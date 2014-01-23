Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaAWMuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 07:50:35 -0500
Date: Thu, 23 Jan 2014 13:50:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Giorgos Pallas <gpall@ccf.auth.gr>, 736227@bugs.debian.org,
        linux-btrfs@vger.kernel.org
Subject: Re: Bug#736227: linux-headers-3.12-1-amd64: general protection fault
 when using aptitude
Message-ID: <20140123125032.GL6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140121090046.25804.36940.reportbug@localhost>
 <1390456022.3651.143.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390456022.3651.143.camel@deadeye.wl.decadent.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 23, 2014 at 05:47:02AM +0000, Ben Hutchings wrote:
> I'm sending this on to the btrfs developers to see if they can help.
> 
> On Tue, 2014-01-21 at 11:00 +0200, Giorgos Pallas wrote:
> [...]
> > I just installed 3.12-amd64 stock kernel. It booted OK, I opened a konsole
> > and just tried to installed the kernel headers.  Just as aptitude tried to
> > start downloading packages, I got:
> > E: Method http has died unexpectedly!
> > E: Sub-process http received a segmentation fault.
> > and btrfs has crashed as seen in dmesg.
> > 
> > It should be noted that I use btrfs without problems with 3.7-trunk-amd64
> > for almost a year.
> [...]
> 
> > [  322.369569] RIP: 0010:[<ffffffff812713e2>]  [<ffffffff812713e2>] memcpy+0x12/0x110
> > [  322.370085] Call Trace:
> > [  322.370119]  [<ffffffffa034a568>] ? read_extent_buffer+0xc8/0x120 [btrfs]
> > [  322.370164]  [<ffffffffa032f510>] ? btrfs_get_extent+0x910/0x990 [btrfs]
> > [  322.370214]  [<ffffffffa03469b8>] ? __do_readpage+0x398/0x780 [btrfs]
> > [  322.370256]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [btrfs]
> > [  322.370307]  [<ffffffffa0347142>] ? __extent_readpages.constprop.43+0x2d2/0x2f0 [btrfs]
> > [  322.370355]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [btrfs]
> > [  322.370406]  [<ffffffffa0348de2>] ? extent_readpages+0x182/0x190 [btrfs]
> > [  322.370457]  [<ffffffffa032ec00>] ? btrfs_real_readdir+0x550/0x550 [btrfs]
> > [  322.370499]  [<ffffffff8115ba6b>] ? kmem_getpages+0x15b/0x1a0
> > [  322.370527]  [<ffffffff811554ad>] ? alloc_pages_current+0x9d/0x160
> > [  322.370565]  [<ffffffff8111dbc3>] ? __do_page_cache_readahead+0x193/0x240
> > [  322.370598]  [<ffffffff8111e07a>] ? ondemand_readahead+0x14a/0x280
> > [  322.370636]  [<ffffffff81113986>] ? generic_file_aio_read+0x4a6/0x6f0
> > [  322.370668]  [<ffffffff81172a07>] ? do_sync_read+0x57/0x90
> > [  322.370701]  [<ffffffff81172f94>] ? vfs_read+0x94/0x160
> > [  322.370726]  [<ffffffff81173a83>] ? SyS_read+0x43/0xa0
> > [  322.370759]  [<ffffffff81499b39>] ? system_call_fastpath+0x16/0x1b

Known issue, a patch will be ready soon

https://bugzilla.kernel.org/show_bug.cgi?id=68411
