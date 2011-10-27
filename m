From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: 27 Oct 2011 18:47:00 +0200
Message-ID: <Bwe3DvoT1uB@helmut.hullen.de>
References: <47bc8413b603ceebfb85404d10cdc5f3@www.jots.org>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <47bc8413b603ceebfb85404d10cdc5f3@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Ken,

Du meintest am 27.10.11:

> So, I dd'd everything back, and now it crashes on boot.  Booting to a
> 2.6.x kernel (which is what I had on-hand on a USB drive) mounts it,
> but doesn't let me *do* anything (though it spews btrfs errors in
> dmesg).  Getting Ubuntu 11.10 (kernel rev. 3.0.0) gives me this:

> [  121.226246] device fsid d657ce6a-d353-4c2c-858a-6a1f4d9e766e devid
> 1 transid 217713 /dev/sda1
> [  121.232430] parent transid verify failed on 100695031808 wanted
> 217713 found 217732
> [  121.232898] parent transid verify failed on 100695031808 wanted
> 217713 found 217732
> [  121.233357] parent transid verify failed on 100695031808 wanted
> 217713 found 217732
> [  121.233365] parent transid verify failed on 100695031808 wanted
> 217713 found 217732
> [  121.248231] btrfs: open_ctree failed

It may not please you - I have the same problem. Kernel 3.1.

The first try to mount is in "/etc/rc.d/rc.local". Has worked many  
weeks, now doesn't work. Without any message.

Next try produces (in "dmesg")

device label MMedia devid 2 transid 57932 /dev/sdb1
parent transid verify failed on 21094400 wanted 57401 found 47987
parent transid verify failed on 21094400 wanted 57401 found 47987
parent transid verify failed on 21094400 wanted 57401 found 47987
parent transid verify failed on 21094400 wanted 57401 found 47987
parent transid verify failed on 21094400 wanted 57401 found 47987
btrfs: failed to read chunk tree on sdg1
btrfs: open_ctree failed

And the third try has success:

device label MMedia devid 2 transid 57932 /dev/sdb1

----------------------------------------

Very few times I don't need 3 tries, but only 2.

---------------------------------------------------------------

What's the meaning of the 3 numbers in the "parent" message?

Viele Gruesse!
Helmut
