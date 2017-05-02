Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47970 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750825AbdEBDXw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 23:23:52 -0400
Date: Mon, 1 May 2017 20:23:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, fdmanana@suse.com, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Message-ID: <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for the reply, much appreciated.

On Mon, May 01, 2017 at 07:50:22PM -0600, Chris Murphy wrote:
> What about btfs check (no repair), without and then also with --mode=lowmem?
> 
> In theory I like the idea of a 24 hour rollback; but in normal usage
> Btrfs will eventually free up space containing stale and no longer
> necessary metadata. Like the chunk tree, it's always changing, so you
> get to a point, even with snapshots, that the old state of that tree
> is just - gone. A snapshot of an fs tree does not make the chunk tree
> frozen in time.
 
Right, of course, I was being way over optimistic here. I kind of forgot
that metadata wasn't COW, my bad.

> In any case, it's a big problem in my mind if no existing tools can
> fix a file system of this size. So before making anymore changes, make
> sure you have a btrfs-image somewhere, even if it's huge. The offline
> checker needs to be able to repair it, right now it's all we have for
> such a case.

The image will be huge, and take maybe 24H to make (last time it took
some silly amount of time like that), and honestly I'm not sure how
useful it'll be.
Outside of the kernel crashing if I do a btrfs balance, and hopefully
the crash report I gave is good enough, the state I'm in is not btrfs'
fault.

If I can't roll back to a reasonably working state, with data loss of a
known quantity that I can recover from backup, I'll have to destroy and
filesystem and recover from scratch, which will take multiple days.
Since I can't wait too long before getting back to a working state, I
think I'm going to try btrfs check --repair after a scrub to get a list
of all the pathanmes/inodes that are known to be damaged, and work from
there.
Sounds reasonable?

Also, how is --mode=lowmem being useful?

And for re-parenting a sub-subvolume, is that possible?
(I want to delete /sub1/ but I can't because I have /sub1/sub2 that's also a subvolume
and I'm not sure how to re-parent sub2 to somewhere else so that I can subvolume delete
sub1)

In the meantime, a simple check without repair looks like this. It will
likely take many hours to complete:
gargamel:/var/local/space# btrfs check /dev/mapper/dshelf2
Checking filesystem on /dev/mapper/dshelf2
UUID: 03e9a50c-1ae6-4782-ab9c-5f310a98e653
checking extents
checksum verify failed on 3096461459456 found 0E6B7980 wanted FBE5477A
checksum verify failed on 3096461459456 found 0E6B7980 wanted FBE5477A
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
parent transid verify failed on 1671538819072 wanted 293964 found 293902
parent transid verify failed on 1671538819072 wanted 293964 found 293902
checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
checksum verify failed on 1759425052672 found 843B59F1 wanted F0FF7D00
checksum verify failed on 1759425052672 found 843B59F1 wanted F0FF7D00
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2898779357184 found 96395131 wanted 433D6E09
checksum verify failed on 2898779357184 found 96395131 wanted 433D6E09
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
bytenr mismatch, want=2899180224512, have=3981076597540270796
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
(...)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
