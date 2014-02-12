Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:33963 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaBLQQX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 11:16:23 -0500
Date: Wed, 12 Feb 2014 16:15:55 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>,
        Goffredo Baroncelli <kreijack@libero.it>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140212161555.GQ6490@carfax.org.uk>
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
 <20140206194935.GT1364@twin.jikos.cz>
 <52F3EC15.1000508@libero.it>
 <20140206220535.GV1364@suse.cz>
 <52F4B0B8.2080804@oracle.com>
 <20140207102010.GE6490@carfax.org.uk>
 <20140212160123.GP16073@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1WN/MJ7JJGqVzwIW"
In-Reply-To: <20140212160123.GP16073@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--1WN/MJ7JJGqVzwIW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 12, 2014 at 05:01:23PM +0100, David Sterba wrote:
> On Fri, Feb 07, 2014 at 10:20:10AM +0000, Hugo Mills wrote:
> > On Fri, Feb 07, 2014 at 06:08:56PM +0800, Anand Jain wrote:
> > >  mainly here sysfs way defeats the purpose - debug as
> > >  mentioned. Sysfs would/should show only mounted disks,
> > 
> >    So let's find a way of showing the "known-about" data structure
> > separately from the "mounted" data structure. Just thinking aloud
> > here, how about something like this:
> > 
> > For unmounted, but known filesystems:
> > /sys/fs/btrfs/devmap/<UUID>/<symlink to device>   (for each device known)
> > /sys/fs/btrfs/devmap/<UUID>/label
> > /sys/fs/btrfs/devmap/<UUID>/complete      (0 if missing devices, 1 otherwise)
> > /sys/fs/btrfs/devmap/<UUID>/<other properties>
> 
> I like that, the device map represents the global state maintained by the
> module, does not interfere with the current sysfs structure.
> 
> One minor comment, the symlink to device should have probably a fixed
> name so it can be easily located.

   Two ways spring to mind: Number them according to the internal FS's
device numbers, so you'll have something like:

$ ls -l /sys/fs/btrfs/devmap/3993e50e-a926-48a4-867f-36b53d924c35
total 0
lrwxrwxrwx 1 root root    0 Feb  1 11:22 0 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:0:0/0:0:0:0/block/sda
lrwxrwxrwx 1 root root    0 Feb  1 11:22 1 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:1:0/0:1:0:0/block/sdb
lrwxrwxrwx 1 root root    0 Feb  1 11:22 2 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:2:0/0:2:0:0/block/sdc
lrwxrwxrwx 1 root root    0 Feb  1 11:22 3 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:3:0/0:3:0:0/block/sdd
-r--r--r-- 1 root root 4096 Feb  1 11:22 complete
-r--r--r-- 1 root root 4096 Feb  1 11:22 label

   Then you can find them easily by enumerating the filenames, and
anything which is composed entirely of digits [0-9] is a device.
Alternatively, put them into a subdirectory, and anything at all
within that subdir is a device symlink.

[snip]
> > >  the ioctl way doesn't have such a limitation (of course
> > >  as I commented memory dump way would have been best choice
> > >  but I got stuck with that approach if anybody wants to give
> > >  a try with that approach you are most welcome).
> > > 
> > >  IMO no harm to have both sysfs way and ioctl way let user
> > >  or developer use which were is suitable in their context.
> > 
> >    Extra maintenance overhead; divergence of the APIs. "You can find
> > out the label of the filesystem using sysfs, but not the ioctl. You
> > can find out the size of the filesystem using the ioctl, but not using
> > sysfs." That way lies quite a bit of pain for the user of the
> > interfaces.
> 
> I won't mind having several ways how to get the information, sysfs,
> ioctl or the properties. Each way has it's own pros and cons or is
> suitable for some type of user (C program, shell scripts).

   Fair enough. I do worry a little about the API divergence, though.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "What's so bad about being drunk?" "You ask a glass of water" ---  
                                                                         

--1WN/MJ7JJGqVzwIW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUvueO1heFHXiqx3kAQJqpw//ZMUooZeq0CLJpTTWrWQl0Zl14Fgvqtzq
0zHHcfl7/hVEz3ebacjzT7tToAKU14Cow8tbnGW54trwJiqAggtatYi+CCexsSKK
VEfGoNKGOMqNNbmEP6k2WOj2cr9sgSMjVXrVKFAgtsypiG2O5zFVWqEEoa3r732F
Mqm2sSTkEhMKeXKqm85QoFQck0dqW3A8DSeLDHwBe4t2Iw8AaCBvea/eavIQ0BsA
TPM6rYzAhqiL0EqRoZWry/3lDcFm7hkMUrzM/v0dKog6xN9i1H1ZQQ6b6akYAhyZ
4Cgkr3q2dVuQ3Iu3iDCIieO8QxRcokWmTp5Jt17sVXddweQAF4pcXCWN2IeOrjmv
AwsVyPqSFvX7C8CtLPq0uu8Od8iGYMJ8Q3a/A3wYFlmYXL3EYp/ZFEM7lXB0vHac
QM61KuTtUTVt3ix7JGhFYE7Wp2GpXwU/Mg/sPN1E4aTsZ4MrtWFy3rH/3XKZ5fga
r+DxHD+Pkjp/tOkzXKWE3Hs+B7PYzAgcHzK6jf51M1+du0zOTNu/+ouLDnuv7NEm
c7mCibH1F3/O3cGdW2mLGzqvSJZHVeG8NZ7AnnDdYLn7RFWw7QzJ7tjcC2DF4p9j
UCXthwEjWY9G6KTiY/msOtafOAdKnSTsAA/pBP1lCGkFVVz+kApNOk83VwwkIKJ9
rJkDR1LG0Cs=
=LgpO
-----END PGP SIGNATURE-----

--1WN/MJ7JJGqVzwIW--
