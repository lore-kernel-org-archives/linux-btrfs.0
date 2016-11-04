Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34484 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759208AbcKDIBU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 04:01:20 -0400
Date: Fri, 4 Nov 2016 01:01:13 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161104080113.GG3529@merlins.org>
References: <20161031054719.GN28648@merlins.org> <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com> <20161031062509.GO28648@merlins.org> <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com> <20161031063737.GP28648@merlins.org> <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com> <20161031084412.GI16645@carfax.org.uk> <20161031150422.GQ28648@merlins.org> <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com> <20161101042140.atn73lqehgpqslgz@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20161101042140.atn73lqehgpqslgz@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 09:21:40PM -0700, Marc MERLIN wrote:
> On Tue, Nov 01, 2016 at 12:13:38PM +0800, Qu Wenruo wrote:
> > Would you try to locate the range where we starts to fail to read?
> > 
> > I still think the root problem is we failed to read the device in user
> > space.
>  
> Understood.
> 
> I'll run this then:
> myth:~# dd if=/dev/mapper/crypt_bcache0 of=/dev/null bs=1M &
> [2] 21108
> myth:~# while :; do killall -USR1 dd; sleep 1200; done
> 275+0 records in
> 274+0 records out
> 287309824 bytes (287 MB) copied, 7.20248 s, 39.9 MB/s
> 
> This will take a while to run, I'll report back on how far it goes.

Well, turns out you were right. My array is 14TB and dd was only able to
copy 8.8TB out of it.

I wonder if it's a bug with bcache and source devices that are too big?

8782434271232 bytes (8.8 TB) copied, 214809 s, 40.9 MB/s
dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
8388608+0 records in
8388608+0 records out
8796093022208 bytes (8.8 TB) copied, 215197 s, 40.9 MB/s
[2]+  Exit 1                  dd if=/dev/mapper/crypt_bcache0 of=/dev/null bs=1M

What's vexing is that absolutely nothing has been logged in the kernel dmesg
buffer about this read error.

Basically I have this:
sde                            8:64   0   3.7T  0 
└─sde1                         8:65   0   3.7T  0 
  └─md5                        9:5    0  14.6T  0 
    └─bcache0                252:0    0  14.6T  0 
      └─crypt_bcache0 (dm-0) 253:0    0  14.6T  0 

I'll try dd'ing the md5 directly now, but that's going to take another 2 days :(

That said, given that almost half the device is not readable from user space
for some reason, that would explain why btrfs check is failing. Obviously it
can't do its job if it can't read blocks.

I'll report back on what I find out with this problem but if you have
suggestions on what to look for, let me know :)

Thanks.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
