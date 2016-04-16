Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17194 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbcDPAHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 20:07:20 -0400
Date: Fri, 15 Apr 2016 17:07:58 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG at fs/btrfs/inode.c:1828! RIP:
 btrfs_merge_bio_hook+0x8b/0xa0 [btrfs]
Message-ID: <20160416000758.GD7369@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJCQCtSKDunrKyU8+wmh8qLp9zEgP06Ej58Xj4_24PUk8v5Yqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSKDunrKyU8+wmh8qLp9zEgP06Ej58Xj4_24PUk8v5Yqg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 09:28:49AM -0600, Chris Murphy wrote:
> Note this is a testing VM, no user data is at risk
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=116331

>From the call stack we can tell that btrfs_root_bytenr() returns 0
somehow.  And this comes from btrfs_recover_relocation() reading
the root on which reloc_root is snapshoted, and it's not the FS tree,
might be a snapshot root or subvolume root.

Looks like our COW fails for that root.

Thanks,

-liubo
> 
> Gist is this is a new Btrfs file system, and while -o recovery,ro
> permits mount, it can't be repaired, and btrfs-image fails also. A
> normal mount results in a call trace, which is what the subject is set
> to, and the bug contains the complete dmesg for that.
> 
> File system starts as:
> openSUSE-Tumbleweed-GNOME-Live-x86_64-Snapshot20160307-Media.iso
> Creation time btrfs-progs 4.4.1, kernel 4.4.3.
> 
> Very light usage for several weeks, but includes scrubs and balance
> with no errors. Today, while using YaST2 to remove packages, there was
> a complete system hang. After 30 minutes I force quit the VM.
> Subsequent boots fail.
> 
> I then moved to booting Fedora 24 (prerelease) for troubleshooting, to
> use kernel 4.5.0 and progs 4.5.1.
> 
> mount fails/crashes, with trace
> mount -o recovery fails/crashes, with trace
> mount -o recovery,ro works (!) and I can dig up the journals from the
> YaST2 hang which includes some Btrfs csum errors, I think during the
> hang.
> 
> btrfs-image fails
> btrfs-debug-tree mostly works, the bug report contains a URL for that file
> 
> btrfs check --repair finds but doesn't fix the problem,
> --init-extent-tree crashes
> 
> So it's pretty messy fixing wise. But so far -o recovery,ro is letting
> me extract important things like the journal.
> 
> -- 
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
