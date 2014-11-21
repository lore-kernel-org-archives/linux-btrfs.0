Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61076 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638AbaKUP1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 10:27:47 -0500
Received: by mail-qg0-f52.google.com with SMTP id a108so3733531qge.25
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 07:27:47 -0800 (PST)
Message-ID: <546F59E1.1040007@ubuntu.com>
Date: Fri, 21 Nov 2014 10:27:29 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D1AD3.2010206@pobox.com> <546E5066.1040107@ubuntu.com> <546E7458.9040302@pobox.com>
In-Reply-To: <546E7458.9040302@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/20/2014 6:08 PM, Robert White wrote:
> Well you should have _actually_ trimmed your response down to not 
> pressing send.
> 
> _Many_ motherboards have complete RAID support at levels 0, 1, 10,
> and five 5. A few have RAID6.
> 
> Some of them even use the LSI chip-set.

Yes, there are some expensive server class motherboards out there with
integrated real raid chips.  Your average consumer class motherboards
are not those.  They contain intel, nvidia, sil, promise, and via
chipsets that are fake raid.

> Seriously... are you trolling this list with disinformation or
> just repeating tribal knowledge from fifteen year old copies of PC
> Magazine?

Please drop the penis measuring.

> Yea, some of the IDE motherboards and that only had RAID1 and RAID0
> (and indeed some of the add-on controllers) back in the IDE-only
> days were really lame just-forked-write devices with no integrity
> checks (hence "fake raid") but that's from like the 1990s; it's
> paleolithic age "wisdom" at this point.

Wrong again... fakeraid became popular with the advent of SATA since
it was easy to add a knob to the bios to switch it between AHCI and
RAID mode, and just change the pci device id.  These chipsets are
still quite common today and several of them do support raid5 and
raid10 ( well, really it's raid 0 + raid1, but that's a whole nother
can of worms ).  Recent intel chips also now have a caching mode for
having an SSD cache a larger HDD.  Intel has also done a lot of work
integrating support for their chipset into mdadm in the last year or
three.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUb1ngAAoJEI5FoCIzSKrwqMQIAJ3MfA4n74aJ1KUdfHYOz96o
vwPBNQJ953yozmCHfjERbTCQlKT5AzwQHWpHoFWsQ4gYoNGmeE1jy2rsqxMfujff
eQekfISyX3POExnsr3LnfHWI2/Om39+EAxVPxbA5LN6SC1SCWRut7Q3bQqkuxj/S
bYRU65XJ9BZ6eYznutMDFdEELyAr8b9/wnatI/ohzmebOBDgFzBrn8gwilCctz7X
DI39HTkCvciWKVXNyVdUZKI5S+MRCEB2JZAkCy3x8LLsENmMnO0xN32o5Od0zlGn
nFLcLQFrZfz5dY2ZusxP+z0z0x4RW3sikd4RZ99PEHBkFa5CgJIFrBxtQAsLi1c=
=4Yg+
-----END PGP SIGNATURE-----
