Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:43724 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaI0QRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 12:17:45 -0400
Date: Sat, 27 Sep 2014 17:17:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: James Pharaoh <james@pharaoh.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS backup questions
Message-ID: <20140927161741.GB7191@carfax.org.uk>
References: <5426DA1B.9010503@pharaoh.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
In-Reply-To: <5426DA1B.9010503@pharaoh.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 05:39:07PM +0200, James Pharaoh wrote:
> Hi,
> 
> I'm trying to build a backup solution for a highly virtualized server
> environment, based on BTRFS. I have a lot of questions which I can't find
> the answers to, and have included some of the most important ones here.
> 
> 1. Simultaneous snapshots
> 
> I would really like to snapshot multiple subvolumes at the same time, so I
> can get a consistent view of my system. It seems like BTRFS should be able
> to provide this, given its data model, but I can't see any way to do so. Can
> anyone suggest how I can do this, or confirm that it is not possible and
> perhaps enlighten me as to why?

   It's not currently possible. I'm not sure if there are any plans to
allow it.

> 2. Duplicating NOCOW files
> 
> This is obviously possible, since it takes place when you make a snapshot.
> So why can't I create a clone of a snapshot of a NOCOW file? I am hoping the
> answer to this is that it is possible but not implemented yet...

   Umm... you should be able to, I think.

> I also have a question about the implementation of this. It would make
> sense, to me, to fragment the snapshot instead of the file itself. This is
> especially true in my case, where I am taking a snapshot which I am going to
> discard later.

   Fragmenting the snapshot would require true copy-on-write, which
doubles the amount of writes made to the media. Btrfs's CoW
implementation is actually redirect-on-write, which puts the
newly-written data somewhere else. This implies that the copy being
written to gets the fragmentation.

> Can someone confirm what happens in this case? Basically I want to know if
> access to the original file will continue to be performant after lots of
> snpshots have been taken.
> 
> 3. Peformance penalty of fragmentation on SSD systems with lots of memory
> 
> I see a lot of discussion of the performance issues running databases, and
> similar, on top of BTRFS without NOCOW. I suspect that this is not a huge
> issue if using SSD, and with a lot of memory, since things will generally be
> in memory anyway.
> 
> Can anyone confirm if this is true? Obviously it makes sense to use a
> database's native replication if possible but I am trying to come up with a
> general purpose hosting platform and so I am very interested in the
> performance when this kind of optimization hasn't taken place.

   There are two performance problems with fragmentation -- seek time
to find the fragments (which affects only rotational media), and the
amount of time taken to manage the fragments. As the number of
fragments increases, so does the number of extents that the FS has to
keep track of. Ultimately, with very fragmented files, this will have
an effect, as the metadata size will increase hugely.

> 4. Generations and tree structures
> 
> I am planning to use lots more clever tricks which I think should be
> available in BTRFS, but I can't see much documentation. Can anyone point out
> any good examples or documentation of how to access the tree structures
> directly. I'm particularly interested in finding changed files and portions
> of files using the generations and the tree search.

   You need the TREE SEARCH ioctl -- that gives you direct access to
all the internal trees of the FS. There's some documentation on the
wiki about how these fit together:

https://btrfs.wiki.kernel.org/index.php/Data_Structures
https://btrfs.wiki.kernel.org/index.php/Trees

   What "tricks" are you thinking of, exactly?

> Even better, would anyone be able to help me with this?
> 
> 5. Project
> 
> I've looked around for existing projects, but can't find anything apart from
> some basic scripts. Please let me know if there are any good projects I
> should be aware of.

   There's a few of them out there. Mine, in a pretty rough state, but
functional on a single machine at the moment, is:

http://git.darksatanic.net/cgi/gitweb.cgi?p=carfax-backups.git;a=summary

> In the mean time, I've created my own project in Haskell and shared on
> github.
> 
> https://github.com/wellbehavedsoftware/wbs-backup
> 
> Some of the goals here are:
> 
> - Take advantage of deduplication, both in the running system and in the
> backups
> 
> - Work seamlessly and efficiently with a large number of snapshots.
> 
> - Efficiently take backups at a high frequency and send them to a remote
> system
> 
> - Backups should serve for disaster recovery, for undoing mistakes, and for
> tracking changes

   Are you aware of btrfs send/receive? It should allow you to do all
of this. The main part of the code then comes down to managing the
send/receive, and all the distributed error handling. Then the only
direct access to the internal metadata you need is being able to read
UUIDs to work out what you have on each side -- which can also be done
by "btrfs sub list".

   Hugo.

> - Provide a means to verify the backup via a completely indepdent code path,
> and to do so efficiently.
> 
> I am developing this for a direct business need, but I think this kind of
> functionality should be open source, and that it will be more useful to me
> with community support. If anyone is interested in participating, or even
> just using it, please let me know.
> 
> Thanks to everyone who has worked on BTRFS so far ;-)
> 
> James

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- How do you become King?  You stand in the marketplace and ---    
          announce you're going to tax everyone. If you get out          
                           alive, you're King.                           

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVCbjI1heFHXiqx3kAQIqjw/9HJoaYBaPG0wnKNTbkSnh9V1eZeSl8ohO
Jurq+I5fMJO4iy61pF/3ufrsWjm8z6oXoYCDqaAIfK1J6XzhMTSrK+k2KCPuBRJk
EzEfDF1OhXzKogE/ENmdWTOMad305MHGJKj7rxO5jtCMPRXu6FM5yYHWmDaCdtqa
9LgngIM1oSGCFAhRiCpFF/5U4SIU4MZZP2fKL59DE0z2/1e8/ssXXC92GG12vODe
tnCfTQ+cauSGth0qbduQ5l355VKI7pEHDzq7PdKyiPCRnmD9Ino+shbNtbskemQ6
j5PQZG7IJcbyq/A65MhL94EprSiGviVjSGc6bfHSqeEWiMx0eSc1+hFBLJpYL/G1
6hfT2sOBHCYvviXCWB49oL96l1q4xPva2JiHXp7qBYCsKKGS9vr1a39V68hwLX6f
df4vWeWLhqCrDqOzT6x5w9MqaH86aF8gBluf7+g1k7lGVLb4USeMkeSRIVeZZBAR
ikSWPK+ShS/VIlIvkC+Y5kajiDdyojGWtdITH8dm7UcYj/zWKOr3Sv3RQk+RUqLg
lAcB51jDyaRdZvUgiExDBWEvth5nUqBOp9UAIhJesyHx4grHn28mZQRzX7CrPadP
NV2gkoXw7tsFYzsSSQYHrM2A7zUUgfUz6hwTY6/v01vtHXv2kF5ddgKx2HsPNXPB
AdyD7C2n6JM=
=fVgS
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
