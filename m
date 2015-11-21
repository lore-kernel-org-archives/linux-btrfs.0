Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44565 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbKUUI5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Nov 2015 15:08:57 -0500
Date: Sat, 21 Nov 2015 20:08:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Brenton Chapin <bzipitidoo@gmail.com>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: free space is missing after dist upgrade on lzo compressed vol
Message-ID: <20151121200854.GM24333@carfax.org.uk>
References: <CALuXmTBWN3_PLnm4uh7u1SmGA2+5_VvNou-BLtv4=+Jvjjdz1Q@mail.gmail.com>
 <20151113223816.GI24333@carfax.org.uk>
 <CALuXmTDsK6PbNNRV=tTcp+O0Fx-xAceAN3O1BqdjFSpno7KBow@mail.gmail.com>
 <CAGqmi779f9cEQJN4GtJ02pCW03DCB4SCX50arHY3kqK2bUNB1g@mail.gmail.com>
 <CALuXmTDKiQwBnGuGF5MsoD9d_wfv+LVyVxWbmnyEz_nCB-5qkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cW27jhpBl+zg4ncD"
In-Reply-To: <CALuXmTDKiQwBnGuGF5MsoD9d_wfv+LVyVxWbmnyEz_nCB-5qkg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--cW27jhpBl+zg4ncD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 21, 2015 at 12:32:12PM -0600, Brenton Chapin wrote:
> Thanks, snapshots, or subvolumes, was it.  (I'm not clear on the
> distinction between a snapshot and a subvolume.)

   A snapshot is just a subvolume that's initialised (via CoW copies)
with the contents of some other subvolume, rather than starting empty.

   Hugo.

>  The 8G amount and
> that I did 2 distribution upgrades was a clue.  When I searched for
> info on btrfs and snapshots, I eventually found this command, with
> these results:
> 
> btrfs subvolume list -p /
> ID 257 gen 16615 parent 5 top level 5 path @
> ID 262 gen 15857 parent 5 top level 5 path
> @apt-snapshot-release-upgrade-vivid-2015-11-12_15:49:30
> ID 266 gen 16544 parent 257 top level 257 path var/lib/machines
> ID 268 gen 16203 parent 5 top level 5 path
> @apt-snapshot-release-upgrade-wily-2015-11-13_04:10:00
> 
> Seems these subvolumes (snapshots?) are nowhere visible in the file
> system.  Now I'm trying to figure out the correct commands to delete
> them.  "btrfs subvolume delete @apt-snapshot..." gave "ERROR: error
> accessing '@apt-snapshot...", while "btrfs sbuvolume show " on
> variations of the name keep giving me "ERROR: finding real path for
> '...', No such file or directory."  No luck so far.  What am I
> missing?
> 
> On Sat, Nov 14, 2015 at 3:16 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> > Ubuntu create snapshot before each release upgrade
> > sudo mount /dev/sda6 /mnt -o rw,subvol=/;
> > ls /mnt
> >
> > 2015-11-14 9:16 GMT+03:00 Brenton Chapin <bzipitidoo@gmail.com>:
> >> Thanks for the ideas.  Sadly, no snapshots, unless btrfs does that by
> >> default.  Never heard of snapper before.
> >>
> >> Don't see how open files could be a problem, since the computer has
> >> been rebooted several times.
> >>
> >> I wonder... could the distribution upgrade have moved all the old
> >> files into a hidden trash directory, rather than deleting them?  But
> >> du picks up hidden directories, I believe.  Doesn't seem like that
> >> could be it either.
> >>
> >> On Fri, Nov 13, 2015 at 4:38 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> >>> On Fri, Nov 13, 2015 at 04:33:23PM -0600, Brenton Chapin wrote:
> >>>> I was running Lubuntu 14.04 on btrfs with lzo compresssion on, with
> >>>> the following partition scheme:
> >>>>
> >>>> sda5   232M  /boot
> >>>> sda6   16G   /
> >>>> sda7   104G /home
> >>>>
> >>>> (sda5 is ext4)
> >>>>
> >>>> I did 2 distribution upgrades, one after the other, to 15.04, then
> >>>> 15.10, since the upgrade utility would not go directly to the latest
> >>>> version.  This process did a whole lot of reading and writing to the
> >>>> root volume of course.  Everything seems to be working, except most of
> >>>> the free space I had on sda6 is gone.  Was using about 4G, now df
> >>>> reports that the usage is 12G.  At first, I thought Lubuntu had not
> >>>> removed old files, but I can't find anything old left behind.  I began
> >>>> to suspect btrfs, and checking, find that du shows only 4G used on
> >>>> sda6.  Where'd the other 8G go?
> >>>
> >>>    Do you have snapshots? Are you running snapper, for example?
> >>>
> >>>    The other place that large amounts of space can go over an upgrade
> >>> is in orphans -- files that are deleted, but still held open by
> >>> processes, and which therefore can't be reclaimed until the process is
> >>> restarted. I've been bitten by that one before.
> >>>
> >>>    Hugo.
> >>>
> >>>> "btrfs fi df /" reports the following:
> >>>>
> >>>> Data, single: total=11.01GiB, used=10.58GiB
> >>>> System, DUP: total=8.00MiB, used=16.00KiB
> >>>> System, single: total=4.00MiB, used=0.00B
> >>>> Metadata, DUP: total=1.00GiB, used=397.80MiB
> >>>> Metadata, single: total=8.00MiB, used=0.00B
> >>>> GlobalReserve, single: total=144.00MiB, used=0.00B
> >>>>
> >>>> "btrfs filesystem show /" gives:
> >>>>
> >>>> Label: none  uuid: 4ea4ac08-ff37-4b51-b1a3-d8b21fd43ddd
> >>>>     Total devices 1 FS bytes used 10.97GiB
> >>>>     devid    1 size 15.02GiB used 13.04GiB path /dev/sda6
> >>>>
> >>>> btrfs-progs v4.0
> >>>>
> >>>> "du --max-depth=1 -h -x" on / shows:
> >>>>
> >>>> 29M    ./etc
> >>>> 0    ./media
> >>>> 16M    ./bin
> >>>> 354M    ./lib
> >>>> 4.0K    ./lib64
> >>>> 0    ./mnt
> >>>> 160K    ./root
> >>>> 12M    ./sbin
> >>>> 0    ./srv
> >>>> 4.0K    ./tmp
> >>>> 3.1G    ./usr
> >>>> 442M    ./var
> >>>> 0    ./cdrom
> >>>> 3.8M    ./lib32
> >>>> 3.9G    .
> >>>>
> >>>> And of course df:
> >>>>
> >>>> /dev/sda6        16G   12G  2.5G  83% /
> >>>> /dev/sda5       232M   53M  163M  25% /boot
> >>>> /dev/sda7       104G   46G   57G  45% /home
> >>>>
> >>>> And mount:
> >>>>
> >>>> mount |grep sda
> >>>> /dev/sda6 on / type btrfs
> >>>> (rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@)
> >>>> /dev/sda5 on /boot type ext4 (rw,relatime,data=ordered)
> >>>> /dev/sda7 on /home type btrfs
> >>>> (rw,relatime,compress=lzo,space_cache,subvolid=257,subvol=/@home)
> >>>>
> >>>> uname -a
> >>>> Linux ichor 4.2.0-18-generic #22-Ubuntu SMP Fri Nov 6 18:25:50 UTC
> >>>> 2015 x86_64 x86_64 x86_64 GNU/Linux
> >>>>
> >>>> I can live with the situation, but recovering that space would be nice.
> >>>

