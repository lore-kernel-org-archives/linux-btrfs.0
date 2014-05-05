Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44341 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaEEVRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 17:17:41 -0400
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WhQGZ-0000Qr-4t
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 21:17:40 +0000
Received: from hrm by ruthven.carfax.org.uk with local (Exim 4.82)
	(envelope-from <hrm@carfax.org.uk>)
	id 1WhQGY-0005Aw-J4
	for linux-btrfs@vger.kernel.org; Mon, 05 May 2014 22:17:38 +0100
Date: Mon, 5 May 2014 22:17:38 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Thoughts on RAID nomenclature
Message-ID: <20140505211738.GS24298@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9pXJW6w71JX4l3T"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--s9pXJW6w71JX4l3T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   A passing remark I made on this list a day or two ago set me to
thinking. You may all want to hide behind your desks or in a similar
safe place away from the danger zone (say, Vladivostok) at this
point...

   If we switch to the NcMsPp notation for replication, that
comfortably describes most of the plausible replication methods, and
I'm happy with that. But, there's a wart in the previous proposition,
which is putting "d" for 2cd to indicate that there's a DUP where
replicated chunks can go on the same device. This was the jumping-off
point to consider chunk allocation strategies in general.

   At the moment, we have two chunk allocation strategies: "dup" and
"spread" (for want of a better word; not to be confused with the
ssd_spread mount option, which is a whole different kettle of
borscht). The dup allocation strategy is currently only available for
2c replication, and only on single-device filesystems. When a
filesystem with dup allocation has a second device added to it, it's
automatically upgraded to spread.

   The general operation of the chunk allocator is that it's asked for
locations for n chunks for a block group, and makes a decision about
where those chunks go. In the case of spread, it sorts the devices in
decreasing order of unchunked space, and allocates the n chunks in
that order. For dup, it allocates both chunks on the same device (or,
generalising, may allocate the chunks on the same device if it has
to).

   Now, there are other variations we could consider. For example:

 - linear, which allocates on the n smallest-numbered devices with
   free space. This goes halfway towards some people's goal of
   minimising the file fragments damaged in a device failure on a 1c
   FS (again, see (*)). [There's an open question on this one about
   what happens when holes open up through, say, a balance.]

 - grouped, which allows the administrator to assign groups to the
   devices, and allocates each chunk from a different group. [There's
   a variation here -- we could look instead at ensuring that
   different _copies_ go in different groups.]

   Given these four (spread, dup, linear, grouped), I think it's
fairly obvious that spread is a special case of grouped, where each
device is its own group. Then dup is the opposite of grouped (i.e. you
must have one or the other but not both). Finally, linear is a
modifier that changes the sort order.

   All of these options run completely independently of the actual
replication level selected, so we could have 3c:spread,linear
(allocates on the first three devices only, until one fills up and
then it moves to the fourth device), or 2c2s:grouped, with a device
mapping {sda:1, sdb:1, sdc:1, sdd:2, sde:2, sdf:2} which puts
different copies on different device controllers.

   Does this all make sense? Are there any other options or features
that we might consider for chunk allocation at this point? Having had
a look at the chunk allocator, I think most if not all of this is
fairly easily implementable, given a sufficiently good method of
describing it all, which is what I'm trying to get to the bottom of in
this discussion.

   Hugo.

(*) The missing piece here is to deal with extent allocation in a
similar way, which would offer better odds again on the number of
files damaged in a device-loss situation on a 1c FS. This is in
general a much harder problem, though. The only change we have in this
area at the moment is ssd_spread, which doesn't do very much. It also
has the potential for really killing performance and/or file
fragmentation.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
          --- ...  one ping(1) to rule them all, and in the ---          
                         darkness bind(2) them.                          

--s9pXJW6w71JX4l3T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2f/8lheFHXiqx3kAQIMZRAAnooUBFnL2Ayp9edwnRKVgLLW9Kjm9b5a
lZQ/eQUpfs/p8ULD39bI3ow8ZA3Ciuk6aj3uHaRXV9FBHis0gpiJ6q5dseu1m92E
JpPqg/6EaWgrX3oaY8IbXUlMTeQENw8sfwtgCOxHmyy892gNsoPozzJCGcnks+7h
J7jWMIfLjFRu68i+pmcVvyrYV6WoxySrRj91Sm9bv8dN7Sv+debKk6wv0Lpsd9ya
bcUkd00aOGwGzUxXPzbDKoE0GjC2IMRsyhxdJcrU2f8nNvvQnyJ+BKroQzNgFdn7
9q14SM0BdoxgdF8MobaFnxFp5ZEFcvoQ4CPuXoz54o5Hr9xIPGeCJg6rg6Nu2yxl
i1Qdz8o23lmxWTLdZVrrDJ08MQqCcoYTIRPGWIN++Vecjz5423KLeiyQWkPjMDov
rzQ4pvFECy1zhUGAZlnlni1yqxRPiRUXEzazuTOUBV4ao+GQfqWvA7hBDw8IkoVW
sbELPA0xqiPikSmxyzF31//9FAWICfZtmdd3d36XpLCT45P4ukh1pwZMLKEyHmvy
+GVBicPDYwUxNgkFWcTR35/i3ASNVBpJVMAj5O0IJXuP0EgaYt6JPJ63pG2zUCLM
LJJyKPFHkCP5AP+pJ16inL0gi3jYhWLYNXpCnTEr079XcB1BzHxvcSqsRCOi7Tr5
hoGGu3blmds=
=ZGfH
-----END PGP SIGNATURE-----

--s9pXJW6w71JX4l3T--
