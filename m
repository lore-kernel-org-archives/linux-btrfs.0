Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34654 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757359AbaIRVPk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 17:15:40 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with unmountable filesystem.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <541B1263.3090804@gmail.com>
Date: Thu, 18 Sep 2014 15:15:37 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <B391FCBE-479B-471A-A543-AAD7B44EF5BA@colorremedies.com>
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com> <22B49628-3659-4D83-BE99-A173CAFF23F9@colorremedies.com> <541B1263.3090804@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 18, 2014, at 11:12 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:

> On 09/17/2014 02:57 PM, Chris Murphy wrote:
>> 
>> On Sep 17, 2014, at 5:23 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
>>> 
>>> Thanks for all the help.
>> 
>> Well, it's not much help. It seems possible to "corrupt" a primary superblock that points to a corrupt tree root, and use btrfs rescure super-recover to replace it, and then mount should work. One thing I didn't try was corrupting the primary superblock and just mounting normally or with recovery, to see if it'll automatically ignore the primary superblock and use the backup.
>> 
>> But I think you're onto something, that a good superblock can point to a corrupt tree root, and then not have a straight forward way to mount the good tree root. If I understand this correctly.
>> 
> Corrupting the primary superblock did in fact work, and I decided to try
> mounting immediately, which failed.

I just tried corrupting primary superblock by overwriting the 4 bytes csum with zeros.
Normal mount = fail
[16576.124611] BTRFS: superblock checksum mismatch
[16576.141673] BTRFS: open_ctree failed

-o recovery = fail
[16595.532801] BTRFS: superblock checksum mismatch
[16595.547868] BTRFS: open_ctree failed

btrfs check = reports no problems
btrfs check --repair = reports no problems or fixes but does fix the problem

[root@f21v ~]# btrfs check --repair /dev/sdb
enabling repair mode
Checking filesystem on /dev/sdb
UUID: 9acf13de-5b98-4f28-9992-533e4a99d348
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 510612493 bytes used err is 0
total csum bytes: 864464
total tree bytes: 1576960
total fs tree bytes: 389120
total extent tree bytes: 163840
btree space waste bytes: 196561
file data blocks allocated: 885604352
 referenced 895991808
Btrfs v3.16


>  I didn't try with -o recovery, but
> I think that would probably fail as well.  Things worked perfectly
> however after using btrfs rescue super-recover.  As far as avoiding
> future problems, I think the best solution would be to have the mount
> operation try the tree root pointed to by the backup superblock if the
> one pointed to by the primary seems corrupted.

Right. I'm not understanding how you determined a tree root is corrupt. The mount code clearly knows it can't mount a corrupt tree root, but it's neither fixing this corruption nor falling back to another superblock to see if it points to a good tree root. It's beyond my expertise what comes after detecting the problem, which the code already does. Should it fix the problem? And if not, or if it can't, should it automatically fallback to a different tree root specified by a backup superblock? And if so how far back in generation should it go before asking for user intervention? Because it's possible, on say very large file systems with ssd mount option, that there could be 3 or 4 superblocks with different tree roots pointed to with different generations. We probably don't want to always go back up to 1.5 or 2 minutes to a different tree, rather than try to fix it if possible.



> 
> Secondarily, this almost makes me want to set the ssd option on all
> BTRFS filesystems, just to get the rotating superblock updates, because
> if it weren't for that behavior, I probably wouldn't have been able to
> recovery anything in this particular case.

It's a catch 22 in that what if you get a torn write on a superblock update but it pointed to a good tree root? A mirrored superblock would allow this to be fixed pretty easily. But rotating ones means you have to go to an older tree root, unless you somehow fix up the bad superblock with the pointer to the newest good tree root - could be tedious.

One day these multiple repair methods should merge, I'd think. There are a lot of different ways to fix a Btrfs right now.


Chris Murphy

