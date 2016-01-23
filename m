Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43144 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcAWXzj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:55:39 -0500
Date: Sat, 23 Jan 2016 23:55:36 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] btrfs send -e option always fails ERROR: unexpected EOF in
 stream.
Message-ID: <20160123235536.GZ422@carfax.org.uk>
References: <CAJCQCtRyyu3rdyyykEjf8neLh3R+12to_gcCpU2ss51dU-_7PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sT0SRK93LqpGW452"
In-Reply-To: <CAJCQCtRyyu3rdyyykEjf8neLh3R+12to_gcCpU2ss51dU-_7PA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--sT0SRK93LqpGW452
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 23, 2016 at 04:48:26PM -0700, Chris Murphy wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=111221
> 
> 4.4.0-1.fc24.x86_64
> btrfs-progs-4.3.1-1.fc23.x86_64
> 
> 
> 
> [...snip...]
> BTRFS_IOC_SEND returned 0
> joining genl thread
> At subvol testsub.1
> ERROR: parent determination failed for 0

   This looks to me like a known and somewhat awkward bug/misfeature
where the mountpoint containing either the subvol being sent or the
target location for the receive is not a top-level mount, which causes
this error. i.e., this will (I think) fail:

# mount -o subvol=@foo /dev/sda1 /mnt
# btrfs send /mnt/@whatever | ...

   Can you try again from within a subvolid=0 mount?

   Hugo.

> chown temp/cockpit-shell-0.91-1.fc23.noarch.rpm - uid=0, gid=0
> chmod temp/cockpit-shell-0.91-1.fc23.noarch.rpm - mode=0644
> utimes temp/cockpit-shell-0.91-1.fc23.noarch.rpm
> mkfile o270-134474-0
> rename o270-134474-0 -> temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm
> utimes temp
> set_xattr temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm -
> name=security.selinux data_len=38
> data=unconfined_u:object_r:admin_home_t:s0
> truncate temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm size=37322
> chown temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm - uid=0, gid=0
> chmod temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm - mode=0644
> utimes temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm
> ERROR: unexpected EOF in stream.
> 
> The same ERROR messages happens even if I use -p to specify the parent.
> 
> Sending conventionally one at a time with -p works OK.
> 
> 

-- 
Hugo Mills             | Great films about cricket: The Third Man
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--sT0SRK93LqpGW452
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWpBL3AAoJEFheFHXiqx3kg60P/iFXCK1YxYCCnD7UuwNAoDRv
XZhUxIrBs6HHdSftlLP4tKcKkR6rI2i9rf/t2im0BOAvRzyXA4978RHReUCEst1Q
KHXNTLUaEpwHMOKcdrBzEe2/Y12kjoF+gDWlZ3BU5DqD+udPkuiq/8d+/VAwFDxS
N5Z0S+4kXW8HLEPgRAyPMYuBcKyFuaE06LGdAG1XSlxOrz9qXMNKBhry/a84GB3D
+ramS5Z4bjbwJDNHmdjCvWxnyr63mZtKylyaD32twUXhC8eXJ8YLRaaQ6zNxMwuP
N59JAWhVCVEoPp145v9wucYVlLH5sDVdLdTgdlomBy4bqYQZSm+p3hrqRGVm6MeP
Xytvi+LHV2kImqYgDxv1gnIryPeEulUC2nExQNg6kMfMDlo2/4Hy7LPq8gnXIoxO
lxY2NVkkXGyxTuPVh40/bxBYOYY8ZRP1AlgSUhIk6kfNHL4dnKu6evLOMm5E1teA
yOldCsY+GdmDyi7JdVd4LTbWYxjtr8ZAqrE8o+KI7hfxeKEm8kjEKHuY2DWS4J9c
voo2DPfztCz6IsxQ6c5uNv5PXTQjxsOvCnxa6EInh7XkME93wPVkfSkfoIPOXIhR
4HP6IUl5pBJ1b1Nt3VPwAUhk/hUmsVDJClTdh0By1G/HGv19gyszlROEtExxRVCu
lHTkIoV4VALepzHoU0Rg
=5AIE
-----END PGP SIGNATURE-----

--sT0SRK93LqpGW452--
