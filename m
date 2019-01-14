Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1E2C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:35:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B42205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:35:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfANLf1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:35:27 -0500
Received: from mout.gmx.net ([212.227.15.15]:49531 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfANLf0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 06:35:26 -0500
Received: from thetick.localnet ([77.47.110.32]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MYwyp-1go6lb2wJ1-00VhgI for
 <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 12:35:24 +0100
From:   Marc Joliet <marcec@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: applications hang on a btrfs spanning two partitions
Date:   Mon, 14 Jan 2019 12:35:05 +0100
Message-ID: <2486006.dzvMEKkTBt@thetick>
In-Reply-To: <pan$4ced2$4d8a896d$78f71764$55651a6d@cox.net>
References: <418d4647-8c67-2481-68f1-1e722460c3de@florianstecker.de> <aeaf4b99-a9d5-6335-67f3-e7f851e50b32@florianstecker.de> <pan$4ced2$4d8a896d$78f71764$55651a6d@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2258111.noKQRrAZBi"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Provags-ID: V03:K1:rouKwUem/ErZj2dQVDQPhuDPTSDN/6j2L1QdpuUhRLFu3VxASn0
 thi0PfQXmDie0iyC9edLfGjpx6HZrF64oT3M/TDQkcKDYJOsOpTIhodA339kqtROFRa2Lx9
 nmOYtOvZil1t1Zu/McfQms8iIkbPExi5dsMG24zWXTbJXdVVA2NS5NIngc8f6Cqwt0RU5c5
 wgbV0Q/ZjFwWnhMGsvK3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RJh3vz6bajA=:nnIiFdE03/zZguhG8a6vgw
 4jTfQUjZ9rnG/olw1TSOL7MmmV9mg+rpffijo7HplWkjXYHPTkMb5wSIINFpBs82LnFVBZg15
 eYx/kew86X7MEr4J/Woroag10I3rQMYA0oYneUc+XQjcrTJ/6nEDXcOjQG3nZO2f+LG5+qHZS
 5AfXpmhW1RjjN5WigCKNxniNPtPDJwEtBRLszz1crmu6wSwL36y9pGy04cONkvSsipTkAxIFp
 5V3hsL4PPN0I7Cbg0Ie9gfLJC7rnaFWU23ZYdJRah4QDrc+zYWV8Lf4pX15debTHrFFPj3q9n
 11EiLEmQifRTT5ZRC66OZwZujbN7+zpvJ5LaVIKUUiKG0IjBL/f12w2gAp9V9+FdaVPMGfSOS
 QCwayEJWW+8FXytP/BCx4ft4dITgdSAAea430wXg9HrCk3y+y51HC0dHlMYUIHHUWZk824ntq
 mra2QauYmTK5KACeVjgIJWztcC+5oY0VsVkukj4qblA4YJI2s6g4U6Afkxg7n/gwlWwjlqjw9
 aFP7YlWqwIK/4GM0QHgwV54pMGtJ3UUaDLD9t4gIFrL/bIGLAXlBEC+tRP9I8Pv2It+pIvFnU
 5kRZ3hsN7EkHBtBwnaKpAJcNbhUbszKLs6yrgY9RrFM+MnlGbrcFwYSPaPAm+z8qIHS4gbWjR
 tIV/s2ECfvHqLRyPNkPiTX1t/aCDLWU/SmVrIJRwnPDHRxYgYtXVNKmRacd7Gt5UiOmeOogVu
 ocQJLzUECftqQF68jgi0ru8KDZyMgbc7CSWMCte49vEpv7Gi+7GEr8MT0nYIOtsD1bcVyUMTE
 UVq2/yQVpzPI6K0a4bQUglHRdkuM8I+/AWLrg8DpHT7PANk7/oTmhwQw7JUZo0Qi5jYJZ3kkv
 aRTeXnaxcHSTdmCVR0E5VyL4d0TCstQS1ZVfZc7mM=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

--nextPart2258111.noKQRrAZBi
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 14. Januar 2019, 06:49:58 CET schrieb Duncan:
[...]
> Unless you have a known reason not to[1], running noatime with btrfs
> instead of the kernel-default relatime is strongly recommended,
> especially if you use btrfs snapshotting on the filesystem.
[...]

The one reason I decided to remove noatime from my systems' mount options is 
because I use systemd-tmpfiles to clean up cache directories, for which it is 
necessary to leave atime intact (since caches are often Write Once Read Many).

-- 
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--nextPart2258111.noKQRrAZBi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEax7Ya5gDQFOJHKGQv9DmhiyIePQFAlw8c+kACgkQv9DmhiyI
ePQUYg//bxPEgSH38YJDL9OA20UVUyJdvjFK6evCLeeVTWdPHJOh/Zn5uR0+rpNV
xaO0UoCJYqY4AmVTXml2fq9CaurU4Q2aHbiNoDP6BCOkCmb2fxAQHJ2YsuB/M7r+
UOgdnYGCj1aPCpGVsbI7asyxT9SG0fdFwP2XH6By41ngYZH2g5zfyJ7EDoO9mLSC
0fwlPmn6N9D6xk5d93LnTRaeJhJaenJ9wpLtrTD+ebpzvNUj1w0jJIrGkNCMLwaf
B1lMTQ1PTb5GHJ2ZgxsQcjVwd4yZYdDNX/Z3C1bwCWuSgoB9J+VL3qNmEL6SP0MD
6DirnLajArXs+4G5zAUOeY9Y0sG7d36xX8w8p9Wv5mM3DDOtJQAWb2ZzFkxIf4qt
ZjR/Xg6xbWYFidZV7PvIHsRbv8BtC6Nj4w2Dkn244l1gTJYGlpN6WG4oMZZPhlTV
mojt2+F2z1YWMIMI9N24pXZFPQRi7+VXCwFDnETnz6OtI1xMKKXzn8n6FSoPi7gR
O0o04Ma6qxFiNEVNO6YH3A/8yvjTY7cvR3YMY0gTbD54+iM8yIdwR0C5XnZS8SEm
Fdck/rKYPLKySbwbcJfqNRzy/Gqs9cwsS3vfhdKuq+073304RT8w+BmB8c528EPg
kZL2tRkNju8dab6VQa3kSrOYCPJG7VdgOzNFOxNBeZHzKBcvhQA=
=PFUH
-----END PGP SIGNATURE-----

--nextPart2258111.noKQRrAZBi--



