Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44624 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbaCNIkZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 04:40:25 -0400
Date: Fri, 14 Mar 2014 08:40:20 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove transaction from send
Message-ID: <20140314084020.GG6151@carfax.org.uk>
References: <1394739733-500-1-git-send-email-jbacik@fb.com>
 <20140313221628.GF6151@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z9ECzHErBrwFF8sy"
In-Reply-To: <20140313221628.GF6151@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--z9ECzHErBrwFF8sy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 13, 2014 at 10:16:28PM +0000, Hugo Mills wrote:
> On Thu, Mar 13, 2014 at 03:42:13PM -0400, Josef Bacik wrote:
> > Lets try this again.  We can deadlock the box if we send on a box and try to
> > write onto the same fs with the app that is trying to listen to the send pipe.
> > This is because the writer could get stuck waiting for a transaction commit
> > which is being blocked by the send.  So fix this by making sure looking at the
> > commit roots is always going to be consistent.  We do this by keeping track of
> > which roots need to have their commit roots swapped during commit, and then
> > taking the commit_root_sem and swapping them all at once.  Then make sure we
> > take a read lock on the commit_root_sem in cases where we search the commit root
> > to make sure we're always looking at a consistent view of the commit roots.
> > Previously we had problems with this because we would swap a fs tree commit root
> > and then swap the extent tree commit root independently which would cause the
> > backref walking code to screw up sometimes.  With this patch we no longer
> > deadlock and pass all the weird send/receive corner cases.  Thanks,
> 
>    There's something still going on here. I managed to get about twice
> as far through my test as I had before, but I again got an "unexpected
> EOF in stream", with btrfs send returning 1. As before, I have this in
> syslog:
> 
> Mar 13 22:09:12 s_src@amelia kernel: BTRFS error (device sda2): did not find backref in send_root. inode=1786631, offset=825257984, disk_byte=36504023040 found extent=36504023040\x0a
> 
>    So, on the evidence of one data point (I'll have another one when I
> wake up tomorrow morning), this has made the problem harder to trigger
> but it's still possible.

   Data point two has arrived, and it's gone boom at about the same
point. The first failed at:
2014-03-13 22:09:11,749    INFO Read 7247356514 bytes total
and the second at:
2014-03-14 03:53:46,990    INFO Read 7247357071 bytes total
at approximately 1h45 into the process. The boot and home subvols have
been OK, and have been backing up happily all this time, but both are
smaller than the (~10 GiB) root subvol.

   I can add a load of data to /home and see if the problem happens
with a larger send size, or if it's just the process writing to a
subvol that has the snapshot being sent that causes it.

   The interesting thing here is that the error seems to be fairly
reliably in the same place (more or less). Before this patch, I was
seeing lockups (or EOF, with the earlier version of this patch) at
approximately 3.6-3.8 GB. Now it looks like it's going to be 7.2 GB.

   At least it's not locking up any more, just dying noisily (which is
marginally preferable).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- Hail and greetings.  We are a flat-pack invasion force from ---   
                     Planet Ikea. We come in pieces.                     

--z9ECzHErBrwFF8sy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUyLAdFheFHXiqx3kAQJd8hAAnPhQ9EJPpSvn0M4g3wxl1eyHYozlvOPF
mj831IvLP4/3okgXmUJWYsDrLALFyoCU+stJHyyx7XefINQhZ+053MxhdRlr/vgG
R4hAlhGbdf0g2AQOf5tMfWQEVju6eyw+2inbl+Xe4aTxND7bMzP6CfAZOIQCh2Im
ELdV6m2EPeRJptMFxo3ioYmHqjW0FqSrf3eZ1+F/zHKjENiayyGyA6h0A/BESq5/
gMaLxG6CTUuBYJr53XpP7nBzJefZvaxqjFnTBhFDm0lwXVxxQpJ1QCQ4xa3bLIL0
N6HvDzortzawh6sxFBdWB8Fzt3DT8toSDiWXRzqzKp9BXOKAur3vHgyOteR9SH5b
MLHr7EUc2dnGGT5ch18FyYEJjkgBozN5BG2Qkjylx1FNZm6kTIhHH7x0B7w8/iOm
umEkA9eJGgIrJY9zsDRXLmG9UF1EhrSLf47Q3iex/f50Vr7/BbYGk53Hy4bi4Z6e
KtqZUvsLIGdqWFCxGMWh5j1U6UIrwBZ1OJtIw3lbHspfSt0yLueBo3NmDy56QgR0
NchbGrpHsLWJ8fa4980os7OGYk703hjb6LgIZbzEna2CUV2UswXzkf35Nfw1/L87
YYZ4qQYxAC9CRXYexs/9ouZKvtRw/c4Su1I4pK9KQkDUd6/JdNuXEXUOgoYlS/O4
CpJe19Eey6g=
=8pgB
-----END PGP SIGNATURE-----

--z9ECzHErBrwFF8sy--
