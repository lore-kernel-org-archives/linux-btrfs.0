From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Slow snapshot deletion
Date: Mon, 1 Aug 2011 16:59:15 -0600
Message-ID: <20110801225915.GA32470@untroubled.org>
References: <20110728200444.GA30801@untroubled.org>
 <1311884805-sup-7662@shiny>
 <20110801222604.GA3529@untroubled.org>
 <CAE5mzvgNYHkq6ETKkbs7GDryN4LmU8uw_wwTCDhKseubjxRfMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvgNYHkq6ETKkbs7GDryN4LmU8uw_wwTCDhKseubjxRfMQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 01, 2011 at 04:41:10PM -0600, cwillu wrote:
> The keystroke should be alt-sysrq-w.

Right.  What I meant is that no backtraces are showing up.  I was
actually using

	echo w > /proc/sysrq-trigger

and all I was seeing is:

SysRq : Show Blocked State
  task                        PC stack   pid father

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJONy/DAAoJEFFRvcnBTTxnFacQAI3he6rP1UY3GG3vu5XyGiKB
t4SXF0nmIfdCEGQLPia7vZw1NTM0e84IBqw4pL93EqjepjyblaoL6Ms8p/9qVib2
qnsIUa7CmGasE0kOsSyIhfQP/4uz8wbqGjJq8V5xd6irJi7330ar8cE6dyVRK40o
0JlrwHti8NNxymvr2lW+HQrZweJ3pBJqA+RC1mhW6IqwKyN+tle73K/HZtrDzuzu
gwS5KnIhiDYq3zDF7rE2mS7W34wIsGr8NGddXWnbkrJiLJjF09pnY4FjDKneCW5Z
p8g/5Pw0YgLxJ2yfHDPibXYT0BY/+vc6zLLQfjovxtSwADHD5FnrZ1tEj9pIoVgk
J1hqeQux1YRKwY1s3OL+JkYlhUZDQTLZeisOUbFXsdog70c+Uca3ei2vqUijwaKP
mGAJlTfkZp1lTgFw84M34s68pvgpKyq4bUT01f3iMt1ptL2UG0mgSa2Blhmj3Ov7
A/Hke0TF5W0+2vYxwQctgm8Gp+COFhh2UV400E2at7gQJV1cRlRYnOTrRFDei54H
MZJoDapNyGa8G41PettBvhsYf78wQXyNJkXhpyYOvAAZWpnr8iO9JRuiGYlcjfam
spNdkQcnY9xsm/pmSAo4mY7CafijqW7fbSku4K5HqKjX7t/plEYQj6KpqWC4o8KF
+e6/LsB/spa/SEJfCIRr
=rMbb
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
