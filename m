From: Jeff Mahoney <jeffm@suse.com>
Subject: Error handling: How to "lose" a transaction
Date: Tue, 13 Dec 2011 16:47:30 -0500
Message-ID: <4EE7C7F2.2080905@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mark Fasheh <mfasheh@suse.de>,
	Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hi Chris -

I'm starting to dig into the fun part of error handling and
btrfs_commit_transaction is a minefield right now.

I've been thinking about how I would go about recovering from a
serious error like an -EIO while writing out or an -ENOMEM in a deep
part of the code that it's prohibitively expensive to recover from.
Mostly I'm looking for the best way to make calling btrfs_std_error()
be functionally equivalent to killing the power on the disk. We
already block off new writers, but that's obviously nowhere near
enough. We could have an open transaction floating around, uncommitted
transactions queued, and then an unrecoverable error hits, forcing us
to shut it all down.

It seems to me that that a similar method of recovery that I wrote for
reiserfs can be used here as well. Am I understanding correctly that
if I go through the motions of committing the transaction *except* for
updating the tree roots, or maybe even doing that but declining to
write the superblocks out, that the transaction essentially doesn't
exist on disk? Including the allocations? The in-memory representation
will not match what's on disk, but that's what happens with every file
system in RO-failure mode. With CoW even for data, data is essentially
frozen in time as well. (I suppose with nodatacow that's not true, but
that's for another day.)

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJO58fxAAoJEB57S2MheeWyiH8P/RGfJUCwBoz83vLH5qRfsAzO
Rnfjq9/NS+58zh5MGImimr9u6ZuNCfNUEFUDXGnVwF2Er1jHh0orU1pQdvU9XlHv
T/vAyZp1s/emwwDPQX0Xo24QNumSzA2u7qnUuUBklq8l+KL99OZCErhu/eJ6i06S
vTv6KflsL/EU5ISgro051fVLGep0ZF5hLYOJHQbCJaRlL6OwC2d8cWHGR+qBdRaw
t4SQ+tVmKnnd4UzlpPzyQTCSOwdnSYtei28fCAy7X4rmycCXTa8eYQgvxkIabgkM
IF8F8utcKT2yTFyUbJM3MWUx0yzPVsL77XnO8FCfYbusYC1EPTnMSGJ1CbupHvr1
kmFJEOQ4rj8fxLzxYDdxjEJ7HtyIhQDfH1BZ1/0+e8BShepr7/60AwoNaWVOceN/
rDDkkKgIogprGO0un1Fv3J+FNPgIR/47t1ULSUTLhg4vAqbQRuYiI36Y2zlG7G2a
C/u/4UgrH40CVFVVtIRnjO67/QffTC3pf8Q6kzaXgotQJUt1XfY3a4X6MLQnfWKo
bBQaPTIpsxtf7k3cnH5XfjQqtljGgXrbBExtMPKBor7RDPVw3KrLm4F35Enr4Gur
pumzXQfiSC2oiSxpG1RXegZ2CXLKW4a/++kMApAOR98xTAHM8dzFhx0V0YZh/MHY
Sc+ddgI2v5ZIUL2IV3WK
=DmtI
-----END PGP SIGNATURE-----
