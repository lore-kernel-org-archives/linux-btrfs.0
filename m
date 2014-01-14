Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38285 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaANIRM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 03:17:12 -0500
Date: Tue, 14 Jan 2014 08:16:43 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hendrik Friedel <hendrik@friedels.name>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck does not fix
Message-ID: <20140114081643.GC7221@carfax.org.uk>
References: <52C7127F.3060902@friedels.name>
 <6E517D5F-B921-47E7-82E7-27865077C43D@colorremedies.com>
 <52C87B67.1040503@friedels.name>
 <F9C2788F-B057-4C3F-A490-8F8A19C37F97@colorremedies.com>
 <52CC65C9.3090605@friedels.name>
 <52D08812.3040707@friedels.name>
 <0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>
 <52D317CF.2070007@friedels.name>
 <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
In-Reply-To: <EDD506BE-1DAC-4C2C-9FF4-184180315557@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 05:40:33PM -0700, Chris Murphy wrote:
> I see no obvious hardware source for the problem, SATA Phy Event Counters are zeros except a few COMRESET events which is pretty minor. No ICRC or UDMA-CRC errors recorded. No reallocated or pending bad sectors.
> 
> I'd look at your historical system logs, messages or journalctl, and do case insensitive search for: err, unc, reset and see if anything along those lines has been reported that might explain it.
> 
> If you decide to backup, reformat, restore, then first I suggest 
> 
> btrfs-image -c 9-t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>

btrfs-image -c 9 -t 4 /dev/sdX /mnt/<pathtoanothervolume+filename>

   Space between the 9 and the -t.

   Hugo.

> You can keep it handy in case a dev asks for it or you can attach it to a kernel.org bug report.
> 
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- I think that everything darkling says is actually a joke. ---    
         It's just that we haven't worked out most of them yet.          

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUBUtTya1heFHXiqx3kAQKsnhAAlsJfXtfGiLoFP4Z24VKPntoz/ToB7meF
LWYNMqqtMKZH/uobL3h6qaa8wnbTH4o0huQRWKsNI/r28I+JtR2J19BmZVJaKMxA
/2JM4yXuYRfOlgX+5AXKUlv7HucH6Af+nuaEg0qlAmCz5KasKE9sWN+HrDzjo4nI
uaAZxC7Ydrw/7INz+YY0cLFFyP0K+GV+Lxz7ZND90SD89Mbao68Q1j79vHglg2Wd
Ogu7cyTOjvbDj6fIkvfP1ddMa0phSInlfhS7gDAzbOUjHxadf+xufB8+NLGwLxEl
ugj9QyauN5Cb+8ANcp0fbLdpMzGiZIoa/yL+v8OX612JQ27P7PjoIexGPBKuY4lg
K3UCtdqiNxkrqOO6VIX9j0mM53HN2D53OUNFYZYdmM//esxCAxGt71W2Y7JD5UkZ
it9PGCaQPbB6bZsZ3Ue3jblgDggOVR+FzzuF3h4sd7GNrcvEHy6W64PIOlHUFs66
krptZrnQoiAtirBTngwMTVw3JqkKEBObCoyJHXyVYOtm2Qvi2Yqse3Fcia3vWdZq
CrnewNAt190cxJy9lPsBP5BsMwStlNEAysXfHkYvUXmU1fTpQulvrlj6F47e2ScQ
bklSsChyV6fmqT8nGYF6bFTMtYQNhs4lUA6lUJnza6+gPaWZPCk9Khg0pcIJ5N4S
MAQVO2dp9S0=
=jeDO
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
