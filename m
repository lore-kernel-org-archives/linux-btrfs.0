Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57060 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760305AbcJaGhi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 02:37:38 -0400
Date: Sun, 30 Oct 2016 23:37:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161031063737.GP28648@merlins.org>
References: <20161030183437.GA3287@merlins.org> <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com> <20161031020616.GH28648@merlins.org> <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com> <20161031054719.GN28648@merlins.org> <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com> <20161031062509.GO28648@merlins.org> <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 02:32:53PM +0800, Qu Wenruo wrote:
> 
> 
> At 10/31/2016 02:25 PM, Marc MERLIN wrote:
> >On Mon, Oct 31, 2016 at 02:04:10PM +0800, Qu Wenruo wrote:
> >>>Sorry for asking, am I doing this wrong?
> >>>myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
> >>>skip=26367830208
> >>>dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> >>>0+0 records in
> >>>0+0 records out
> >>>0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s
> >>
> >>So, the underlying MD RAID5 are complaining about some wrong data, and
> >>refuse to read out.
> >>
> >>It seems that btrfs-progs can't handle read failure?
> >>Maybe dm-error could emulate it.
> >>
> >>And what about the 2nd range?
> >
> >they both fail the same, but I wasn' tsure if I typed the wrong dd command
> >or not.
> 
> Strange, your command seems OK to me.
> 
> Does it has anything to do with your security setup or something like that?
> Or is it related to dm-crypt or bcache?
> 
> 
> But this reminds me, if dd can't read it, maybe btrfs-progs is the same.
> 
> Maybe only kernel can read dm-crypt device while user space tools can't 
> access dm-crypt devices directly?

It can, it's just the offset seems wrong:

myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830208
dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000421662 s, 0.0 kB/s

If I divide by 1000, it works:
myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830
32+0 records in
32+0 records out
16384 bytes (16 kB) copied, 0.139005 s, 118 kB/s

so that's why I was asking you if I counted the offset wrong. I took the
value you asked and divided by 512, but it seems too big

13500329066496 / 512 = 26367830208

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
