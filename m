Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39830 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S934880Ab3IDOIN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Sep 2013 10:08:13 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Btrfs prog
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130904133207.GC6389@carfax.org.uk>
Date: Wed, 4 Sep 2013 16:08:06 +0200
Cc: Giuseppe Fierro <giuseppe@fierro.org>, linux-btrfs@vger.kernel.org
Message-Id: <5144EC24-48E9-4AC9-8005-F0A3FA18164A@colorremedies.com>
References: <CAN3gubkkb5jKPddRcDVBqr=r7c6_jFP6-hMaiWQ4mie6Fk90pA@mail.gmail.com> <20130904133207.GC6389@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 4, 2013, at 3:32 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

>> If I would like to show the subvolume, i get
>> 
>>> gspe@jura:/mnt$ sudo btrfs subvolume list /
>>> gspe@jura:/mnt$
>> 
>> nothing is shown!!!
> 
>   Try using the -a option. It got added a while ago, and has been a
> complete pain in the neck ever since…

What does -a do?

I recall with older versions of btrfs-progs that if a subvolume was mounted, btrfs subvol list would only list subvolumes under the one that was mounted, not all subvolumes on the volume. I just tried this with btrfs-progs-0.20.rc1.20130501git7854c8b-4.fc20.x86_64 without -a option, but with a subvolume mounted and the command lists all subvolumes.

OK now I'm seeing the behavior is sometimes wrong.

[root@f19v ~]# btrfs subvolume create /mnt/cookies
Create subvolume '/mnt/cookies'
[root@f19v ~]# btrfs subvolume create /mnt/chips
Create subvolume '/mnt/chips'
[root@f19v ~]# btrfs subvolume create /mnt/nuts
Create subvolume '/mnt/nuts'
[root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew
Create subvolume '/mnt/nuts/cashew'
[root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew
ERROR: '/mnt/nuts/cashew' exists
[root@f19v ~]# btrfs subvolume create /mnt/nuts/cashew/small
Create subvolume '/mnt/nuts/cashew/small'
[root@f19v ~]# umount /mnt
[root@f19v ~]# mount -o subvol=nuts/cashew /dev/sdb /mnt
[root@f19v ~]# btrfs subvolume list /mnt
ID 256 gen 5 top level 5 path cookies
ID 258 gen 10 top level 5 path chips
ID 259 gen 12 top level 5 path nuts
ID 260 gen 13 top level 5 path nuts/cashew
ID 261 gen 13 top level 260 path small


The last one should be /nuts/cashew/small. Or the one before it should be cashew instead of nuts/cashew.


Chris Murphy


