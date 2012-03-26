From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: btrfs: open_ctree failed
Date: Mon, 26 Mar 2012 22:57:40 +0100
Message-ID: <20120326215740.GA2597@carfax.org.uk>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Cc: linux-btrfs@vger.kernel.org
To: Not Zippy <notzippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2012 at 02:40:24PM -0700, Not Zippy wrote:
> Was working this morning and my kernel crashed. Unfortunately one of
> my two btrfs partitions would not mount after rebooting, this is the
> error log:
> [ 1518.147030] device label MediaNew devid 1 transid 28844 /dev/sdc3
> [ 1518.147364] btrfs: enabling auto defrag
> [ 1518.147372] btrfs: use lzo compression
> [ 1518.632469] parent transid verify failed on 498530500608 wanted
> 26696 found 27535
> [ 1518.632707] parent transid verify failed on 498530500608 wanted
> 26696 found 27535
> [ 1518.640263] parent transid verify failed on 498530500608 wanted
> 26696 found 27535
> [ 1518.640279] parent transid verify failed on 498530500608 wanted
> 26696 found 27535
> [ 1518.660243] btrfs: open_ctree failed
> 
> Tried btrfsck after a lot of messages got:
> ...
> leaf parent key incorrect 563096514560
> Unable to find block group for 0
> btrfsck: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.

   btrfsck doesn't fix anything. It just checks the FS and tells you
that there's something wrong (which it just did). If you're feeling
very very brave, there's the "dangerdonteveruse" branch of the
btrfs-progs tools in cmason's git, which might fix things.
Alternatively, it might fuck up your filesystem so badly there's no
way you can retrieve any remaining data from it. Your choice.

> My kernel 3.0.0-16-generic, any hope for this ? Or is he dead jim ? I
            ^^^^^ Old, old, old. It's a bit late now, but you should
                  really keep up with the latest kernels. That should help
				  minimise this kind of event.

> don't have any snapshots of the partition.

   btrfs snapshots wouldn't help here. LVM snapshots would, of course.

   There's a restore tool that may allow you to copy off any data
that's not backed up (you *do* have backups, right? for an
experimental filesystem?). See the wiki at [1].

   Hugo.

[1] http://btrfs.ipv5.de/index.php?title=Restore

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "I will not be pushed,  filed, stamped, indexed, briefed, ---    
               debriefed or numbered.  My life is my own."               

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPcOZUIKyzvlFcI40RAve8AKCpFOa/l3LQ190KQvlUhvIZrAZxxQCfURW7
JrOZicp/3mgMgvFTNp1e4Dw=
=tudf
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
