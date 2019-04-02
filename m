Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE1FC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C31B52075E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 19:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfDBTCP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 15:02:15 -0400
Received: from frost.carfax.org.uk ([85.119.82.111]:51776 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbfDBTCO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 15:02:14 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1hBOfk-0000c3-F9; Tue, 02 Apr 2019 19:02:12 +0000
Date:   Tue, 2 Apr 2019 19:02:12 +0000
From:   Hugo Mills <hugo@carfax.org.uk>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
Message-ID: <20190402190212.GD29117@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <CAJCQCtTZ94yLHChBbtEs=GOUCL44RdRhMXvX8358SumGp_6fKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LTeJQqWS0MN7I/qa"
Content-Disposition: inline
In-Reply-To: <CAJCQCtTZ94yLHChBbtEs=GOUCL44RdRhMXvX8358SumGp_6fKg@mail.gmail.com>
X-GPG-Fingerprint: DD84 D558 9D81 DDEE 930D  2054 585E 1475 E2AB 1DE4
X-GPG-Key: E2AB1DE4
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--LTeJQqWS0MN7I/qa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2019 at 12:28:12PM -0600, Chris Murphy wrote:
> On Tue, Apr 2, 2019 at 7:24 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> > On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:
>=20
> > > On the larger file system only "btrfs check --repair --readonly ..." =
was
> > > attempted (without success; most command executions were documented, =
so
> > > the results can be made available), no writing commands were issued.
> >
> > --repair will cause write, unless it even failed to open the filesystem.
>=20
> It consider `--repair --readonly` is a contradictory request, and it's
> ambiguous what the user wants (it's user error) and the command should
> fail with "conflicting options" error.

   I already raised that question. :)

   It was a typo in the email. --repair was what was intended.

   Hugo.

--=20
Hugo Mills             | Great films about cricket: Forrest Stump
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--LTeJQqWS0MN7I/qa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJco7G0AAoJEFheFHXiqx3k//4P/0LLmKmrzGCKZPfgz/hhkOow
+Nh7+t3cvpJZyKYoM+y1eUWWZJHY3LtSVJInvWY44FWdpAOsXZ/B5C7gxMQGc/v3
xhwunY0+Hmx/FBOHgGZ3aRPpeyV7yaHIohXAjAlA0VwwdFEM3btBS1gMeSwGggwt
gYJg7JDnt5rO27R8S3clJs2PIIzd1m7h0usjQxh1zIHzti+mSuR4Oy/8h4lFoE+8
X+GFj/ooZA10vFfGgFufr+YUrT40h6QpqU4Ha5foOKjNkNxBQZ1W3p1fFU/b+dkC
4glTdLkl63rbk+ymKx3morWL2a7m7A5LKx7GCoXLmOT67gtYXNXUDvPJEFG8/bay
x/JcJxin/CDudXyuUKqyjixjxUqWnDT1SMTvli5QsKmJdHk3fZu1Z16hJkSvocVE
eDiFiHg1Oq+uSkOMcZ/z2EdhTa/KMu0tv1I6l+l6ls+rGIeYfaCnIdFwTOWrwNJf
M90HJdeBlBJidypubf63f6idSPToycgGKsEdNpt/v92/YNs2XCCVKXglpmwO6EdR
zzJQQixSGJfwlwUyl7/5X0tXxE6xOdPbrR14a029vivL8ln/WTwZOjrDuIQqxcB9
A4Dq2ulRtvrWS2dP0W3XdzT1u58qEABlSp4CFayXsVwTVLV5neSHaRMwAC6XLi/f
wBoj0Y5HK2Y5/Ymq/g0C
=51z4
-----END PGP SIGNATURE-----

--LTeJQqWS0MN7I/qa--
