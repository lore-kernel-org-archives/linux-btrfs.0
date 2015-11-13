Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:37508 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbKMSm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 13:42:29 -0500
Date: Fri, 13 Nov 2015 18:42:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Vedran Vucic <vedran.vucic@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: illegal snapshot, cannot be deleted
Message-ID: <20151113184227.GF24333@carfax.org.uk>
References: <CAHTEL3=r8kUJOU=xUAg2iG52HuWmqQ16QxUjY6d+zqbziW5+gw@mail.gmail.com>
 <564486F3.5020804@gmail.com>
 <CAHTEL3mEGmc5BhbGMEAbyPNU90nFQGZprLkWrh1WaEh5sSiH8w@mail.gmail.com>
 <56461034.3070209@gmail.com>
 <CAHTEL3m0uGWZGWUH_SLmg8TqMe4DcXU77p+S=4Aebukr1BZ-Bg@mail.gmail.com>
 <56462784.2060601@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
In-Reply-To: <56462784.2060601@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 13, 2015 at 01:10:12PM -0500, Austin S Hemmelgarn wrote:
> On 2015-11-13 12:30, Vedran Vucic wrote:
> >Hello,
> >
> >Here are outputs of commands as you requested:
> >  btrfs fi df /
> >Data, single: total=8.00GiB, used=7.71GiB
> >System, DUP: total=32.00MiB, used=16.00KiB
> >Metadata, DUP: total=1.12GiB, used=377.25MiB
> >GlobalReserve, single: total=128.00MiB, used=0.00B
> >
> >btrfs fi show
> >Label: none  uuid: d6934db3-3ac9-49d0-83db-287be7b995a5
> >         Total devices 1 FS bytes used 8.08GiB
> >         devid    1 size 18.71GiB used 10.31GiB path /dev/sda6
> >
> >btrfs-progs v4.0+20150429
> >
> Hmm, that's odd, based on these numbers, you should be having no
> issue at all trying to run a balance. You might be hitting some
> other bug in the kernel, however, but I don't remember if there were
> any known bugs related to ENOSPC or balance in the version you're
> running.

   There's one specific bug that shows up with ENOSPC exactly like
this. It's in all versions of the kernel, there's no known solution,
and no guaranteed mitigation strategy, I'm afraid. Various things like
balancing, or adding, balancing, and removing a device again have been
tried. Sometimes they seem to help; sometimes they just make the
problem worse.

   We average maybe one report a week or so(*) with this particular
set of symptoms.

   Hugo.

(*) <waves hands vaguely>

>  You might see if trying to re-run the balance with
> '-dusage=40 -musage=40' works correctly (I've seen cases where the
> first run fails, but subsequent ones work because the first one made
> some progress despite failing).
> >On Fri, Nov 13, 2015 at 5:30 PM, Austin S Hemmelgarn
> ><ahferroin7@gmail.com> wrote:
> >>On 2015-11-13 11:12, Vedran Vucic wrote:
> >>>
> >>>Hello,
> >>>
> >>>I succeeded to delete illegal snapshot with command:
> >>>btrfs subvolume delete /.snapshots/741/snapshot
> >>>When I have done
> >>>btrfs balance / -dusage=0 -musage=0
> >>>increasing value up to 4o I did not have issues.
> >>>But on value 4- for-dusage= and -musage=
> >>>I got message that there is no space left on disk.
> >>>Do you have any advice how to manage that?
> >>
> >>
> >>Can you post the output of 'btrfs fi df' and 'btrfs fi show' again? Both
> >>should have changed after the balance, and I'd need to see what it looks
> >>like now to be able to give any reasonable advice.
> >>
> >>
> 
> 



-- 
Hugo Mills             | You can play with your friends' privates, but you
hugo@... carfax.org.uk | can't play with your friends' childrens' privates.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                       C++ coding rule

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWRi8TAAoJEFheFHXiqx3kBikP/0GeCyWE360KhdvCKVClJozz
vRYOqYQRuzwkPhL0I3vSJYoLjTCQjLJuoRnvMbZOSxCCRcqRTFYCKzLJuCiciriB
uyg2ue0YEUjADrZ0jsMBqc5+qjscLa9CDwF5lQgkACS2Z0XWM1YPQSAYB16vrplO
UMFbdFYU1sWPkps4jEdowFbjR+/PQDwk0E/xJb7NO3LV4FED9rRKoisvzef1O0BO
sNtNrFTyc9QYvLS7nsRALXOQgwaR2rRqMu/9wbNBId/olIFFIrfyVR5b0v99roa2
V9Fw4Thlp5RBihDGk45kMcHj1a4qrOu5DLm8tj65x3kVkyAQr+JW1A/sLduo52AH
hQklwAAc0aLHac/6pbyfwYBjKQHH7c+0whHPDnlRIPmmzD8sg4tvWdtHJuWB3FPh
8REFkYTfAOrI/Wjo99cqty1oAI68HU+hm7Jz8iEkKPWNQiPAwoFc15FoNpi/1XbO
jH02YLWfwVmpn6cpPw81HoFxifX/YrvNgikKdCXj+62n3vH18NlI9fZvFpTkVmfl
n1zEbq1wKbRBfZzSQNUVnIvCRwlCS0eE+5pf4hZNep+CYJOUFvho0wj4qkuwh7gl
Rl4OC12qjlAiXONKv4TtYDQlQ0mWPYYhU5qykNgTNzaIY1aZSAJvRArepnv5oiBt
CQKr8Xyq715WmCr/vgO5
=4Vxr
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
