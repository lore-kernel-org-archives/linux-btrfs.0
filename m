From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] mkfs: Handle creation of filesystem larger than the first
 device
Date: Wed, 08 Feb 2012 22:05:26 -0500
Message-ID: <4F3337F6.7010900@ubuntu.com>
References: <1327593785-23466-1-git-send-email-jack@suse.cz> <4F32F0AB.8030003@ubuntu.com> <20120208232015.GE1696@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120208232015.GE1696@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/08/2012 06:20 PM, Jan Kara wrote:
>   Thanks for your reply. I admit I was not sure what exactly size argument
> should be. So after looking into the code for a while I figured it should
> be a total size of the filesystem - or differently it should be size of
> virtual block address space in the filesystem. Thus when filesystem has
> more devices (or admin wants to add more devices later), it can be larger
> than the first device. But I'm not really a btrfs developper so I might be
> wrong and of course feel free to fix the issue as you deem fit.

The size of the fs is the total size of the individual disks.  When you limit the size, you limit the size of a disk, not the whole fs.  IIRC, mkfs initializes the fs on the first disk, which is why it was using that size as the size of the whole fs, and then adds the other disks after ( which then add their size to the total fs size ).  It might be nice if mkfs could take sizes for each disk, but it only seems to take one size for the initial disk.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPMzf2AAoJEJrBOlT6nu75Ci8H/j3+8AR5H+UGOzpwMEBmPViJ
PCVc5fAqOgLlQgjAII9dF74/1a6NyC9hjWBXPlhfrc3rA0JBj6x2AknvGnTQ6/Xo
4hMu8sFSSOtHf/aTXh7B7YJ/WrqDgkiEOSpcRVJyltzhKt0bbE3t9/IfxAhvkB1z
3CuEs9UeIn9wOV2fcyXoNMWpPQ+tNkxrvE817BHjPdQ5Z1+d2Cc0AxM22lgBVsZZ
J+oneFOeqSIGZ9hbr0WVEjHaWJpxEapNmVGE5RIrpneTGpe3eAijqbBa8TEg+C2R
iVCT7tBG3gOGhRoApMNM2IP2TgGLHMRgwP8QQv4/9MTNrOEP3G77tbCDHBfKMNA=
=g+5L
-----END PGP SIGNATURE-----
