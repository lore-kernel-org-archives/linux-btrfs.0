Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47466 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdEJJyo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 05:54:44 -0400
Date: Wed, 10 May 2017 09:54:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Roman Mamedov <rm@romanrm.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Message-ID: <20170510095441.GI9701@carfax.org.uk>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <20170510121840.06aa01b2@natsu>
 <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
 <20170510074052.GG9701@carfax.org.uk>
 <6b19da67-47a3-6f75-a892-8812b84817ea@profihost.ag>
 <20170510090839.GH9701@carfax.org.uk>
 <b959d576-2136-1c0a-93be-0bfbd81ab52c@profihost.ag>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PMULwz+zIGJzpDN9"
In-Reply-To: <b959d576-2136-1c0a-93be-0bfbd81ab52c@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--PMULwz+zIGJzpDN9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 11:20:58AM +0200, Stefan Priebe - Profihost AG wrote:
> Hello,
> 
> here's the output:
> # for block in 163316514816 163322413056 163325722624; do echo $block;
> btrfs-debug-tree -b $block /dev/mapper/crypt_md0|sed -re 's/(\t| )name:
> .*/\1name: HIDDEN/'; done
> 
> 163316514816
> btrfs-progs v4.8.5
> leaf 163316514816 items 188 free space 1387 generation 86739 owner 3892
> fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
> chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
[...]
>         item 37 key (23760 DIR_INDEX 36) itemoff 14278 itemsize 58
>                 location key (28124232 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 28
>                 name: HIDDEN
>         item 38 key (23760 DIR_INDEX 37) itemoff 14220 itemsize 58
>                 location key (28124233 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 28
>                 name: HIDDEN
>         item 39 key (23760 DIR_INDEX 38) itemoff 14165 itemsize 55
>                 location key (28124234 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 25
>                 name: HIDDEN
>         item 40 key (23760 DIR_INDEX 22) itemoff 14115 itemsize 50
>                 location key (26923383 INODE_ITEM 0) type FILE
>                 transid 74009 data_len 0 name_len 20
>                 name: HIDDEN
>         item 41 key (23760 DIR_INDEX 23) itemoff 14067 itemsize 48
>                 location key (26923384 INODE_ITEM 0) type FILE
>                 transid 74009 data_len 0 name_len 18
>                 name: HIDDEN
[...]
> 163322413056
> btrfs-progs v4.8.5
> leaf 163322413056 items 113 free space 934 generation 86739 owner 3892
> fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
> chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
[...]
>         item 73 key (24016 DIR_INDEX 19) itemoff 9651 itemsize 62
>                 location key (28124251 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 32
>                 name: HIDDEN
>         item 74 key (24016 DIR_INDEX 20) itemoff 9592 itemsize 59
>                 location key (28124252 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 29
>                 name: HIDDEN
>         item 75 key (24016 DIR_INDEX 4) itemoff 9538 itemsize 54
>                 location key (26923401 INODE_ITEM 0) type FILE
>                 transid 74009 data_len 0 name_len 24
>                 name: HIDDEN
>         item 76 key (24016 DIR_INDEX 5) itemoff 9486 itemsize 52
>                 location key (26923402 INODE_ITEM 0) type FILE
>                 transid 74009 data_len 0 name_len 22
>                 name: HIDDEN
[...]
> 163325722624
> btrfs-progs v4.8.5
> leaf 163325722624 items 78 free space 6563 generation 86739 owner 3892
> fs uuid 37b15dd8-b2e1-4585-98d0-cc0fa2a5a7c9
> chunk uuid b86efe94-ab40-4344-ac6b-46ec59c41b8f
[...]
>         item 62 key (24189 DIR_INDEX 16) itemoff 9409 itemsize 64
>                 location key (28124267 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 34
>                 name: HIDDEN
>         item 63 key (24189 DIR_INDEX 17) itemoff 9349 itemsize 60
>                 location key (28124268 INODE_ITEM 0) type FILE
>                 transid 86739 data_len 0 name_len 30
>                 name: HIDDEN
>         item 64 key (24189 DIR_INDEX 4) itemoff 9296 itemsize 53
>                 location key (26923421 INODE_ITEM 0) type FILE
>                 transid 74010 data_len 0 name_len 23
>                 name: HIDDEN
>         item 65 key (24189 DIR_INDEX 5) itemoff 9236 itemsize 60
>                 location key (26923422 INODE_ITEM 0) type FILE
>                 transid 74010 data_len 0 name_len 30
>                 name: HIDDEN
[...]

   In each case, the tree node keys have simply been sorted
incorrectly -- the ordering is otherwise correct, but jumps backwards
at some point in the sequence. At least in the first instance, some of
the keys appear to have been duplicated: there are two (23760
DIR_INDEX 22) keys in the list. (I didn't check in detail with the
other two whether there are duplicates, but I wouldn't be surprised).

   I note that the jump in the keys in the first two cases is 16, and
the jump in the third case is 13. That _might_ suggest some kind of
bit-level error, but it's probably not in the RAM that was used to
store the blocks, as the error appears in a different place in each
block.

   I'm tentatively going to point the finger at your hardware for
this. It's probably going to need something really long and/or
stressful to pick it up, though (one of the CPU stress tests, for
example, and also a good long run with a RAM tester -- 24 hours or
longer).

   Hugo.

> Stefan
> Am 10.05.2017 um 11:08 schrieb Hugo Mills:
> > On Wed, May 10, 2017 at 10:40:31AM +0200, Stefan Priebe - Profihost AG wrote:
> >> Am 10.05.2017 um 09:40 schrieb Hugo Mills:
> >>> On Wed, May 10, 2017 at 09:36:30AM +0200, Stefan Priebe - Profihost AG wrote:
> >>>> Hello Roman,
> >>>>
> >>>> the FS is mountable. It just goes readonly when trying to write some data.
> >>>>
> >>>> The kernel msgs are:
> >>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >>>> block=163316514816,root=1, slot=39
> >>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >>>> block=163322413056,root=1, slot=74
> >>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >>>> block=163325722624,root=1, slot=63
> >>>> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> >>>> block=163316514816,root=1, slot=39
> >>>> BTRFS: error (device dm-2) in btrfs_drop_snapshot:8839: errno=-5 IO failure
> >>>> BTRFS info (device dm-2): forced readonly
> >>>> BTRFS info (device dm-2): delayed_refs has NO entry
> >>>
> >>>    Can you show the output of btrfs-debug-tree -b <blocknum>, where
> >>> <blocknum> is each of the three "block=" values above?
> >>
> >> Can do that. But the lists are very long - should i upload them to
> >> pastebin? Is it ok to remove the name atribute - which provides filenames?
> > 
> >    On the mailing list would be preferable, as then the conversation
> > is completely preserved in archives. They shouldn't be so long that
> > vger rejects them. And yes, if you want to filter out the filenames,
> > do so (but _just_ the filename -- don't remove the whole line).
> > 
> >    Hugo.
> > 
> >> Stefan
> >>
> >>
> >>>    Hugo.
> >>>
> >>>> Greets,
> >>>> Stefan
> >>>> Am 10.05.2017 um 09:18 schrieb Roman Mamedov:
> >>>>> On Wed, 10 May 2017 09:02:46 +0200
> >>>>> Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:
> >>>>>
> >>>>>> how to fix bad key ordering?
> >>>>>
> >>>>> You should clarify does the FS in question mount (read-write? read-only?)
> >>>>> and what are the kernel messages if it does not.
> >>>>>
> >>>
> > 

-- 
Hugo Mills             | Alert status mauve ocelot: Slight chance of
hugo@... carfax.org.uk | brimstone. Be prepared to make a nice cup of tea.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--PMULwz+zIGJzpDN9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZEuNhAAoJEFheFHXiqx3kc5oP/0NSI2qUEkZCEbNlKBuQE50L
CDLhjx4WhMFIVtpBXnfeTxR48P5yStUCArp+WpAxYxga+j9bYMQWGa8cyAK1NoCD
+QOK1Rt/Ts5ndsgIbyCTnknU3VI+FWybGqG2BRp2dALtmOem2dQnHcaOUrOOzDQ/
Gw6+wx0ve3AfLWMsnQSzNbYZrp87fkwMd+5veGZtUN80ZqNjQBtn5O3OG6Ei+/50
c5rN5rjdRNsPcIvL1d7ay1pB98j4CcwfKnCis+oyvJ+ns1jMVvgvdVf4t7y9B/HJ
VfUYIozh/TU/YU0wbRuM3MLOWvpbadutSMzeh98vrxYme8feS1cHbdv/vPoTORLo
4HofBNwouJ3XJig3rHMzdmgfiF6e+744kYrk6dgfEBHIT2W8ttV9Mqj0iDZxEDYm
5c3fD8JSzLaYVPTvYR05lk8NJauR058bK2SlllwhCQYqhJ9AJjOfkyyfjSvSysWH
FkhbC9H64z3WnXIA3QBLxQTz5b2GTO5vAGL7u0hUYPoVykBenN4AZA3JGDBFA8Gs
gb07oWg2xn++/2+z1XAQUXUub8a4vv3J7AtTReSKCZBYmcVS6W7AvEex9eKVpGEW
G81fnb+G9nqifVEDjvxaD/YWqjXNtVUhMiInRalvlIaD3uf+n7B3sv7vOVLZMLbR
nwNN7THJA2N/yeC2vAzr
=ZeJd
-----END PGP SIGNATURE-----

--PMULwz+zIGJzpDN9--
