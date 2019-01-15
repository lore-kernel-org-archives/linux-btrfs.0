Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57AD6C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DD1208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 22:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbfAOWk3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:40:29 -0500
Received: from mout.gmx.net ([212.227.15.15]:54065 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729846AbfAOWk2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 17:40:28 -0500
Received: from thetick.localnet ([77.47.110.32]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LikE1-1hFrOR3s3J-00cxdF for
 <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 23:40:27 +0100
From:   Marc Joliet <marcec@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: applications hang on a btrfs spanning two partitions
Date:   Tue, 15 Jan 2019 23:40:18 +0100
Message-ID: <2671305.1QxYQ0Ocz6@thetick>
In-Reply-To: <pan$cd3b7$50e825ef$b5f86324$c489b494@cox.net>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de> <2486006.dzvMEKkTBt@thetick> <pan$cd3b7$50e825ef$b5f86324$c489b494@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9615415.TDjmcE3yhK"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Provags-ID: V03:K1:jAj0ttxUG+EsUNWVEDB2+sV0Xs4FA3gxo6bbb8eyEUA+e1MiHx8
 3L9rkOXM3kR/SphzPHGnK3gJW7MwH3tuHxma34yRWSBeInhd1JMe/tUEXEJXmkNnvC0I3R8
 tzd6puFMdO0qtT3uY2AEvlsPIvBzFcXiJt9EroE7jLVTjzTGQ7kzvwjWt2Vrab6kR+WGYVo
 etHD07OTmeD9W8RBuVRrg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eKTX+Pz5hnc=:QKgTSSQ96y1JjJX/Rj5tgz
 PX+ictGdBbM1sC8QwAhKYk8eNcCptmivuBeFO6gc6vygEzJuzEIG8+04B/UAHybuJtQe6i2ST
 mnWSXpzSWQYpsLvouoa6/bM8i4c2Ph5Ebwdc7HW3yWlVgRViQerUh+J/Jrv/a5YST5u0iZu1h
 KiOjP9QOCphS6ktgFEHrCb3wEVyitmn9XiEYwcsyMBRywQBoNzMpLWDPgSg0v0jhl/yivPFpW
 rPuaugeLBjN+0bSX5lEhZV95R017WtASR13zC06clxvEtCDNIX9XGrCSpVB3SI3AHhBtoYP0o
 EVvptAOhkmwQxM+fkc8FjLpeYhx+Fvieq1Jh1UNtPCjdZJAqo2G/QTEKUB+6efixkUx0cJbWk
 4QjCMJqH3cogZmqjjBRU7+0nnYF4Gg+yMRi+1x5Ui+HAMbLTA4El9oQ7wHuTyLhsUXMrGarun
 Gudtk/1srGkLRgPruxLikjIzJYVJuOMPB+YCu7bgNAI0En5eXgFRyBnaCggYYujYKeDgl7SA0
 rYJJHeSV3g54AohepTD4ea12g67/a1z4XwQEoLRq1CjBLOzZ12nCkyJydqgnK3x6u7rXytEQm
 IRdQ/Jdgug/KFdRGaCoYL0P3c57/a0Uiy62oD/vSQcb0Ibi/6aLEE5y8D0tDqihIiamEWJnlZ
 c4YFcPi2zrHESMrPOVN7jhe1o3YGy3NjJF/GwvRZhOCF7J+YDFdPORe1utF/UAKX17OAP2v6F
 ilQPVQvLycqLfkkmlrtU1dTj/yEAyAr6kiON0BbBlSGQbNKIPp0gdDRcf4/sdOY9iAd+Nb9iZ
 unPpPd5vNOycMEiQSZjING7Q+np++QeNpAtJtMFFlNOHoMFj1+sWOSME5tha+ONV13EFeYXsC
 WzG+fsWWFl8E625hRC9Dsm0J0hmoOm10tvXZB2WZ8=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--nextPart9615415.TDjmcE3yhK
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 15. Januar 2019, 09:33:40 CET schrieb Duncan:
> Marc Joliet posted on Mon, 14 Jan 2019 12:35:05 +0100 as excerpted:
> > Am Montag, 14. Januar 2019, 06:49:58 CET schrieb Duncan:
> > [...]
> > 
> >> Unless you have a known reason not to[1], running noatime with btrfs
> >> instead of the kernel-default relatime is strongly recommended,
> >> especially if you use btrfs snapshotting on the filesystem.
> > 
> > [...]
> > 
> > The one reason I decided to remove noatime from my systems' mount
> > options is because I use systemd-tmpfiles to clean up cache directories,
> > for which it is necessary to leave atime intact (since caches are often
> > Write Once Read Many).
> 
> Thanks for the reply.  I hadn't really thought of that use, but it makes
> sense...

Specifically, I mean ~/.cache/ (plus a separate entry for ~/.cache/
thumbnails/, since I want thumbnails to live longer):

% grep \^[\^#] .config/user-tmpfiles.d/*.conf
.config/user-tmpfiles.d/clean.conf:d %C/thumbnails - - - 730d -
.config/user-tmpfiles.d/subvolumes.conf:q %C 0700 - - 60d -
.config/user-tmpfiles.d/subvolumes.conf:q %h/tmp 0700 - - - -

I don't use qgroups now, but will probably in the future, hence the use of "q" 
instead of "v".  ~/tmp/ is just a scratch space that I don't want snapshotted.

I haven't bothered configuring /var/cache/, other than making it a subvolume 
so it's not a part of my snapshots (overriding the systemd default of creating 
it as a directory).  It appears to me that it's managed just fine by pre-
existing tmpfiles.d snippets and by the applications that use it cleaning up 
after themselves (except for portage, see below).

> FWIW systemd here too, but I suppose it depends on what's being cached
> and particularly on the expense of recreation of cached data.  I actually
> have many of my caches (user/browser caches, etc) on tmpfs and reboot
> several times a week, so much of the cached data is only trivially cached
> as it's trivial to recreate/redownload.

While that sort of tmpfs hackery is definitely cool, my system is, despite its 
age, fast enough for me that I don't want to bother with that (plus I like my 
8 GB of RAM to be used just for applications and whatever Linux decides to 
cache in RAM).  Also, modern SSDs live long enough that I'm not worried about 
wearing them out through my daily usage (which IIRC was a major reason for you 
to do things that way).

> OTOH, running gentoo, my ccache and binpkg cache are seriously CPU-cycle
> expensive to recreate, so you can bet those are _not_ tmpfs, but OTTH,
> they're not managed by systemd-tmpfiles either.  (Ccache manages its own
> cache and together with the source-tarballs cache and git-managed repo
> trees along with binpkgs, I have a dedicated packages btrfs containing
> all of them, so I eclean binpkgs and distfiles whenever the 24-gigs space
> (48-gig total, 24-gig each on pair-device btrfs raid1) gets too close to
> full, then btrfs balance with -dusage= to reclaim partial chunks to
> unallocated.)

