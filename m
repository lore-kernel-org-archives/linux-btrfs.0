Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:60738 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753057AbdBNPze (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 10:55:34 -0500
Date: Tue, 14 Feb 2017 20:55:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unexpected behavior involving file attributes and snapshots.
Message-ID: <20170214205531.15b5b2f3@natsu>
In-Reply-To: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
References: <ea92c7c6-4b98-d683-eb66-593836bcc82a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 14 Feb 2017 10:30:43 -0500
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> I was just experimenting with snapshots on 4.9.0, and came across some 
> unexpected behavior.
> 
> The simple explanation is that if you snapshot a subvolume, any files in 
> the subvolume that have the NOCOW attribute will not have that attribute 
> in the snapshot.  Some further testing indicates that this is the only 
> file attribute that isn't preserved (I checked all the chattr flags that 
> BTRFS supports).
> 
> I'm kind of curious whether:
> 1. This is actually documented somewhere, as it's somewhat unexpected 
> given that everything else is preserved when snapshotting.
> 2. This is intended behavior, or just happens to be a side effect of the 
> implementation.

I don't seem to get this on 4.4.45 and 4.4.47.

$ btrfs sub create test
Create subvolume './test'
$ touch test/abc
$ chattr +C test/abc 
$ echo def > test/abc
$ ls -la test/abc 
-rw-r--r-- 1 rm rm 4 Feb 14 20:52 test/abc
$ lsattr test/abc 
---------------C test/abc
$ btrfs sub snap test test2
Create a snapshot of 'test' in './test2'
$ ls -la test2/abc 
-rw-r--r-- 1 rm rm 4 Feb 14 20:52 test2/abc
$ lsattr test2/abc 
---------------C test2/abc

-- 
With respect,
Roman