-- 
Hugo Mills             | Le Corbusier's plan for improving Paris involved the
hugo@... carfax.org.uk | assassination of the city, and its rebirth as tower
http://carfax.org.uk/  | blocks.
PGP: E2AB1DE4          |                   Robert Hughes, The Shock of the New

--cW27jhpBl+zg4ncD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWUM9WAAoJEFheFHXiqx3kIiQP/3s97lZQTgENFkNv7U8m79Xi
VWdnR6ddMCtnNkJnAD+lcaSFGM4q8bWdPqcLpvzgUFlhGw8agTNN9ndvWXWg66sy
RjefgLjTklXxEX5UqCMl1aErv7tvoqy6u5E1uUu6+sLYMStcxRfEWhgSO954Q+WJ
lWR0k2ETqTF7Lhh1PWAmxOI0PTFL5iqUyF7+uuhjdm99QLA9US20rFtCCFS8cTsW
NfIzVPzbFVI9n7allBiIpffX7Gm+VUFtCbUUJUGIGa1BztCCp5wgK+BT06Y0arTD
BAh9kR9lm8WS7jdBQv+BVJAQQYyJfJ+UYcC+goIY0qcgENJYurFZkqoycWmnVkQq
EAqXBY/1VWlixohBCL7AEeoc8qxPSJSZ708h29dnlWIoFGLv+Hesp2EnesxMNrCa
SOOvmfdjFlIexWv86m3AwgCJKwXLNfTCY4pjRCvo3k47jZIRd6UmTqLdcBuiRJ27
0nObo86KXPpFxucEo6tzNhQpxNBXSBKdEVFPU2Zg+J2PbGUhJZ/YKho6E3FPoHtG
3gZsS4AINZoXoD9epKFh4o6oBQzHjIN0m1IbNZ72aQfhfSeCBx6ZdL8FC4BuY/lq
1/yRr5G2aH0D1tIvMIlNKC6Nyn2d1BUx/DVq+SziOBhDBccSRlDDwrYfMAcx/ibi
z4eyoiLhRsaLShhN3aZn
=5a8e
-----END PGP SIGNATURE-----

--cW27jhpBl+zg4ncD--
