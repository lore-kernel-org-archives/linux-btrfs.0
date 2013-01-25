Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:51905 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3AYMnQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 07:43:16 -0500
Date: Fri, 25 Jan 2013 12:43:11 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Gene Czarcinski <gene@czarc.net>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
Message-ID: <20130125124311.GB1371@carfax.org.uk>
References: <1359113550-23962-1-git-send-email-gene@czarc.net>
 <20130125175530.75402fb5@natsu>
 <51027AB8.6030901@czarc.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
In-Reply-To: <51027AB8.6030901@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 07:29:44AM -0500, Gene Czarcinski wrote:
> On 01/25/2013 06:55 AM, Roman Mamedov wrote:
> >On Fri, 25 Jan 2013 06:32:30 -0500
> >Gene Czarcinski <gene@czarc.net> wrote:
> >
> >>This patch hits a lot of files but adds little code.  It
> >>could be considered a bugfix,  Currently, when one of the
> >>btrfs user-space programs is executed by a regular user,
> >>the result if oftem a number of strange error messages
> >>which do not indicate the real problem.  This patch changes
> >>that situation.
> >>
> >>A test is performed as to whether the program is running
> >>as root.  If it is not, issue an error message and exit.
> >>Signed-off-by: Gene Czarcinski <gene@czarc.net>
> >$ ls -la /dev/sda
> >brw-rw---T 1 root disk 8, 0 Jan 15 12:11 /dev/sda
> >
> >The user does not have to be root, they can be a member of the group "disk" to
> >manage this device.
> >
> >Also some or all of the tools accept not just a block device, but also a
> >regular file as their parameter.
> >
> >Wouldn't it be better to check whether or not the running user has
> >*write access* to the device or file to be operated on, before failing?
> I knew there would be corner cases where root was not required for
> execution.  After all, I do not need to be root to execute "btrfs
> --version".  Now, is it worth the effort to determine the corner
> cases and do you have a proposed solution as to determining what
> privileges are needed when?  I can understand when it could be a
> regular file but is it all that common for users to be part of group
> disk?

   Don't try to check all the possible success conditions beforehand
-- that's what leads to websites that fail to work because your
browser is not IE, but work perfectly when you change your user-agent
string to "MSIE". This is highly frustrating for users.

   Instead, try whatever it is you were trying to do (open a file,
send an ioctl), and determine, as well as you can, why it failed by
looking at the error codes that you get back, and report that.
"Permission denied" -> means you don't have permissions -> you need to
be root, or have yourself put in the disk group, or get the
disk-management-capability. Let the user work out which of those
solutions they need, rather than forcing them to use the one you
thought of.

   Hugo.

> If there is a case where it is difficult to figure out if root is
> needed, then my solution would be to turn it into a warning message
> and remove the exit for that specific program.
> 
> However, I believe the real answer is to use sudo.
> 
> Gene
> >
> >>---
> >>  btrfs-corrupt-block.c | 5 +++++
> >>  btrfs-image.c         | 5 +++++
> >>  btrfs-map-logical.c   | 5 +++++
> >>  btrfs-select-super.c  | 5 +++++
> >>  btrfs-show-super.c    | 5 +++++
> >>  btrfs-show.c          | 5 +++++
> >>  btrfs-vol.c           | 5 +++++
> >>  btrfs-zero-log.c      | 5 +++++
> >>  btrfs.c               | 6 ++++++
> >>  btrfsck.c             | 5 +++++
> >>  btrfsctl.c            | 5 +++++
> >>  btrfstune.c           | 5 +++++
> >>  calc-size.c           | 5 +++++
> >>  convert.c             | 6 ++++++
> >>  debug-tree.c          | 5 +++++
> >>  dir-test.c            | 5 +++++
> >>  find-root.c           | 5 +++++
> >>  ioctl-test.c          | 6 ++++++
> >>  mkfs.c                | 5 +++++
> >>  quick-test.c          | 6 ++++++
> >>  restore.c             | 5 +++++
> >>  21 files changed, 109 insertions(+)
> 

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
           --- Quidquid latine dictum sit,  altum videtur. ---           

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUQJ9379z9OVl50rAAQIJnhAApH+L+oIrwRQeRzb4at3ZB8mzGEyFTs5T
OYrwoETXcKFBUe4CiYOXActegyNlM8ND+rVPRw+ZJhqlZpwGuTn2rlgcxLZD+9F/
vb1XUnWkrg9aW1wh+0+ElaMuSIdPfU9lcZQESEt6AMkhfcq6uBCZLwbBFp9zVd8t
TeRZIqNS3IA4z259N/GetD0F9dC+xrR87f5xUHOWbvciVW3q9Il0t9+1csUlbpZE
LjSdXvFOKwyuPVpLjrmpsy/wAtt+ltduAMnrCsSNEjdDD7vDFdYUWgmexWfeGPF8
DX1DkB/hORCrG30aFl5r12/RJ0Gh7LVE29eObyFKqXnNFY55O/OaP0V926skHnSz
qRCI0KVUl/0R6LYInLsWinr0HxnnbXhC9ZB7uYuLiYDHxiSTiVbSuD68PrDf6eUC
HkurBFv9CJZTP5vvNLpjkyd+C+a0iJ/W8D/E+0xNxwoGJ1999UVC+CZQjRe19Hfb
vyZzf3PcE2xcZGUEp6tsBrteLvxqRH/P6zE8CZlvlNyZhKt/JQx938wIo7fnpGQB
Cel1XqSfxKMae8QEqtApBPhIJz07TJE7bCbMZD3etRpX1UXf2xzEMOEJom1okIDr
4szzsl7wPcBDuWUqijlUaeCvbfAwFcRg3nKDE2fhE19fsoVPC5/jAXCP3A2Y+3y1
iFkw2UD8ZV4=
=9xEf
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
