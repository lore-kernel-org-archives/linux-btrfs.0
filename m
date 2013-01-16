Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from attic.omnifarious.org ([206.124.142.227]:39568 "EHLO
	attic.omnifarious.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab3APPmS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 10:42:18 -0500
Date: Wed, 16 Jan 2013 07:42:16 -0800
From: Eric Hopper <hopper@omnifarious.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Rendering a btrfs filesystem unmountable with the btrfs command
Message-ID: <20130116154216.GE18291@omnifarious.org>
References: <20130115204436.GC18291@omnifarious.org>
 <20130115220601.GD18291@omnifarious.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
In-Reply-To: <20130115220601.GD18291@omnifarious.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 02:06:01PM -0800, hopper@omnifarious.org wrote:
> Here is a sample fix that I believe will allow the offending filesystem
> to at least be mounted.  It hasn't been tested at all.

I got this patch into a kernel and tested it. It does indeed allow the
offending filesystem to be mounted.  I'm not convinced it's the best
possible patch.  Perhaps instead the place where the return value of the
function that's being patched is used should be changed instead.

Here is some data showing what the problem is...

# btrfs qgroup show .
0/266 97579008 97579008
0/268 97640448 97640448
1/1 97619968 97619968

# btrfs-debug-tree /dev/sdb3 | fgrep QGROUP_RELATION_KEY
  item 7 key (0/266 BTRFS_QGROUP_RELATION_KEY 1/0) itemoff 3723 itemsize 0
  item 8 key (0/266 BTRFS_QGROUP_RELATION_KEY 1/1) itemoff 3723 itemsize 0
  item 9 key (0/267 BTRFS_QGROUP_RELATION_KEY 1/0) itemoff 3723 itemsize 0
  item 10 key (0/268 BTRFS_QGROUP_RELATION_KEY 1/0) itemoff 3723 itemsize 0
  item 11 key (0/268 BTRFS_QGROUP_RELATION_KEY 1/1) itemoff 3723 itemsize 0
  item 12 key (1/0 BTRFS_QGROUP_RELATION_KEY 0/266) itemoff 3723 itemsize 0
  item 13 key (1/0 BTRFS_QGROUP_RELATION_KEY 0/267) itemoff 3723 itemsize 0
  item 14 key (1/0 BTRFS_QGROUP_RELATION_KEY 0/268) itemoff 3723 itemsize 0
  item 15 key (1/1 BTRFS_QGROUP_RELATION_KEY 0/266) itemoff 3723 itemsize 0
  item 16 key (1/1 BTRFS_QGROUP_RELATION_KEY 0/268) itemoff 3723 itemsize 0

Notice how there are a whole bunch of QGROUP_RELATION_KEY records that
refer to qgroups that no longer exist (1/0 and 0/267).  This is because
a qgroup destroy was done on these qgroups but the corresponding
QGROUP_RELATION_KEY records were not removed.

--=20
"They who can give up essential liberty to obtain a little temporary
 safety, deserve neither liberty nor safety." -- Benjanmin Franklin
-- Eric Hopper (http://www.omnifarious.org/~hopper) --

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQGcBAEBCAAGBQJQ9spYAAoJEA0oytveg7KqTtcL/jYVC83kzFFd6wciExM+G7Sp
KMDcLULOTJF+1CwpQ2r/xbVTEIN3qz9jH4ad70wYeyDTcWGxLHW1zxCtjP9WT4Te
waUhhZr3dOS/nPnNmsaIqelQyizLv2fOzKYKV06jcBx+9eBr2okkQ+ldLi3X+v1X
LvbWWw0/ejq/3GJJW1bEGCEhDeuLzlkCGc8FGpEn8W4w+ZDh6qRQM1eBaFieHd8X
HUFCwg4w92/qMXmuL2LJK0pv4s0jJRis8Bli07//Twzl/9VVUaQVy4fmK57vPg+n
ayO78iQqCZUQln33XktxhsDJ5Iwvyo7+0cGuz0KteloZLzATxp6fW7PEWKR3KlLx
cQwL54VHi2lAaFg/qBndBL57wSezvuDgiDFBYv2r9S6wJKzDecklvpDlJ3cDHuOy
2QGVoXjqaB+ggokjCgY0gG7BZbnl++RVSCtHBhrRl5XzcDMoANYt1DLaBLpGBePu
As17/lHnh6K6RpyxI4w6/nmeWN6V2xBofvMwPonAGA==
=ZK+g
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
