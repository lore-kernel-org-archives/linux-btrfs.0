Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188AbbBBGJt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Feb 2015 01:09:49 -0500
Date: Mon, 2 Feb 2015 17:09:37 +1100
From: NeilBrown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: __might_sleep() warnings on v3.19-rc6
Message-ID: <20150202170937.4b5ffcb0@notabene.brown>
In-Reply-To: <CA+55aFyR-ZK9Y2KkxbcTnMOcCc243ZKD6AKTuktpmyE0HCUcPw@mail.gmail.com>
References: <20141028142541.GA19097@wfg-t540p.sh.intel.com>
	<20150201034315.GA20124@wfg-t540p.sh.intel.com>
	<20150202100338.4fa9eefa@notabene.brown>
	<CA+55aFyR-ZK9Y2KkxbcTnMOcCc243ZKD6AKTuktpmyE0HCUcPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/xEhjkkFh2CSF9n1ZNzziJ7p"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/xEhjkkFh2CSF9n1ZNzziJ7p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 1 Feb 2015 21:08:12 -0800 Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> On Sun, Feb 1, 2015 at 3:03 PM, NeilBrown <neilb@suse.de> wrote:
> >
> > I guess I could
> >       __set_current_state(TASK_RUNNING);
> > somewhere to defeat the warning, and add a comment explaining why.
> >
> > Would that be a good thing?
>=20
> Use "sched_annotate_sleep()" instead, but yes, add a comment about why it=
's ok.
>=20
>                         Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

OK - following patch is queued to appear in a pull request tomorrow  (I hop=
e).

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.de>
Date: Mon, 2 Feb 2015 17:08:03 +1100
Subject: [PATCH] md/bitmap: fix a might_sleep() warning.

commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
    sched: Debug nested sleeps

causes false-positive warnings in RAID5 code.

This annotation removes them and adds a comment
explaining why there is no real problem.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index da3604e73e8a..1695ee5f3ffc 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -72,6 +72,19 @@ __acquires(bitmap->lock)
 	/* this page has not been allocated yet */
=20
 	spin_unlock_irq(&bitmap->lock);
+	/* It is possible that this is being called inside a
+	 * prepare_to_wait/finish_wait loop from raid5c:make_request().
+	 * In general it is not permitted to sleep in that context as it
+	 * can cause the loop to spin freely.
+	 * That doesn't apply here as we can only reach this point
+	 * once with any loop.
+	 * When this function completes, either bp[page].map or
+	 * bp[page].hijacked.  In either case, this function will
+	 * abort before getting to this point again.  So there is
+	 * no risk of a free-spin, and so it is safe to assert
+	 * that sleeping here is allowed.
+	 */
+	sched_annotate_sleep();
 	mappage =3D kzalloc(PAGE_SIZE, GFP_NOIO);
 	spin_lock_irq(&bitmap->lock);
=20

--Sig_/xEhjkkFh2CSF9n1ZNzziJ7p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVM8UoTnsnt1WYoG5AQLg8hAAgdSWXm6vLeEI3p4OcINZI3a/gkUKtfGp
xUa54ATnISbrnHt7f7NnrWmLybTSnkPvDGz72CuytbkhedpFq7Q5nSO04RCB3fPX
u1UL2sUhcddQeFLY+wFHEPLQlTVcTLsbYK4me0RScDrLjZnHBlQj5cGu5Re2UhXm
Qrw4RyvrlEJwEAh/6DpWjUB4xM/44EbFUzFVZyjPnzyDRkPpPj+GwfMUZGm62yoQ
TQr/GUekT2huRXd0Czjx36jErSRAqJh0a3Owk6gUfWeoUARbqKKs6CsyAFUrtMJp
sfUO7xi4hYOmLKDRm6xVb3+3EUvV0qdt9EvGLRe58VBvFJbEv8IXcYJUYawblIt+
01xVTpEtZ4mNx/JprnpZ2Wkxl5dGrk5nITyyuqtIDSAbJ/u65ONAvnYBDI4xtc1B
6o3Kdq3mUQqh0eue4TL9hZL71lQCdOI9zGSDRVE0D84Au+gWDs5XRXgjfDu5CRyl
dg7Q+EMFUWwcdgLTv1NnvnVXVewq0Dd1QE1XC6ocTpFxHGSvX1jVtm9d8JyGcM7v
ZU2n1EWuSPxFC3IN/rk2v2EUwg7j7qPh+Z5Rmq3M3gi1KdwM4hKIYRussvSH7V3F
2DlzynFc1S5hY1/7ZLMAR0JTofCXufHtfWMNmlEkMGsmBpFHuMHS5p7DslWVHobY
Snamfg0ZpOY=
=pVIY
-----END PGP SIGNATURE-----

--Sig_/xEhjkkFh2CSF9n1ZNzziJ7p--
