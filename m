Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41624 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753425AbdDQSIU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 14:08:20 -0400
Date: Mon, 17 Apr 2017 11:07:07 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: compressing nocow files
Message-ID: <20170417180707.GA3856@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 11:36:17AM -0600, Chris Murphy wrote:
> HI,
> 
> 
> /dev/nvme0n1p8 on / type btrfs
> (rw,relatime,seclabel,ssd,space_cache,subvolid=258,subvol=/root)
> 
> I've got a test folder with +C set and then copied a test file into it.
> 
> $ lsattr
> ----------------C--
> ./system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
> 
> So now it's inherited +C. Next check fragments and compression.
> 
> $ sudo ~/Applications/btrfs-debugfs -f
> system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
> (290662 0): ram 100663296 disk 17200840704 disk_size 100663296
> file: system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
> extents 1 disk size 100663296 logical size 100663296 ratio 1.00
> 
> 
> Try to compress it.
> 
> $ sudo btrfs fi defrag -c
> system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
> 
> Check again.
> 
> [snip faux fragments]
> file: system@2547b430ecdc441c9cf82569eeb22065-0000000000000001-00054c3c31bec567.journal
> extents 768 disk size 21504000 logical size 100663296 ratio 4.68
> 
> It's compressed! OK??
> 
> OK delete that file, and add +c to the temp folder.
> 
> $ lsattr
> --------c-------C-- ./temp
> 
> Copy another test file into temp.
> 
> $ lsattr
> --------c-------C--
> ./system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
> 
> $ sudo ~/Applications/btrfs-debugfs -f
> system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
> (290739 0): ram 83886080 disk 21764243456 disk_size 83886080
> file: system@2547b430ecdc441c9cf82569eeb22065-000000000002eb9f-00054d4ebb44b135.journal
> extents 1 disk size 83886080 logical size 83886080 ratio 1.00
> 
> Not compressed. Hmmm. So somehow btrfs fi defrag -c will force
> compression even on nocow files? I've also done this without -c
> option, with a Btrfs mounted using compress option; and the file does
> compress also. I thought nocow files were always no compress, but it
> seems there's exceptions.
>

Good catch.

Btrfs defragment depends on COW to do the job, thus nocow inode are forced to
COW when processing defraged range, and the compress also depends on COW, so
btrfs filesystem defrag -c becomes an exception.

Speaking of which, this exception seems to be not harmful other than confusing
users.

Thanks,

-liubo
