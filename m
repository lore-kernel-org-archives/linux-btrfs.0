Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:34379 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965427AbcALPYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 10:24:32 -0500
From: Geliang Tang <geliangtang@163.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: Geliang Tang <geliangtang@163.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [kdave:misc-cleanups-4.5 9/9] fs/btrfs/backref.c:565:1-20: iterator with update on line 577
Date: Tue, 12 Jan 2016 23:23:15 +0800
Message-Id: <cover.1452611741.git.geliangtang@163.com>
In-Reply-To: <alpine.DEB.2.02.1601120706340.2042@localhost6.localdomain6>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2016 at 07:07:24AM +0100, Julia Lawall wrote:
> I really have no idea if this is safe or not.
> 
> julia
> 
> On Tue, 12 Jan 2016, kbuild test robot wrote:
> 
> > CC: kbuild-all@01.org
> > TO: Geliang Tang <geliangtang@163.com>
> > CC: David Sterba <dsterba@suse.com>
> > 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux misc-cleanups-4.5
> > head:   a7ca42256d9fad572fb7f2c471514d7d3572b1db
> > commit: a7ca42256d9fad572fb7f2c471514d7d3572b1db [9/9] btrfs: use list_for_each_entry* in backref.c
> > :::::: branch date: 5 days ago
> > :::::: commit date: 5 days ago
> > 
> > >> fs/btrfs/backref.c:565:1-20: iterator with update on line 577

Sorry for the trouble caused. It's probably unsafe. I updated my patch
to fix this problem.

- Geliang

Geliang Tang (1):
  btrfs: use list_for_each_entry* in backref.c

 fs/btrfs/backref.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

-- 
2.5.0


