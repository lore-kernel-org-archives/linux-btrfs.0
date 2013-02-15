Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:49855 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3BOU7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 15:59:13 -0500
Date: Fri, 15 Feb 2013 20:59:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Hemanth Kumar <hemanthkumar51@gmail.com>
Cc: linux-btrfs@vger.kernel.org, skjmca51@gmail.com, ganeshkumar14@gmail.com,
        kirantpatil@gmail.com, praneethu.u@gmail.com, chethan.casey@gmail.com,
        sensille@gmx.net, bo.li.liu@oracle.com, sandeen@redhat.com
Subject: Re: [btrfs-progs] testing btrfs hierarchical quotas
Message-ID: <20130215205906.GI28997@carfax.org.uk>
References: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
In-Reply-To: <1360933541-2894-1-git-send-email-hemanthkumar51@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Hi, Hemanth,

   Here's a question -- what are you testing? (Not just here, but in
general, with your test infrastructure)

   There are (at least) three classes of tests you could be doing:

1) Unit tests, which test individual functions within the code and
   ensure they do what they're meant to do.

2) Integration tests, which test the full end-to-end system.

3) Partial integration tests, which exercise the kernel
   filesystem code.

4) Partial integration tests, which exercise the userspace tools code.


   Now, clearly you're not doing (1) here. It's going to be hard to
separate (2) from (3) and (4), but it's possible to write your tests
to do more of one or of the other. (*)

   xfstests clearly is much more geared to (3), and stresses the
kernel filesystem implementation rather than the userspace tools. If
you want to test the implementation of qgroups, it belongs in
xfstests. If you want to test the userspace code, you need to make
sure that (over all your tests) you cover every command-line option,
and every different way of using the tool, and ensure that it does the
right things.

   What you've written in this patch seems to be more about testing
the kernel behaviour than the userspace tools, but it'd be good if you
can put your work into the context I've just talked about above.

   More comments below...

On Fri, Feb 15, 2013 at 06:35:41PM +0530, Hemanth Kumar wrote:
> 
> Signed-off-by: Hemanth Kumar <hemanthkumar51@gmail.com>
> ---
>  hq.sh | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>  create mode 100644 hq.sh
> 
> diff --git a/hq.sh b/hq.sh
> new file mode 100644
> index 0000000..6a0a820
> --- /dev/null
> +++ b/hq.sh

   Rather cryptic filename here.

   If this is to be applied to btrfs-progs, I'd recommend putting all
your test scripts in a test subdir, and a "test" target in the
Makefile that invokes the tests.

> @@ -0,0 +1,33 @@
> +#! /bin/bash
> +# Btrfs quotas test case
> +# Hi all,
> +# This is shell script to test the hierarchical quotas feature of Btrfs
> +# I created Btrfs filesystem on a new
> +# partition, then activated quota management ('btrfs quota enable'), and
> +# created a few subvolumes of multiple levels.

   This text doesn't belong in the script -- it's your commit message,
and needs to go above the S-o-B line above.

   I'd recommend using git for your development, because when you do a
commit, it'll give you a place to put the commit message. Then, with
git-format-patch and git-send-email (and the dry-run option), you can
get it to format the mail exactly right, instead of producing slightly
mangled output as here.

> +cleanup()
> +{
> +    btrfs subvolume delete $TEST_DIR/vol1/vol2/vol3
> +    btrfs subvolume delete $TEST_DIR/vol1/vol2
> +    btrfs subvolume delete $TEST_DIR/vol1
> +    btrfs subvolume disable $TEST_DIR
> +}
> +
> +#trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +btrfs quota enable $TEST_DIR
> +echo "quota enabled on $TEST_DEV"
> +btrfs subvolume create $TEST_DIR/vol1
> +btrfs subvolume create $TEST_DIR/vol1/vol2
> +btrfs subvolume create $TEST_DIR/vol1/vol2/vol3
> +btrfs qgroup limit 5m $TEST_DIR/vol1
> +btrfs qgroup limit 3m $TEST_DIR/vol1/vol2
> +btrfs qgroup limit 2m $TEST_DIR/vol1/vol2/vol3
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/vol3/file1 bs=3M count=1
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/vol2/file1 bs=2M count=1
> +dd if=$TEST_DEV of=$TEST_DIR/vol1/file1 bs=5M count=1

   What happens if one of these commands fails? You should be testing
the exit status of almost every command. Then you can fail in one of
two different ways: a failure of the test (where the thing you were
trying to test has not succeeded), or a failure of the test harness
(where the setup functions have gone wrong).

   I'd do this with a setup function to set up the test environment, a
teardown function to undo it cleanly afterwards, and one or more test
functions which can be used to run tests.

   You may want to take a look at my earlier work on this, at:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg13153.html
That should at least give you a basic infrastructure to work in.

> +cleanup
> +exit

   It's the end of the script. You don't need to use exit here.

   Hugo.

(*) OK, you could actually test quite a bit of the userspace tools
even on a system with no btrfs module, by using an LD_PRELOAD library
that stubs out the btrfs ioctls and records which ioctls have been
called. But for now, I'd suggest that you leave that idea alone.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- vi vi vi:  the Editor of the Beast. ---               

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUR6hmr9z9OVl50rAAQLLrBAAgQ1+zr3KO8RMZjA6MsEZtBfeKcrABomA
354BbT1ABRN+Cuacf94dBaqAxCKrkm6bTYLSZQIAusK04LYLf7Ea7YJTrHbc+na8
qjdmmKHvIQBZ6enwLVD++A/xtRgIxmpxV5i7kDDqDRJa6FDPZRlgRCdCJngbRYCo
qKl8TB5AtovlW6iDft2GqPXnMgVByZYOlyac/WiuGZNEjmYDtvDEb+quprKaiyJd
gqoaOv13Djzdr0Lge2TSCpq+MhjKwOcRtyy8GbWn7wRDldXMnrMM47uIkXNsBipV
0+hk6z4iMQiknSyAP0wPtLRcm0Lq2WwjwPtVBXMbsFM+y2goaBjXCAPYxm+Prrs9
6gHPzhyBCiic2DAAstYtrxNz3kifqYZJxCR81KVDEqLunWdZpQyV+7A27auvaPkh
7NxOPBZDYdBNBE4eXB9vseZ9v4IXNnwY/FH5oRockySSkQhryPrAhXn0JZ++4jw+
5OvnUmq5JOIRbcbnv3j+j9mMCjUU3NdyUMCTxn1ObOVID+Mut2KwCt1lObmfy3dv
sy+pbiY6TA8BvdFU+ANK8hr8KQwZcRljEKKVDDx4wxJOi9+kkBVc5kiz4rrmUOGI
NycXzyyMa+VJOEopHUgZZQ92nLf6Cm1/lcQ2R/K4wdcr+1yt/2QqmEVHZrNaBOi8
xUR+Cvdb9LE=
=Bkvs
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--
