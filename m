Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39186 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcBNR1X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Feb 2016 12:27:23 -0500
Date: Sun, 14 Feb 2016 09:26:59 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-image failure (btrfs-tools 4.4)
Message-ID: <20160214172659.GD4115@merlins.org>
References: <20160123170354.GA10113@merlins.org> <56A57C59.1040203@cn.fujitsu.com> <20160125205500.GK23751@merlins.org> <56A6C5CB.5060406@cn.fujitsu.com> <20160211063132.GX13969@merlins.org> <56BC355F.1080305@cn.fujitsu.com> <20160211150947.GY13969@merlins.org> <20160211151339.GZ13969@merlins.org> <56BD2847.8070403@cn.fujitsu.com> <20160212172628.GJ2763@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160212172628.GJ2763@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2016 at 09:26:28AM -0800, Marc MERLIN wrote:
> On Fri, Feb 12, 2016 at 08:33:11AM +0800, Qu Wenruo wrote:
> > There is still a last chance.
> > 
> > If btrfsck still report original error about "bad file extent" in root: 
> >  45851/45852/...
> > Btrfs-debug-tree may provide useful info by dumping only that root.
> > 
> > # btrfs-debug-tree -t 45851
> > 
> > But the problem is, there is no filename fuzz option.
> > You need to mask all the filenames in INODE_REF/DIR_ITEM/DIR_INDEX by 
> > script, or just grep the affected inode info following the pattern "key 
> > (<INODE_NUM>".
> > 
> > At least this should tell us what's the problem and we can check 
> > manually to determine if it's fixable.
> 
> Mmmh, so the fsck is looking a bit worse now, here is the output:
> http://marc.merlins.org/tmp/ggm-broken-ds1-fsck.txt
> 
> I'm not super sure what inode I should use for debug tree. Can you suggest
> one?
> 
> I ran the dump 
> gargamel:~# btrfs-image -s -c 9 /dev/mapper/dshelf1old
> /mnt/dshelf1/ds1old.dump
> Error adding space cache blocks -5
> Error flushing pending -5
> create failed (Success)
> 
> and a du every so often showed the file go to 9.3GB before btrfs-image
> deleted it:
> 9.3G    /mnt/dshelf1/ds1old.dump

So I'm at a point where I need to delete this filesystem. I believe it'll be
monday morning soon on your side of the world :) 
Can you let me know if there is anything else I can/should get before I wipe
it?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
