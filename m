Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:52905 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbbIYNwM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:52:12 -0400
Subject: Re: BTRFS as image store for KVM?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Rich Freeman <r-btrfs@thefreemanclan.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
 <56054665.1020608@gmail.com>
Cc: Gert Menke <gert@menke.ac>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Jim Salter <jim@jrs-s.net>
Message-ID: <5605518B.2020103@jrs-s.net>
Date: Fri, 25 Sep 2015 09:52:11 -0400
MIME-Version: 1.0
In-Reply-To: <56054665.1020608@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pretty much bog-standard, as ZFS goes.  Nothing different than what's 
recommended for any generic ZFS use.

* set blocksize to match hardware blocksize - 4K drives get 4K 
blocksize, 8K drives get 8K blocksize (Samsung SSDs)
* LZO compression is a win.  But it's not like anything sucks without 
it.  No real impact on performance for most use, + or -. Just saves space.
* > 4GB allocated to the ARC.  General rule of thumb: half the RAM 
belongs to the host (which is mostly ARC), half belongs to the guests.

I strongly prefer pool-of-mirrors topology, but nothing crazy happens if 
you use striped-with-parity instead.  I use to use RAIDZ1 (the rough 
equivalent of RAID5) quite frequently, and there wasn't anything 
amazingly sucky about it; it performed at least as well as you'd expect 
ext4 on mdraid5 to perform.

ZFS might or might not do a better job of managing fragmentation; I 
really don't know.  I strongly suspect the design difference between the 
kernel's simple FIFO page cache and ZFS' weighted cache makes a really, 
really big difference.



On 09/25/2015 09:04 AM, Austin S Hemmelgarn wrote:
 > you really need to give specifics on how you have ZFS set up in that 
case.

