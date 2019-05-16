Return-Path: <SRS0=Y5xQ=TQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F42C04AAF
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 16:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A3520815
	for <linux-btrfs@archiver.kernel.org>; Thu, 16 May 2019 16:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEPQVE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 16 May 2019 12:21:04 -0400
Received: from james.kirk.hungrycats.org ([174.142.39.145]:40418 "EHLO
        james.kirk.hungrycats.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEPQVD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 May 2019 12:21:03 -0400
Received: by james.kirk.hungrycats.org (Postfix, from userid 1002)
        id 67D882FF459; Thu, 16 May 2019 12:21:02 -0400 (EDT)
Date:   Thu, 16 May 2019 12:20:14 -0400
From:   Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: storm-of-soft-lockups: spinlocks running on all cores,
 preventing forward progress (4.14- to 5.0+)
Message-ID: <20190516161850.GC22081@hungrycats.org>
References: <20190515213650.GG20359@hungrycats.org>
 <0480104e-db25-4e2f-08e5-0236ffd5c1c2@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GPJrCs/72TxItFYR"
Content-Disposition: inline
In-Reply-To: <0480104e-db25-4e2f-08e5-0236ffd5c1c2@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--GPJrCs/72TxItFYR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2019 at 09:57:01AM +0300, Nikolay Borisov wrote:
>=20
>=20
> On 16.05.19 =D0=B3. 0:36 =D1=87., Zygo Blaxell wrote:
> > "Storm-of-soft-lockups" is a failure mode where btrfs puts all of the
> > CPU cores in kernel functions that are unable to make forward progress,
> > but also unwilling to release their respective CPU cores.  This is
> > usually accompanied by a lot of CPU usage (detectable as either kvm CPU
> > usage or just a lot of CPU fan noise) though I don't know if all cores
> > are spinning or only some of them.
> >=20
> > The kernel console presents a continual stream of "BUG: soft lockup"
> > warnings for some days.  None of the call traces change during this tim=
e.
> > The only way out is to reboot.
> >=20
> > You can reproduce this by writing a bunch of data to a filesystem while
> > bees is running on all cores.  It takes a few days to occur naturally.
> > It can probably be sped up by just doing a bunch of random LOGICAL_INO
> > ioctls in a tight loop on each core.
> >=20
> > Here's an instance on a 4-CPU VM where CPU#0 is running btrfs-transacti=
on
> > (btrfs_try_tree_write_lock) and CPU#1-3 are running the LOGICAL_INO
> > ioctl (btrfs_tree_read_lock_atomic):
>=20
>=20
> Provide output of all sleeping threads when this occur via
>  echo w > /proc/sysrq-trigger.

The machine is dead in this state--it doesn't respond to pings or serial
port input, and can't run a shell.  The serial console doesn't respond
to BREAK-w either.  Those per-CPU stack traces every 22 seconds are all
I get, and also the only indication the system is not completely stopped.
The per-CPU stack traces do continue for days, and never report any
processes running other than those four.

> Also do you have this patch on the affected machine:
>=20
> 38e3eebff643 ("btrfs: honor path->skip_locking in backref code") can you
> try and test with it applied ?

I have that patch applied already from when I was collecting deadlock
fixes earlier this year.

I have observations of storm-of-soft-lockups going back to at least
4.14 (it is #5 out of the 6 most common ways 4.14.y kernels fail).
So it is not a new bug.

> <SNIP>
>=20

--GPJrCs/72TxItFYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSnOVjcfGcC/+em7H2B+YsaVrMbnAUCXN2NVgAKCRCB+YsaVrMb
nEyBAKDXR/8V0ivRfKoOllRrRinBPO8TZACdHVpSxT1kmWrWLa+WdjB8nzXbRrU=
=iEEC
-----END PGP SIGNATURE-----

--GPJrCs/72TxItFYR--
