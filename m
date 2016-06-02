Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33541 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbcFBNzz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 09:55:55 -0400
Received: by mail-vk0-f42.google.com with SMTP id r140so71745969vkf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 06:55:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
	<CAEtw4r2hsCd1+bFNcXn_s5jj-8x6qer+x0gLx8wTgNi1=nAXhw@mail.gmail.com>
	<CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
	<CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
Date: Thu, 2 Jun 2016 15:55:54 +0200
Message-ID: <CAE8gLhkR4XzNx9tarhzD2LdsCRJ3e+BPcWYpE-qA4jnJsvSrLg@mail.gmail.com>
Subject: Re: "No space left on device" and balance doesn't work
From: MegaBrutal <megabrutal@gmail.com>
To: Henk Slager <eye1tm@gmail.com>
Cc: Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-06-02 0:22 GMT+02:00 Henk Slager <eye1tm@gmail.com>:
> What is the kernel version used?
> Is the fs on a mechanical disk or SSD?
> What are the mount options?
> How old is the fs?

Linux 4.4.0-22-generic (Ubuntu 16.04).
Mechanical disks in LVM.
Mount: /dev/mapper/centrevg-rootlv on / type btrfs
(rw,relatime,space_cache,subvolid=257,subvol=/@)
I don't know how to retrieve the exact FS age, but it was created in
2014 August.

Snapshots (their names encode their creation dates):

ID 908 gen 487349 top level 5 path @-snapshot-20160503000001
ID 909 gen 488849 top level 5 path @-snapshot-20160504000001
ID 910 gen 490313 top level 5 path @-snapshot-20160505000001
ID 911 gen 491763 top level 5 path @-snapshot-20160506000001
ID 912 gen 493399 top level 5 path @-snapshot-20160507000002
ID 913 gen 494996 top level 5 path @-snapshot-20160508000002
ID 914 gen 496495 top level 5 path @-snapshot-20160509000002
ID 915 gen 498094 top level 5 path @-snapshot-20160510000005
ID 916 gen 499688 top level 5 path @-snapshot-20160511000002
ID 917 gen 501308 top level 5 path @-snapshot-20160512000001
ID 918 gen 503375 top level 5 path @-snapshot-20160514000002
ID 919 gen 504356 top level 5 path @-snapshot-20160515000001
ID 920 gen 505890 top level 5 path @-snapshot-20160516000001
ID 921 gen 506901 top level 5 path @-snapshot-20160517000001
ID 922 gen 507313 top level 5 path @-snapshot-20160518000002
ID 923 gen 507712 top level 5 path @-snapshot-20160519000001
ID 924 gen 508057 top level 5 path @-snapshot-20160520000001
ID 925 gen 508882 top level 5 path @-snapshot-20160521000001
ID 926 gen 509241 top level 5 path @-snapshot-20160522000001
ID 927 gen 509618 top level 5 path @-snapshot-20160523000001
ID 928 gen 510277 top level 5 path @-snapshot-20160524000002
ID 929 gen 511357 top level 5 path @-snapshot-20160525000002
ID 930 gen 512125 top level 5 path @-snapshot-20160526000002
ID 931 gen 513292 top level 5 path @-snapshot-20160527000001
ID 932 gen 515766 top level 5 path @-snapshot-20160528000002
ID 933 gen 517349 top level 5 path @-snapshot-20160529000004
ID 934 gen 519004 top level 5 path @-snapshot-20160530000002
ID 935 gen 519500 top level 5 path @-snapshot-20160531000002
ID 936 gen 519847 top level 5 path @-snapshot-20160601000001
ID 937 gen 521829 top level 5 path @-snapshot-20160602000001

Removing old snapshots is the most feasible solution, but I can also
increase the FS size. It's easy since it's in LVM, and there is plenty
of space in the volume group.

Probably I should rewrite my alert script to check btrfs fi show
instead of plain df.
