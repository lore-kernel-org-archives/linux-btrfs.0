From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: read error: how to fix?
Date: 18 Oct 2011 17:33:00 +0200
Message-ID: <Bw4cYUfy1uB@helmut.hullen.de>
References: <1318793530.2588.28.camel@nayuki.kepstin.ca>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1318793530.2588.28.camel@nayuki.kepstin.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 16.10.11:


[...]

> If you have pending sectors, causing the drive to reallocate them is
> very simple. Write data (any data) over the sector in question - the
> drive will then remap it onto the spare area to do the write. (The
> easiest way is to do something like dd if=/dev/zero of=/dev/sdX; but
> if you know the exact sector number, "hdparm --write-sector" can
> remap it quickly.)

I have to try in the next days ...

> Keep in mind, though - if you have a single reallocated sector on a
> drive, it means that the drive medium is deteriorating. It's very
> likely that you will have additional failures in the future,
> resulting in more IO errors and lost data. For your sanity, I
> recommend replacing a drive as soon as you see any one error on it.

Actually "dd if=/dev/sdg of=/dev/zero " tells (in "/var/log/warn")  
strange things like

Oct 18 14:42:48 Arktur kernel: Buffer I/O error on device sdg, logical block 29792786
Oct 18 14:42:48 Arktur kernel: Buffer I/O error on device sdg, logical block 29792787
Oct 18 14:43:04 Arktur kernel: end_request: I/O error, dev sdg, sector 238342224
Oct 18 14:43:04 Arktur kernel: Buffer I/O error on device sdg, logical block 29792778
Oct 18 14:43:20 Arktur kernel: end_request: I/O error, dev sdg, sector 238342224
Oct 18 14:43:20 Arktur kernel: Buffer I/O error on device sdg, logical block 29792778

-------------------------

>From yesterday to this morning the number of offline uncorrectable has  
grown from 25 to 26 - no good omen.

Maybe there are some files damaged - the disk is filled with about 1.4  
TByte, it's part of a btrfs cluster with more than 4 TByte data.

What about "btrfsck" - can it help? Or may it lead to one more crash?

When I try to copy the whole cluster to another place (I had this  
problem some days ago) then the system crashes when it tries to access  
that special file that uses such a defect sector. When I can first  
detect the name of this file and then exclude it from copying then "cp"  
works.

Nice problems ...

Viele Gruesse!
Helmut
