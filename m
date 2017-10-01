Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:37685 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdJAHty (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Oct 2017 03:49:54 -0400
Received: by mail-lf0-f67.google.com with SMTP id q132so1006643lfe.4
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Oct 2017 00:49:53 -0700 (PDT)
Subject: Re: What means "top level" in "btrfs subvolume list" ?
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <bdd9af61-b408-c8d2-6697-84230b0bcf89@gmail.com>
Date: Sun, 1 Oct 2017 10:49:50 +0300
MIME-Version: 1.0
In-Reply-To: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

30.09.2017 14:57, Goffredo Baroncelli пишет:
> (please ignore my previous email, because I wrote somewhere "top id" instead of "top level")
> Hi All,
> 
> I am trying to figure out which means "top level" in the output of "btrfs sub list"
> 
> 

Digging in git history - "top level" originally meant "subvolume where
path starts". Apparently original code allowed for "detached" roots not
present in tree of roots (deleted subvolume?)

> ghigo@venice:~$ sudo btrfs sub list /
> [sudo] password for ghigo: 
> ID 257 gen 548185 top level 5 path debian
> ID 289 gen 418851 top level 257 path var/lib/machine> ID 299 gen 537230 top level 5 path boot
> ID 532 gen 502364 top level 257 path tmp/test1
> ID 533 gen 502277 top level 532 path tmp/test1/test2
> ID 534 gen 502407 top level 257 path tmp/test1.snap
> ID 535 gen 502363 top level 532 path tmp/test1/test3
> ID 536 gen 502407 top level 257 path tmp/test1.snap2
> ID 537 gen 537132 top level 5 path test
> ID 538 gen 537130 top level 537 path test/sub1
> 
> The root filesystem is mounted as
> 
> mount -o subvol=debian ....
> 
> 
> I think that "btrfs sub list" is buggy, and it outputs a "top level ID" equal to the "parent ID" (on the basis of the code).

Yes, apparently this was (unintentionally?) changed by commit
4f5ebb3ef55396ef976d3245e2cdf9860680df74 which also apparently changed
semantic of -o option - before this commit resolve_root() would produce
subvolume path relative to given top_id; after this commit path is
always relative to filesystem root.

Moreover, this fix by itself is buggy. It sets "top level" to immediate
parent, but option -o will setup filter by top_id, which means that only
immediate subvolumes be listed. To illustrate:

bor@10:~> /usr/sbin/btrfs sub cre tsub
Create subvolume './tsub'
bor@10:~> /usr/sbin/btrfs sub cre tsub/sub1
Create subvolume 'tsub/sub1'
bor@10:~> /usr/sbin/btrfs sub cre tsub/sub2
Create subvolume 'tsub/sub2'
bor@10:~> sudo btrfs sub li -p -o tsub
ID 346 gen 1960 parent 345 top level 345 path @/home/bor/tsub/sub1
ID 347 gen 1961 parent 345 top level 345 path @/home/bor/tsub/sub2
bor@10:~> /usr/sbin/btrfs sub cre tsub/sub1/subsub1
Create subvolume 'tsub/sub1/subsub1'
bor@10:~> /usr/sbin/btrfs sub cre tsub/sub2/subsub2
Create subvolume 'tsub/sub2/subsub2'
bor@10:~> sudo btrfs sub li -p -o tsub
ID 346 gen 1965 parent 345 top level 345 path @/home/bor/tsub/sub1
ID 347 gen 1966 parent 345 top level 345 path @/home/bor/tsub/sub2

it misses nested subvolumes.

> But I am still asking which would be the RIGHT "top level id". My Hypothesis, it should be the ID of the root subvolume ( or 5 if it is not mounted).

To remind - "top level" was intended as "subvolume to which shown path
is relative".

Given that the code now will fail (return -ENOENT) for detached root,
the only possible output can be 5. Except the controversial case of
"-o". Going back to original behavior is probably going to break some
scripts now.

But again, at this point we may have scripts that rely on current "top
level" semantic. The change was there for how much ... 3 and half years.

But documenting it in manual page would be good.

> So the output should be
> 
>  
> ghigo@venice:~$ sudo btrfs sub list /
> [sudo] password for ghigo: 
> ID 257 gen 548185 top level 5 path debian
> ID 289 gen 418851 top level 257 path var/lib/machines
> ID 299 gen 537230 top level 5 path boot
> ID 532 gen 502364 top level 257 path tmp/test1
> ID 533 gen 502277 top level 257 path tmp/test1/test2
> ID 534 gen 502407 top level 257 path tmp/test1.snap
> ID 535 gen 502363 top level 257 path tmp/test1/test3
> ID 536 gen 502407 top level 257 path tmp/test1.snap2
> ID 537 gen 537132 top level 5 path test
> ID 538 gen 537130 top level 5 path test/sub1
> 
> 
> The subvolumes in the file system (mounted from /debian) are
> 
> /				ID = 5
> /debian				ID = 257
> /debian/var/lib/machines	ID = 289
> /boot				ID = 299
> /debian/tmp/test1		ID = 532
> /debian/tmp/test1/test2		ID = 533
> /debian/tmp/test1.snap		ID = 534
> /debian/tmp/test1/test3		ID = 535
> /debian/tmp/test1.snap2		ID = 536
> /test				ID = 537
> /test/sub1			ID = 538
> 
> BR
> G.Baroncelli
> 

