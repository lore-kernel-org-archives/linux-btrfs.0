Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46987 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab2IXOCm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 10:02:42 -0400
Date: Mon, 24 Sep 2012 15:02:39 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Sami Haahtinen <sami@haahtinen.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Rebuilding chunk root?
Message-ID: <20120924140239.GB6136@carfax.org.uk>
References: <CA+nK0aON8yROCGwetiXdEphUf+Ju-BVJ54ooeMOZyUpHy9KDGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
In-Reply-To: <CA+nK0aON8yROCGwetiXdEphUf+Ju-BVJ54ooeMOZyUpHy9KDGA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 24, 2012 at 04:28:08PM +0300, Sami Haahtinen wrote:
> Due to certain unfortunate chain of events, I managed to overwrite a
> small portion of my btrfs array which had only single redundancy for
> metadata. The data itself is present and only a small portion (2.5%)
> of the array was overwritten.
> 
> After quite a bit of debugging and tinkering, I realized that my chunk
> root was in the portion that was overwritten. After reading through
> the documentation I was able to pull together it's still unclear to me
> whether chunk root is something that can be rebuilt.

   Chris had some experimental code for doing it in btrfsck which
never saw the light of day (because it was too unreliable). He may
be able to offer you something to help, though.

> A transcript of btrfsck trying to recover with superblock 2 which is
> uncorrupted by itself:
> 
> root@sysresccd /root/btrfs-progs % ./btrfsck --super 2 /dev/patience/home
> using SB copy 2, bytenr 274877906944
> Check tree block failed, want=139264, have=0
> Check tree block failed, want=139264, have=0
> Check tree block failed, want=139264, have=0
> read block failed check_tree_block
> Couldn't read chunk root
> 
> If I'm interpreting the output correctly, it's trying to read bytes
> from address 139264, which would fall into the corrupted area.

   No, I believe the "want=, have=" text is referring to a generation
ID, not a block number. That's not to say that your chunk tree isn't
damaged, though -- I'm just clarifying your interpretation of the
numbers.

   Out of interest, does mounting with -o recovery help at all? (I'm
not expecting it to do much if your chunk tree's gone, but it might do
something).

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Eighth Army Push Bottles Up Germans -- WWII newspaper ---      
                     headline (possibly apocryphal)                      

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGBn/79z9OVl50rAAQIqLQ//bnFrf4aT7w6NY0up3QVaRhHAW4OAJWCC
GVPPm+ykRt3TRcfPghWfad8UluWPXELr4zMRAVMBXfYIycu28Qg4qsSfZb7xBa0N
MlFT0Ixdy30dc+H6jfKzMV7EPheFMTDq97erF/imC1n7XU5GJMwfCIvkIDmARnQj
R8DC6u+16T+pQfX1g3aRSZ6Mzc2dneU/4adN3a5RdUoPeqG/NuOQm46Lhyxn4YGy
eW+TtwIqC//CREHZuBELKLRrr7xEgh26TL0t3sqANRiHRvH7yUNbruxj0+ZSyA/e
7VjwtbtYbnCx7d60EW0Mpjx5WuHsLLkaKCKdsYyGYUQ/TGPHp8N1huR54ChzczcD
5ZcLIJlT6g9fbEIDpAj29vIQEaXKvoPa4t2IroD/0uzmfiIARLLE0oYrv1DMVTKA
1pQzFTFf+Vuy3ijaX+Xl4QeO+z3AFpomYii3NwWZjiWVqV+SXh8w1iue97nsuFs2
v6p4Rxi7EiI6sKtEzui4BKnrz/uoaJqntygyWqsCwkFxEd+5KkADoBxB2qGH03Cy
cJrEM9Yy1StPcNAVKSLQqswzn40Tn8jnVlZepNPKJeSuPjrkLardJtOq2X3m/p1G
/QtEcKhUvxKSKD+5eGKWcw5Qltvfm2wO2osMBNhmSYYszzG1KRonvyEPAVjExabc
1TZgqyQHfLc=
=3FpF
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
