Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3CWSpj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 14:45:39 -0400
Message-ID: <514DF850.5080906@redhat.com>
Date: Sat, 23 Mar 2013 13:45:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: document mount options in Documentation/fs/btrfs.txt
References: <514DEB06.7000606@redhat.com> <20130324003321.7f119e91@natsu>
In-Reply-To: <20130324003321.7f119e91@natsu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/23/13 1:33 PM, Roman Mamedov wrote:
> On Sat, 23 Mar 2013 12:48:54 -0500
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
>> index 7671352..02a19c8 100644
>> --- a/Documentation/filesystems/btrfs.txt
>> +++ b/Documentation/filesystems/btrfs.txt
> 
> Is anyone really going to look for them there?
> 
> People expect mount options to be in "man mount".

It's traditional to document these options in the kernel docs:

# grep -il "mount options" Documentation/filesystems/*.txt
Documentation/filesystems/adfs.txt
Documentation/filesystems/affs.txt
Documentation/filesystems/autofs4-mount-control.txt
Documentation/filesystems/befs.txt
Documentation/filesystems/ceph.txt
Documentation/filesystems/devpts.txt
Documentation/filesystems/dlmfs.txt
...
<big snip>
...
Documentation/filesystems/udf.txt
Documentation/filesystems/vfat.txt
Documentation/filesystems/vfs.txt
Documentation/filesystems/xfs.txt


The mount manpage is maintained in the util-linux pkg,
but it's not kernel-version specific, and the util-linux
maintainer does not have specific knowledge of all filesytem
options.

I think kernel docs are the right place for the developers
to first document these things - it's easily updated as the code
change,s and is under the maintainer's direct control.  From there
the info can be periodically synced to the mount manpage
as needed.

Thanks,
- -Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRTfhQAAoJECCuFpLhPd7gyk8P/iifHpQ8250Gisg9Oza64mC6
YzluQA3XIYJr5xOnTu2ZWA/9znxlg0NWKWE2v7okDrL53nrAZNntWQESQ/PuoJsM
G2V+rkjRm3ojPJ3VgycaaPrlEOXW9AWsZYrYwnD3ZNYJ5e5MOxGx5LcYu5/OGvuW
lOi7jD9Q3OBFmu5vhRbXnZLgqBYbtMTUlESMZvUhrA4uxKnpPOLHrBwkZ1LzX26X
DIuJKqRlkyhqoJotBt+cRo8PCoR1yeremDXaT32MwdeFSEkRIXVIp78BruPATrdi
jt116adux7kP5NSa2odOQsSAmnESpXZvmDOaYUzNhUrM621c8LsNbkgC5twyaegd
92+vNkwFu73BJ2sDtyfkEXc4FV9PLhf2KNBJDaIJkneX9BiuQ1WC5u1UUrrQD3lM
j4j9PA2R35CTLfSTgu9bQ6Asy9YLgANtTZvKoEXrC8DGAHbaMK1d42NBg2b9mhxo
AEacnQNw2dK+1O2Y5BrSBs7cKWacazd/UnGlFDze42dtXZC+J70LeRs26YeJnf6j
xl6YSVY3kx62ttChMTYYzIKRh8RRQTrzVgrcflbedLhvZVchRSBIpRTUfQEXtiW+
yY8nUa7w6TdnPYa7dJ4rluhK7HdQ75cb81WOJKL4smU3HmX3uxIIa6kI5KtlWqYw
bYzRwrnSpQPLEdnOepI+
=YHWK
-----END PGP SIGNATURE-----
