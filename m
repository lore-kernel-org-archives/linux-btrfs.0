Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbbGWMDA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 08:03:00 -0400
Date: Thu, 23 Jul 2015 14:02:49 +0200
From: David Sterba <dsterba@suse.com>
To: Suman Chakravartula <suman@rockstor.com>
Cc: clm@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs progs release 4.1.2 (urgent fix, do not use 4.1.1)
Message-ID: <20150723120249.GR6306@suse.cz>
Reply-To: dsterba@suse.com
References: <20150714120603.GH15535@twin.jikos.cz>
 <CAPF83mvVws5EK16ooozog7rzgciXVQ5TtvtTb2Sq5NdEnas=jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPF83mvVws5EK16ooozog7rzgciXVQ5TtvtTb2Sq5NdEnas=jw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 19, 2015 at 07:07:40PM -0700, Suman Chakravartula wrote:
> We are using 4.1 progs and 4.1 kernel on Rockstor currently and what I
> see is that btrfs check says device is not currently mounted. Is 4.1
> effected? Do you recommend we update to 4.1.2 anyway?
> 
> [root@RockStor ~]# btrfs fi show testpool; mount | grep testpool;
> btrfs check /dev/sdaa; btrfs check /dev/sdab
> Label: 'testpool'  uuid: ed600942-f300-4a01-aa49-6b0ab6c0b8f9
> Total devices 2 FS bytes used 3.69GiB
> devid    1 size 2.00GiB used 2.00GiB path /dev/sdaa
> devid    2 size 2.00GiB used 2.00GiB path /dev/sdab
> 
> btrfs-progs v4.1
> /dev/sdaa on /mnt2/testpool type btrfs (rw,relatime,space_cache)
> /dev/sdac on /mnt2/testpool2 type btrfs (rw,relatime,space_cache)
> /dev/sdaa is currently mounted. Aborting.
> /dev/sdab is currently mounted. Aborting.

I'm not sure I understand. Fsck refuses to work on mounted filesystems
and there was no change in the 4.1.x releases. I'd recommend to update
to 4.1.2 but it's not required if 4.1 works for you or you haven't hit a
specific bug that 4.1.x fixes.
