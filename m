From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Slow snapshot deletion
Date: Mon, 1 Aug 2011 16:26:04 -0600
Message-ID: <20110801222604.GA3529@untroubled.org>
References: <20110728200444.GA30801@untroubled.org>
 <1311884805-sup-7662@shiny>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311884805-sup-7662@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2011 at 04:28:04PM -0400, Chris Mason wrote:
> The slow performance is probably coming from reading in the metadata
> associated with the snapshot extents.  The new readahead extentions from
> Arne should help once we've adapted them to it.  The easiest way to make
> sure is to hit sysrq-w a few times while it is slow (or run a patched
> latencytop).

We shut down the rsync backups for now, and are waiting for the
snapshots to complete deletion so we can unmount the filesystem to
reboot (missing kernel options for latencytop).  In the mean time I hit
SysRq-W quite a number of times, and nothing is showing up in kernel
messages.  However, btrfs-cleaner and/or btrfs-transaction (sometimes
both, sometimes just one) have been running high in top, taking up all
the CPU time.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJONyf8AAoJEFFRvcnBTTxnZHQQAKPB1savWIPg1j1n23+2nnOW
9OHIqkZz4hDmEIPGcpsln6GY9naZs/0OsSPQE1ffwxkoz7kEg8BSHmhgw/VV+296
0uUHQ5C3KhLUxN+SkNJbt51F729v4t0jD4L2ZWOLqXYST3sdtTRCCvtKaG/968h1
iLpqp0JxlFP2HR8H6Mn82qrXLSDf12I341Gp0xNg3qd6Dgk9NdP1Y1OSQ3Bp2WPG
3dt5+x1l3WLbDQnWSfJO/DF3byn62kFWBItDUN4uBzdfx8oEB2uL9XarhbIvMemN
GiV1jKXnEmM8dzzNpJ0DelHqPMR8kLjF2ZVDf99B0dtb76/b9sn3hj5g6q8N6C2u
U31y/AG2cj4ijtTn0IWQA7O6FLBg0AmGQPeU1YB1mOAE1ukq/6tC1TkHW/LW7BRe
PSG94BJaWTF8ofSByq8R6viJgplF5l2fXdeNwCDX1N29JJy2zVPc6SsMDaWZoGst
QRnrXemfBhd6JnAMv0B2u9eZ6CmdtkPhQbhCowoVCMKynvIsno+Pd7kQIEKOTdoO
ytP6x1WVtC0z3mCWUL0LzGEInRiUtpqXuFBYIgMb2K4k5kljLqywlLVcoZskYLi+
xG5+8651RvufBqSVDeDZz5mcey02uA3w0wbN47hD6ltMs2TdkCkHUvEXEUnkoYzS
xg3MrH7AqgCxZU7SSqS5
=uDCm
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
