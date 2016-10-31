Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52818 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762659AbcJaIo0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 04:44:26 -0400
Date: Mon, 31 Oct 2016 08:44:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161031084412.GI16645@carfax.org.uk>
References: <20161030183437.GA3287@merlins.org>
 <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
 <20161031020616.GH28648@merlins.org>
 <60a0ce1f-7b2f-325e-51f7-ccad054fab8b@cn.fujitsu.com>
 <20161031054719.GN28648@merlins.org>
 <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
 <20161031062509.GO28648@merlins.org>
 <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
 <20161031063737.GP28648@merlins.org>
 <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jQIvE3yXcK9X9HBh"
In-Reply-To: <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jQIvE3yXcK9X9HBh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 31, 2016 at 03:04:27PM +0800, Qu Wenruo wrote:
> 
> 
> At 10/31/2016 02:37 PM, Marc MERLIN wrote:
> >On Mon, Oct 31, 2016 at 02:32:53PM +0800, Qu Wenruo wrote:
> >>
> >>
> >>At 10/31/2016 02:25 PM, Marc MERLIN wrote:
> >>>On Mon, Oct 31, 2016 at 02:04:10PM +0800, Qu Wenruo wrote:
> >>>>>Sorry for asking, am I doing this wrong?
> >>>>>myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32
> >>>>>skip=26367830208
> >>>>>dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> >>>>>0+0 records in
> >>>>>0+0 records out
> >>>>>0 bytes (0 B) copied, 0.000401393 s, 0.0 kB/s
> >>>>
> >>>>So, the underlying MD RAID5 are complaining about some wrong data, and
> >>>>refuse to read out.
> >>>>
> >>>>It seems that btrfs-progs can't handle read failure?
> >>>>Maybe dm-error could emulate it.
> >>>>
> >>>>And what about the 2nd range?
> >>>
> >>>they both fail the same, but I wasn' tsure if I typed the wrong dd command
> >>>or not.
> >>
> >>Strange, your command seems OK to me.
> >>
> >>Does it has anything to do with your security setup or something like that?
> >>Or is it related to dm-crypt or bcache?
> >>
> >>
> >>But this reminds me, if dd can't read it, maybe btrfs-progs is the same.
> >>
> >>Maybe only kernel can read dm-crypt device while user space tools can't
> >>access dm-crypt devices directly?
> >
> >It can, it's just the offset seems wrong:
> >
> >myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830208
> >dd: reading `/dev/mapper/crypt_bcache0': Invalid argument
> >0+0 records in
> >0+0 records out
> >0 bytes (0 B) copied, 0.000421662 s, 0.0 kB/s
> >
> >If I divide by 1000, it works:
> >myth:~# dd if=/dev/mapper/crypt_bcache0 of=/tmp/dump1 bs=512 count=32 skip=26367830
> >32+0 records in
> >32+0 records out
> >16384 bytes (16 kB) copied, 0.139005 s, 118 kB/s
> >
> >so that's why I was asking you if I counted the offset wrong. I took the
> >value you asked and divided by 512, but it seems too big
> >
> >13500329066496 / 512 = 26367830208
> >
> >Marc
> >
> But according to your dump-super output, that's strange.
> ------
> chunk_root              13835462344704 (CR)
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 13835461197824) (CS)
>                 chunk length 33554432 owner 2 stripe_len 65536
>                 type SYSTEM|DUP num_stripes 2
>                         stripe 0 devid 1 offset 13500327919616 (ST1)
>                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
>                         stripe 1 devid 1 offset 13500361474048 (ST2)
>                         dev uuid: 0cf779be-8e16-4982-b7d7-f8241deea0d1
> ------
> 
> Here, your chunk logical bytenr is 13835461197824, and its physical
> bytenr is 13500327919616 and 13500361474048.
> 
> My calculation is quite simple.
> Start1 = CR - CS + ST1
> Start2 = CR - CS + ST2
> 
> Unless the superblock is incorrect, it is not possile.
> 
> And the physical offset, is about 12.2 TiB, which is smaller than
> 15TiB of your device.
> 
> So that's quite strange that dd can't read out the data.
> And if dd can't read it out, then I see no reason btrfs-progs can
> read it out.
> 
> Any idea on special dm setup which can make us fail to read out some
> data range?

   I've seen both btrfs check and btrfs dump-super give wrong answers
(particularly, some addresses end up larger than the device, for some
reason) when run on a mounted filesystem. Worth ruling that one out.

   Hugo.

-- 
Hugo Mills             | Great films about cricket: Silly Point Break
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--jQIvE3yXcK9X9HBh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJYFwRcAAoJEFheFHXiqx3kRPIQAJOOM1b+kxheKz0Ons6a8RyF
+wHcRmmNptHdJGsQ5RmZKrSKghVCLgYwaeA6RSz9FXIQufaHdghztYsI50s3QwDj
o6dEVjgwvdMzbLXEk0Hfq74I8WgGal2g2ClUCRHle+ZJ/BqayMfx2y60jiun3lCZ
DYpnK/3vppjeX/6D2242EemE+R91rKVdB1c3qwfdWEBbcO8R/6N3TD0sC9YojTpI
TwaJaBdNLVF2AERwEh/+/Aj+RGEt1OYM0gn2CK1XL2KBsZ9URSf/2zdyQfKlnSjo
3l65Fzs3okzlSu641pKkoFb6iXT3tOgteXHyp3gpJFlLh/TR0EC1ItInBEZcm+/e
mL9qM30CA1POZvgBtVbVgexFnfcTNH6sVhHOfu5zK1lFC9YoXCbD48A+Ik3WMMfc
crSkyHuOEyWYNxzP4vtgDOhLMeDJG0tYcrpbpXmPbHlujnFQ2hDYcj8UjKlN2QYw
lGdLlwtRU5YilzMoPqBFn5T5f64KNx+y+CU0KZSUN2okADxMfqSSjAWJrtUFyhxB
yy540ZXqKwyAM5OSERffVE1ATp0EhTE3PdOECvBqgSIyFIpXV7sNrON+wP2G1eVr
WiiOeM81OCwySi6ITxUiIyJSUyBckQYJxKm+IZzJZ8Ilymp/Rh8SG5u6OIiw98cl
eF63xBvUBmeOV0gfyvnC
=Dbh9
-----END PGP SIGNATURE-----

--jQIvE3yXcK9X9HBh--
