Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD881C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 20:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8170E20848
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 20:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfDOUX3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 16:23:29 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:40578 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfDOUX3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 16:23:29 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hG88T-0005QS-WA; Mon, 15 Apr 2019 20:23:25 +0000
Date:   Mon, 15 Apr 2019 20:23:25 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     George Mitchell <george@chinilu.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: btrfs mount fail after adding new drive to raid1 array
Message-ID: <20190415202325.GA5426@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        George Mitchell <george@chinilu.com>, linux-btrfs@vger.kernel.org
References: <eb0caa5e-3d35-495c-7420-1c39056f9ec4@chinilu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <eb0caa5e-3d35-495c-7420-1c39056f9ec4@chinilu.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2019 at 12:55:44PM -0700, George Mitchell wrote:
> After adding a new drive to a btrfs raid1 array I cannot remount
> it.=A0 One thing that went wrong for me after having successfully done
> this many times before over the last five years is that in this case
> I failed to format the partition as btrfs and just left it
> unformatted assuming the btrfs command would format it or give me a
> warning.=A0 But I am not sure that is what caused the problem.

   It wouldn't have. That's the correct approach -- btrfs will write
the appropriate superblocks and metadata to the new device,
effectively destroying anything that was on there before.

> So far I have tried physically disconnecting the added drive and
> trying to mount read only but that has been unsuccessful.
>=20
> I could forge ahead attempting to recover but I prefer to gather any
> advice or suggestions I can get before making some foolish mistake.=A0
> I appreciate any comments you might have.
>=20
> Here is what I am seeing:
>=20
> [root@localhost ghmitch]# btrfs check /dev/sda4
> Checking filesystem on /dev/sda4
> UUID: 4b0983d7-8d85-463d-85c1-c20aa3b4fa3b
> checking extents
> WARNING: unaligned total_bytes detected for devid 4, have
> 414224777728 should be aligned to 4096
> WARNING: this is OK for older kernel, but may cause kernel warning
> for newer kernels
> WARNING: this can be fixed by 'btrfs rescue fix-device-size'

   You only need to run btrfs check on one of the devices. The device
only serves to identify the filesystem, and btrfs check will scan all
devices to find the ones that match the device you gave it. btrfs
check on the other devices is redundant -- you're checking the
*filesystem*, not a *device*.

   Have you tried using the command recommended in the btrfs check
output? (But give us the dmesg first, just in case).

> [root@localhost ghmitch]# mount LABEL=3Dcommon /common
> mount: can't find LABEL=3Dcommon
> [root@localhost ghmitch]# mount LABEL=3DCOMMON /common
> mount: wrong fs type, bad option, bad superblock on /dev/sdb4,
> =A0=A0=A0=A0=A0=A0 missing codepage or helper program, or other error
>=20
> =A0=A0=A0=A0=A0=A0 In some cases useful info is found in syslog - try
> =A0=A0=A0=A0=A0=A0 dmesg | tail or so.
> [root@localhost ghmitch]# mount LABEL=3DCOMMON /common
> mount: wrong fs type, bad option, bad superblock on /dev/sdb4,
> =A0=A0=A0=A0=A0=A0 missing codepage or helper program, or other error
>=20
> =A0=A0=A0=A0=A0=A0 In some cases useful info is found in syslog - try
> =A0=A0=A0=A0=A0=A0 dmesg | tail or so.
> [root@localhost ghmitch]#
>=20
>=20
> I am attaching the output from journalctl for this.

   I don't see a kernel log attached, just the btrfs check output
again.

   Hugo.

--=20
Hugo Mills             | Great oxymorons of the world, no. 4:
hugo@... carfax.org.uk | Future Perfect
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJctOg9AAoJEFheFHXiqx3kxr4P+weKS7qdKziUAh4vxZyRhCWX
ee+rVAw8hxlEYiroE36GXRn791a95DJHa0uH0RdK9PtMjjVXm9kmbrWtFxaDcOjU
WO0BRQxYheIOpkdTXSIwfNIOGEjIgFA0tjZ6jO3oyRYxxpL6K56LQT0CBICWsj7q
R1xn3yB1gOtrHlkxtCD9WWMJobEessZrWOrhaWf5dcfXyIxshSc4v1XJTSnVX8Uc
S+/v/FlFnAdQUkb3rRVJpgxqUtKx+CWzEb3LGsO55vI7W1fT5bc6jjKcL8p6GOD5
/PovSKefL69lXMlCSEjYc2KhploTrUcnxBakj4uNYil19MqU0QW1TUIoRscZEEhD
RJFgPyRshMkDFITEUMchXQPKubzxLy4PaEQnMLGdGPCGtU9Oi2EAp2KATy7DENLV
INBJNojcgozQK2N4m4UD2n4LJN4rsivOrS7AQE1E6sXSQpUyExomW+K2yU+JJYU1
nEtcNWVnevqkmq3VN1nFQw6Gl9pR4IdtN95u9DeHa43CpnohBRkOG1yBbCD4ncyj
jph+uDCo3QVrYvo24+q/rj43NF/JkZL6TbhaggsJHL0pYLRm0jlQjg9aGwJCoM31
APVKiKJb5OuHPSHg3da9LIJ8k8fQbcr8fso0T48wsh/gauSt7jQwDJzTyBhu/de4
OrRlW5NWAiiNaVYm04Ar
=/snx
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
