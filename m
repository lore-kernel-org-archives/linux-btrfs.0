Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33412 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbaLVMr6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 07:47:58 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y32Oq-0000dL-Hk
	for linux-btrfs@vger.kernel.org; Mon, 22 Dec 2014 13:47:48 +0100
Received: from ip4da2a5ae.direct-adsl.nl ([77.162.165.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 13:47:48 +0100
Received: from koen by ip4da2a5ae.direct-adsl.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 13:47:48 +0100
To: linux-btrfs@vger.kernel.org
From: Koen Kooi <koen@dominion.thruhere.net>
Subject: Re: btrfs-prog: improve build-system by autoconf
Date: Mon, 22 Dec 2014 13:47:38 +0100
Message-ID: <m793ta$dsj$1@ger.gmane.org>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com> <20141217140726.GY27601@twin.jikos.cz> <20141218133111.GG19904@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20141218133111.GG19904@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Karel Zak schreef op 18-12-14 14:31:
> On Wed, Dec 17, 2014 at 03:07:26PM +0100, David Sterba wrote:
>> On Fri, Dec 12, 2014 at 01:35:14PM +0100, Karel Zak wrote:
>>> This is first step to make btrfs-progs build system more
>>> conventional for userspace users and developers. All is implemented
>>> by small incremental patches to keep things review-able.
>> 
>> Thanks. I went through the patches and haven't found major problems.
>> The changes are affecting build system and this will need a longer
>> period before all distros have a chance to adapt to that, so I'm
>> postponing it to 3.19.
> 
> Cool, I'll try to prepare next set of patches with automake.
> 
> BTW, I have good experience with build-system changes -- downstream 
> distributions (maintainers) are usually pretty flexible :-)

Especially when switching from homegrown makefiles to autofoo!

regards,

Koen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFUmBLqMkyGM64RGpERApjpAJ9Agir/DDJiFYUR8qPDcNmx7pnLnQCgoKsD
1HuCreKom9ZYzZevIbqWz08=
=g1VP
-----END PGP SIGNATURE-----

