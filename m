Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbaDDO4K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Apr 2014 10:56:10 -0400
Message-ID: <533EC80C.50300@suse.com>
Date: Fri, 04 Apr 2014 10:56:12 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
CC: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 3/4][RFC] btrfs: export global block reserve size as space_info
References: <cover.1391779611.git.dsterba@suse.cz> <21dfbfe3b1361092ad1dc286f636c1fff4a2a4f6.1391779611.git.dsterba@suse.cz> <52F90677.90107@fb.com>
In-Reply-To: <52F90677.90107@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/10/14, 12:03 PM, Chris Mason wrote:
> On 02/07/2014 08:34 AM, David Sterba wrote:
>> Introduce a block group type bit for a global reserve and fill
>> the space info for SPACE_INFO ioctl. This should replace the
>> newly added ioctl (01e219e8069516cdb98594d417b8bb8d906ed30d) to
>> get just the 'size' part of the global reserve, while the actual
>> usage can be now visible in the 'btrfs fi df' output during
>> ENOSPC stress.
>> 
>> The unpatched userspace tools will show the blockgroup as
>> 'unknown'.
>> 
> 
> This wasn't in my rc2 pull because I wanted to sync up with Jeff on
> it. I like the idea of combining this into SPACE_INFO, any
> objections?

Sorry, was on vacation when this went by and just got the ping. Yeah,
I have no objections here.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJTPsgMAAoJEB57S2MheeWyf1EP/158KhPm7KoT9EGeNUwv4+nb
Ex2z9hIbTduJ6rT9IG+n0vbV2Ka9IuWJDvYdoLLMIN1SFXOJdNo88MIf6aSTbHfb
WWqJJ1nMB/DnDMt1bXp6cZSGyzQuSXvI/u97Pgy3gzMpmjuzXy37c7JkFCABM352
G2IF+bZiHqa6X+eTxSjlimDKvIBOPGw/hOIvegRmqyqDMNIy5dwzDQIsytUuqsgQ
rl+fAt+R+VNdSe2ZEjn+FwviOpPrgR8TQL5Qycaoviqzd6apBtutlcJpfEIqCP8m
4guZ7bC/VjsUdJj1cxSYZe+Eh0dEas2T5qjH5DW5uyTmsKJAA3VM4lTaxITvQ0Y8
URxCQGSfAc0IUudpz+nCbLdwhUYtV/yfpA8i3Fnewyu8Jazvup0dxALo56RDu4Kf
j7K3kwTFlfB7D9/S10SbsWK3j/NR3qJu1DicG1Wy18Acl3oZvCgB4qGIaxh1vcsV
NZfkt+/5V+Mb0ocKEjdudO/sS0XNBJowMxmWOCZz6vGyKQTAWA+VYmZxJ/rKiOoG
O/YYmJ2VuzWI8KPFrhNny12UJ9AsyZLhDw4Sbr7iEDI/l/mtrL6WsK/krhMHKDdJ
wf4TWtM0CPyZS8ym6f2cgSdmvecaZ3AuK1Hd19DeMZnly6bwZV2TkNSXbfB+oAZO
HL7ZLY8oHLj4brTHFOIH
=fiJ0
-----END PGP SIGNATURE-----
