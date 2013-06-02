Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36136 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3FBRlV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 13:41:21 -0400
Date: Sun, 2 Jun 2013 18:41:18 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Tim Eggleston <lists@timeggleston.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 total capacity incorrect
Message-ID: <20130602174118.GH20133@carfax.org.uk>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
 <20130602163015.GG20133@carfax.org.uk>
 <4cd17d2ff5a252261c4ab2f3800207b5@mail.39.gs>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
In-Reply-To: <4cd17d2ff5a252261c4ab2f3800207b5@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 02, 2013 at 05:52:38PM +0100, Tim Eggleston wrote:
> Hi Hugo,
> 
> Thanks for your reply, good to know it's not an error as such (just
> me being an idiot!).
> 
> >Additional space will be allocated from the available unallocated
> >space as the FS needs it.
> 
> So I guess my question becomes, how much of that available
> unallocated space do I have? Instinctively the btrfs df output feels
> like it's missing an equivalent to the "size" column from vanilla
> df.

   Look at btrfs fi show -- you have "size" and "used" there, so the
difference there will give you the unallocated space.

> Is there a method of getting this in a RAID situation? I understand
> that btrfs RAID is more complicated than md RAID, so it's ok if the
> answer at this point is "no"...

   Not in any obvious (and non-surprising) way. Basically, any way you
could work it out is going to give someone a surprise because they
were thinking of it some other way around. The problem is that until
the space is allocated, the FS can't know how that space needs to be
allocated (to data/metadata, or with what replication type and hence
overheads), so we can't necessarily give a reliable estimate.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
         --- If you're not part of the solution, you're part ---         
                           of the precipiate.                            

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUauDvlheFHXiqx3kAQI+qw/9FczPtnR1ZvN9QSjUqDDZ7wF1zLrmStnh
/44C9PVANVgJsJK2EplRZKmjL4Oa6qh4QMpcWG7UFkR8MkWL8NyvvPgvEFjES5qs
HUsJyFxK1KNPsveFzF15XuDF/asuGvY9f8d5dQ8maWpDLHzDLt+6nyf4jCVUOGXB
yfqXvK6UpcxeABT6jG0JtXj4HeScgCc9GUeDUffV0k3ckRa/MK6/B6xLfjc0T3jp
DJPS13KAyaI2JbHiDwFKTJpzUJG2rPZlt28hE1o7v1cmPlxTo/5GEwfIydMo0+/N
aiHr+AvgAvGwUl7VOm585hlm0EEruaqaeKp4v+AmKpCcSRVE14PmiqjWm8eSZhFi
7Tj70QaVvKRMWjVpLL9VyiI2x4biqaKw5VpXzXx3CfebuwuSRtTT3AAvltEFskK1
mJZswsYmbPMmgCHT+apwDfEBfyFbZoP0oNMh1icKtpFdAxy677B3TcTBPjEi3wBs
ATosVI5pZKxJZR8vTtNVm5MY6sY3HLzO2gP7a2jYh6mAqvXQGOg6UyqLiKrdne4i
2Iw/ifJrvKOzSTECn+EJxddQYt4Mm6u3zkCPh2YjN8jMMJEUW7w5hlJIZR5jldt0
oDLilcyTOwd/JK0oqKkj2B7lcNLN6Wxgafwwyg5m9G7FAc4YAkYRTBpSu5nAQqmY
bVL9s85UO50=
=oj1E
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--
