Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:36357 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbdIQIsM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 04:48:12 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9117629D2
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 10:48:10 +0200 (MEST)
Date: Sun, 17 Sep 2017 10:48:10 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: subvolume list as user?
Message-ID: <20170917084810.GP32347@rus.uni-stuttgart.de>
References: <20170916094504.GL32347@rus.uni-stuttgart.de>
 <684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
 <20170916143702.GO32347@rus.uni-stuttgart.de>
 <54b8bb4b-3807-15da-1db5-fab7b0ced253@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54b8bb4b-3807-15da-1db5-fab7b0ced253@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (22:56), Goffredo Baroncelli wrote:

>> how can a user get a list of his subvolumes? He may created them some
>> time ago and forget it. He now wants to have a list of them.
> 
> Far to be perfect, but this could help
> 
> find / -inum 256  2>/dev/null
> 
> each subvolume has inode number 256

But non-btrfs filesystems can also have an inode 256!
And it is terrible slow and inefficent.
Ok, I will add a sudo wrapper for my btrfs_subvolume_list :

#!/usr/bin/perl -w

$mounts = '/proc/mounts';
open $mounts,$mounts or die "$0: cannot open $mounts - $!\n";
while (<$mounts>) {
  if (m:^(/\S+) (/\S*) btrfs:) {
    push @bfs,$2;
  }
}
close $mounts;
if (@bfs) {
  @bfs = sort @bfs;
} else {
  die "$0: no mounted btrfs filesystems\n";
}

@sv = ();
foreach my $fs (@bfs) {
  push @sv,"$fs\n";
  open $fs,"btrfs subvolume list '$fs'|" or next;;
  while (<$fs>) {
    chomp;
    s:.* \d+ path :$fs/:;
    push @sv,"$_\n" if -d;
  }
  close $fs;
}

print sort @sv;


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<54b8bb4b-3807-15da-1db5-fab7b0ced253@libero.it>
