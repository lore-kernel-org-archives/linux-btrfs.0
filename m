Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaEVPFk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 11:05:40 -0400
Message-ID: <537E1242.1010109@suse.com>
Date: Thu, 22 May 2014 11:05:38 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: don't remove raid type sysfs entries until unmount
References: <537D40EB.60906@fb.com> <537D5136.4050007@suse.com> <537DEB3F.5020303@fb.com>
In-Reply-To: <537DEB3F.5020303@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/22/14, 8:19 AM, Chris Mason wrote:
> Can we safely reinit a kobject that has been put in use in sysfs?
> Given all the things that can hold refs etc is this legal?

It depends on how the kobject is being used.

It wouldn't be safe to re-use the kobject embedded in space_info since
it controls the lifetime of the object, regardless of its use in sysfs.

The kobjects for block groups only exist for creating the
subdirectories and their lifetime is actually the lifetime of the
space_info. We take a reference to the space_info when we add them to
sysfs because that's where they draw their data. The only reference to
a block group kobject is taken when we add it to sysfs and is dropped
when we remove it. Holding a sysfs file open doesn't pin the kobject,
so once we remove it from sysfs (kobject_del waits for readers to
complete), it's safe to reinitialize it.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTfhJBAAoJEB57S2MheeWymZoP/Ru0dB9DDQW7eCgeOuXTNMZt
uy29gJsUjC6QoQagJ0aHT1SiNw9EFHuDnfrnUaOGxO2l0dDostdrU4xqH/632xVv
9o4QrTWtg0d7mN2+D4YaYLB/74Nd1O86CE+3zbmM8CY8Ueh+JMR63jSSU5k2zeCX
ts0dcdK31DBP/aoof6NS8KNdJOpi0dIiefH2Si4Zm2RYBxcMBrKpI8KIrhab1Bo6
vomgq4XkAZUK7G2C/gOmGdqMlSMwMsOhiZ2fYH7pdR74q4vPu6K+RnxFnIuOzmPi
nzMxvgYnjjn1+cynTmZD3xMj94MyCamV1wbj4jciIiDdNrr1XRJH1EMqA5T3wDN4
vw52dVm6sDGizO4/coU21WMum2IUrIbCESXK74Tef3FLWzRWerKeZStIYBYGmVuz
WGTfwUJ+SnhEwSAEHbYIDM8fogVvei2UlPAwQ4o2kSzM9kKf+E5YbwYJDbdKlQ0C
tF6kyZFzkJ2ZEEVGv7fqswHudkWGafrPxRCN9iMvxWUWcxNybh1PZ3MW45uvfyA7
UrZYuDruTS2WorYSivKdFi+9DgTxms/ekfiNi4SZQ5Z1JteAPU8AS5OAQOuo+UCD
uIdlRzorK/pzYH0c/qbN5vy/t+cBVYU6ya238R9eTbq1jQGWWZlZuwaUJQb9nhmS
yKBOJnpRMrJOpO6Onrrh
=0M9G
-----END PGP SIGNATURE-----
