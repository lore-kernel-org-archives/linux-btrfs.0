Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.linuxsystems.it ([2.119.245.46]:33242 "EHLO
	mail2.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbcEFLi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 May 2016 07:38:28 -0400
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: btrfs ate my data in just two days, after a fresh install. ram =?iso-8859-1?Q?and_disk_are_ok._it_still_mounts,_but_I_cannot_repair?=
Date: Fri, 06 May 2016 13:38:20 +0200
MIME-Version: 1.0
Message-ID: <585760e0-7d18-4fa0-9974-62a3d7561aee@linuxsystems.it>
In-Reply-To: <20160505174854.GA1012@vader.dhcp.thefacebook.com>
References: <3bf4a554-e3b8-44e2-b8e7-d08889dcffed@linuxsystems.it>
 <CAJCQCtRAqxREr8ToorSkbsnYKKk_NPy+1oSHP6WMOnpLe=9T1g@mail.gmail.com>
 <c9bde2c9-c0f3-4bd2-a9ac-81fe0250edcc@linuxsystems.it>
 <20160505174854.GA1012@vader.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I formatted the partition and copied the content of my previous rootfs to 
it. There is no dmcrypt now and mount options are defaults, except for 
noatime. After a single boot I got the very same problem as before (fs 
corrupted and an infinite loop when doing btrfs check --repair.

I wanted to replicate results and so I tried once again and since then I 
only experienced minor corruption, correctly resolved by repair. But during 
a pacaman upgrade, which triggered snapper pre-post snapshots, the system 
hanged and I found this in the logs:

mag 06 10:31:15 arch-laptop plasmashell[873]: requesting unexisting screen 
2
mag 06 10:31:18 arch-laptop dbus[418]: [system] Activating service 
name='org.opensuse.Snapper' (using servicehelper)
mag 06 10:31:18 arch-laptop dbus[418]: [system] Successfully activated 
service 'org.opensuse.Snapper'
mag 06 10:31:20 arch-laptop kernel: ------------[ cut here ]------------
mag 06 10:31:20 arch-laptop kernel: kernel BUG at fs/btrfs/ctree.h:2693!

Still no major corruption found since my second attempt.

Niccolò
