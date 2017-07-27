Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60280 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdG0TyS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 15:54:18 -0400
Date: Thu, 27 Jul 2017 19:53:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alan Brand <alan@georgiabrands.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Raid0 rescue
Message-ID: <20170727195357.GV7140@carfax.org.uk>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
 <20170727151038.GT7140@carfax.org.uk>
 <CAFcRpx7d=RPdt7iWY7bVeRdX8K7vV7=JYMRg8MVHveC=3qdfqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="f5XwDZYQieeN6n9K"
In-Reply-To: <CAFcRpx7d=RPdt7iWY7bVeRdX8K7vV7=JYMRg8MVHveC=3qdfqg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--f5XwDZYQieeN6n9K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 03:43:37PM -0400, Alan Brand wrote:
> Correct, I should have said 'superblock'.
> It is/was raid0.  Funny thing is that this all happened when I was
> prepping to convert to raid1.

   If youre metadata was also RAID-0, then your filesystem is almost
certainly toast. If any part of the btrfs metadata was overwritten by
some of the NTFS metadata, then the FS will be broken (somewhere) and
probably not in a fixable way.

> running a btrfs-find-root shows this (which gives me hope)
> Well block 4871870791680(gen: 73257 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639933562880(gen: 73256 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639935168512(gen: 73255 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639926239232(gen: 73242 level: 0) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> 
> but when I run btrfs
> inspect-internal dump-tree -r /dev/sdc1
> 
> checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
> checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
> checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
> checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
> bytenr mismatch, want=874856448, have=8568478783891655077

   This would suggest that some fairly important part of the metadata
was damaged. You'll probably spend far less effort recovering the data
by restoring your backups than trying to fix this.

   Hugo.

> root tree: 4871875543040 level 1
> chunk tree: 20971520 level 1
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 4871875559424 level 2
> device tree key (DEV_TREE ROOT_ITEM 0) 4635801976832 level 1
> fs tree key (FS_TREE ROOT_ITEM 0) 4871870414848 level 3
> checksum tree key (CSUM_TREE ROOT_ITEM 0) 4871876034560 level 3
> uuid tree key (UUID_TREE ROOT_ITEM 0) 29376512 level 0
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> checksum verify failed on 728891392 found F4F3A4AD wanted E6D063C7
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> bytenr mismatch, want=728891392, have=269659807399918462
> total bytes 5000989728768
> bytes used 3400345264128
> 
> 
> 
> On Thu, Jul 27, 2017 at 11:10 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Thu, Jul 27, 2017 at 10:49:37AM -0400, Alan Brand wrote:
> >> I know I am screwed but hope someone here can point at a possible solution.
> >>
> >> I had a pair of btrfs drives in a raid0 configuration.  One of the
> >> drives was pulled by mistake, put in a windows box, and a quick NTFS
> >> format was done.  Then much screaming occurred.
> >>
> >> I know the data is still there.
> >
> >    Well, except for all the parts overwritten by a blank NTFS metadata
> > structure.
> >
> >>   Is there anyway to rebuild the raid
> >> bringing in the bad disk?  I know some info is still good, for example
> >> metadata0 is corrupt but 1 and 2 are good.
> >
> >    I assume you mean superblock there.
> >
> >> The trees look bad which is probably the killer.
> >
> >    We really should improve the error messages at some point. Whatever
> > you're inferring from the kernel logs is probably not quite right. :)
> >
> >    What's the metadata configuration on this FS? Also RAID-0? or RAID-1?
> >
> >> I can't run a normal recovery as only half of each file is there.
> >
> >    Welcome to RAID-0...
> >
> >    Hugo.
> >

-- 
Hugo Mills             | Great oxymorons of the world, no. 1:
hugo@... carfax.org.uk | Family Holiday
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--f5XwDZYQieeN6n9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZekTVAAoJEFheFHXiqx3kPgAP/3/GcOStjMT/LNjF0PYYWKSq
nm0nD1gl7piLq7dShBP4NH5aeCoTO/+W9gZIDU1Uyz45YpuHnjUfxvgACQjn7Jaj
jO6Y3uM8eTxaXiWrR7lfM0Z9t1l2POsFqyIs1pcn7Ry6sfALpu572Gi3UeKtSqZT
YSImiW5WyPUPZ4pj8InEUl3MyAQTHMtD6QfirntGCX6T7KOjeuM2C4kstYe8eQPp
jwqOolRPT1WxtRfb7HalgD85M31KDVtN2G/ukOejGjp9RP+Uiw4vLqYQ1EAmQCM0
RKn/TJPOOUlxVLlpKZTBs5dD7JS3vDJxMQCBDO3sRPx933NUJPs7MjuQhgRPzgXN
qO3hUJuiutR6I9m+25GH/34pEpgOiTTzRH2lrRRucXHjeVF+k62BoUuXHkUmj2RP
wLIiaygOxkSKLou13m2/+ahv+n36txgGHE02UuL1T/u0RVMvexx4HpkF7bmuYQty
BwwMi2ceQsr9zUHohZCJKCMWGWj78Mylb0IFpC7pPmH7z7x2jO4UEPYnUgkGNdTE
OLAR2TiFwjIzSzGwcan+IXXNYUC9N6VR0HZbuB0EZGwApW4IGdNRxVJLZMfA4bT9
9d48KlTCVo0SjvfjK40Hn5vm0nmicguu2TuzeuWfxsXnjhglgkNkQk/a83XxeKVU
91wFhLzvgFKDWMlDDo0X
=2GdJ
-----END PGP SIGNATURE-----

--f5XwDZYQieeN6n9K--