For distfiles I just have a weekly systemd timer that runs "eclean-dist -d" (I 
stopped using the buildpkg feature, so no eclean-pkg), and have moved both 
$DISTDIR and $PKGDIR to their future default locations in /var/cache/.  (They 
used to reside on my desktops HDD RAID1 as distinct subvolumes, but I recently 
bought a larger SSD, so I set up the above and got rid of two fstab entries.)

> Anyway, if you're not regularly snapshotting, relatime is reasonably
> fine, 

Personally, I don't notice the difference between noatime and relatime in day-
to-day usage (perhaps I just don't snapshot often enough).

> tho I'd still keep the atime effects in mind and switch to noatime
> if you end up in a recovery situation that requires writable mounting.
> (Losing a device in btrfs raid1 and mounting writable in ordered to
> replace it and rebalance comes to mind as one example of a writable-mount
> recovery scenario where noatime until full replace/rebalance/scrub
> completion would prevent unnecessary writes until the raid1 is safely
> complete and scrub-verified again.)

That all makes sense.  I was going to argue that I can't imagine randomly 
reading files in a recovery situation, but eventually realized that "ls" would 
be enough to trigger a directory atime update.  So yeah, one should keep the 
above mind.

-- 
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart9615415.TDjmcE3yhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAlw+YVMACgkQv9DmhiyI
ePRvmQ//bzk6bJtZ4kZgTsM/tqRpmb012o5A5ESzc0ebYvFICN1BP1NZwzQi3GE2
YkZMJUpnKDegK0JgYba7NoxAn+67fV0Vppq+FJPR192ZFrnC1iZoObP8jlnFG8U4
G62I8bYdiPQHCnmuDqNwgHaxvAgJEPTA6dcCZJKNXCb4/FOjD24j5l94I3RBY9aR
vpsF651VlFeRNw2pECgPtfJAEQDYUVxexKpItaxg4w6F/813YoKBWXaSP0rERPf4
sjhEiWqWLLZ8V9ZWVmyfkFGB/SSPRtwgQU98IDatXEDIHM7CIpSlfw1FPguUftgs
WxPJhuuCj70iyzyEr4rZeaX8JAwvHrUIHyZIB4kV03FJFcchP40H0dU1s4I6ATC3
Qqg4Keu6ye/mMnQB3UrKEpiT35ZR4tjQlWUuOD0cscnLIVGz1v++JnRtE48uahau
JuMMq26nJ/SiJwc5ZXZkrXDDY3EdCbP5F8S0bS+gCTu3YRDZpdgFH/At8bMyj+VL
dR4DyzyRx+/H35ufjsVS5Ig+VY0ReVGWuzBbl/NwaTD0aQZ5Ezf3jtt2sm0wXj/5
3RXXH82Vnz+0L8azN8TITFZq2ZknYVCd/LBtbjrQntlVllOp1O84RISWBSxQ74je
/OHiZrK+JGvn7jO3HIxwvmUem+O5u2JNMXEQ2zWx6tLZsMccJyw=
=Gf8I
-----END PGP SIGNATURE-----

--nextPart9615415.TDjmcE3yhK--



