Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39783 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3KOP1F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 10:27:05 -0500
Date: Fri, 15 Nov 2013 15:27:01 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alin Dobre <alin.dobre@elastichosts.com>
Cc: linux-btrfs@vger.kernel.org, cwillu@cwillu.com
Subject: Re: Subvolume creation returns file exists
Message-ID: <20131115152701.GR4315@carfax.org.uk>
References: <528630D6.5090103@elastichosts.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xiprIVX1FSGBv8kC"
In-Reply-To: <528630D6.5090103@elastichosts.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--xiprIVX1FSGBv8kC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2013 at 02:33:58PM +0000, Alin Dobre wrote:
> We are using btrfs filesystems in our infrastructure and, at some
> point of time, they start refusing to create new subvolumes.
> 
> Each file system is being quota initialized immediately after its
> creation (with "btrfs quota enable") and then all subfolders under
> the root directory are created as subvolumes (btrfs subvolume
> create). Over time, these subvolumes may also be deleted. What's
> under subvolumes are just various files and directories, should not
> be related to this problem.
> 
> After a while of using this setup, without any obvious steps to
> reproduce it, the filesystem goes into a state where the following
> happens:
>     # btrfs subvolume create btrfs_mount/test_subvolume
>     Create subvolume 'btrfs_mount/test_subvolume'
>     ERROR: cannot create subvolume - File exists

   We've had someone else with this kind of symptom (snapshot/subvol
creation fails unexpectedly) on IRC recently. I don't think they've
got to the bottom of it yet, but the investigation is ongoing. I've
cc'd Carey in on this, because he was the one trying to debug it.

   Hugo.

> In regards to data, the filesystem is pretty empty, it only has a
> single empty directory. I don't know about the metadata, at this
> point.
> 
> The problem goes away if we disable and re-enable the quota. It all
> seems to be some dead metadata lying around.
> 
> Next are some facts about this. Since we found that it's the ioctl
> call which returns EEXIST, the place to further track the problem
> down was into the kernel module, which assumes that the userspace
> tools are not generating the problem. Here is a high level traceback
> of the problem:
>     ioctl.c:create_subvol() returns -EEXIST
>     cgroup.c:btrfs_qgroup_inherit() returns -EEXIST
>     qgroup.c:add_qgroup_item() returns -EEXIST
>     ctree.c:btrfs_insert_empty_item() returns -EEXIST
>     ctree.c:btrfs_search_slot() returns 0
>     ctree.c:key_search() returns 0
> 
> The problem appeared before our current kernel, which is a 3.8
> version (along with Btrfs progs v0.19), however mounting an already
> broken filesystem in a 3.12 kernel (with Btrfs progs
> v0.20-rc1-358-g194aa4a) doesn't do any better.
> 
> Any thoughts on this? We can provide you with more information, if
> needed, even the broken filesystem itself.

   

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- "What are we going to do tonight?" "The same thing we do ---     
            every night, Pinky.  Try to take over the world!"            

--xiprIVX1FSGBv8kC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUBUoY9RVheFHXiqx3kAQIrQQ/9HfGR8aRWsmCdRe59uYAjvaA0yctUOK7G
Uwc8aX/sT8rYGFU69yBhe0kXetR7ppPCOzp0FZRgWdJLUG952ODJ6/Y9K9T6AAco
teeedkp8fGR38RY8p1aCECEpJhNlLjVETlnkZhgO4YFN+EA/yIYbGs+U0Zg5HkYM
K21QqOeSnCcmWRYrduhnJGizhMAeGSOYMBkf8NKCmqDb12FnzmSw1Mx4lBqos7Uh
52nGXjymQ+anW4ahSPvh3RVsh+QVhbEkBEsAzGAZmgU8EvS2Fy+yN57qGWBmEXFP
XQ4qVM3sIp6qKJQiJDHmP2Is6iacM/a3Y4HY5vPvm6oBWhDNY3ph3PF6g4YLz9Hb
5GIx4AHUc4QIBj2ytyEe+rmLkRml6SwCYL9bHLQppZhxS/SAZo9PW1/K52UV6013
xmLBVexnHxTKqO7ZdVCrzV4J3G5Z60dmlwVDX4tk9ntuZ/gzhCYPRsAHJg5O8Pu7
WH9ZgrmGqh4c0iYrhK3shytcsWUdi20o+I3192wtkbG1LnXVbQ9vS/bTOV2s3LkG
dHkFex0WGmk8mjx26ocIWyq8CZ8Xp0mry+11CtdatukmRp1hozkFmWzK5lTfyid6
62lyK2+tALTY8JTsc/AdBge8dhSANKRXLlalxZ/c32UmH59CRv6q1aLEejSuETAU
F4uBIX1/tlU=
=5N/I
-----END PGP SIGNATURE-----

--xiprIVX1FSGBv8kC--
