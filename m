Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38025 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaLBAGx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 19:06:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvazT-0008Oj-0w
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 01:06:51 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:06:51 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:06:51 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 16:06:39 -0800
Message-ID: <m5ivqh$g6r$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com> <m5ihkj$cep$1@ger.gmane.org> <m5ihs4$cep$2@ger.gmane.org> <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com> <m5is7h$peq$1@ger.gmane.org> <CAJBj3vc3oQ1CKpLi7sMT59=camxVOZa3q-tN6i604VKYpFew1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 3:05 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
>> hard evidence shows that SHA-1 was equal to or faster than CRC32, which
>> is unequivocally simpler and faster than CityHash (though CityHash comes
>> close).
>>
>> And the CPUs in question are *not* particularly rare - Intel since Sandy
>> Bridge or so, the majority of SPARC systems, a goodly number of ARM
>> systems via coprocessors...
> 
> By the way, your "hard evidence" is imaginary.
> 
> Here you can see that SHA-1 is about 5 cycles per byte on Sandybridge:
> 
> https://blake2.net/
> 
> While SpookyHash (and CityHash) are about 3 bytes per cycle (on long
> keys) which is about 0.33 cycles per byte. More than 10 times faster
> than SHA-1.
> 
> http://burtleburtle.net/bob/hash/spooky.html

On further examination, I did indeed make a mistake - the hardware 
acceleration for SHA on Intel will be in Skylake; only the AES acceleration 
was added in Sandy Bridge. So you are correct to some degree with the rarity 
argument.

However, performance-wise, that means SHA-1 on Intel is still a software 
implementation. Let's look at ARMv8.

The ARM v8 architecture added a few cryptographic instructions, including 
for SHA-1. The results:

https://github.com/openssl/openssl/blob/master/crypto/sha/asm/sha1-armv8.pl

#             hardware-assisted software(*)
# Apple A7    2.31              4.13 (+14%)
# Cortex-A53  2.19              8.73 (+108%)
# Cortex-A57  2.35              7.88 (+74%)

>From the CityHash readme, on a Xeon X5550 (which is _considerably_ more 
powerful than any of the above):

On a single core of a 2.67GHz Intel Xeon X5550, CityHashCrc256 peaks at 
about 5 to 5.5 bytes/cycle. The other CityHashCrc functions are wrappers 
around CityHashCrc256 and should have similar performance on long strings.
(CityHashCrc256 in v1.0.3 was even faster, but we decided it wasn't as 
thorough as it should be.) CityHash128 peaks at about 4.3 bytes/cycle. The 
fastest Murmur variant on that hardware, Murmur3F, peaks at about 2.4 
bytes/cycle. We expect the peak speed of CityHash128 to dominate CityHash64, 
which is aimed more toward short strings or use in hash tables.


So CityHash is - at best - half as fast as SHA1 with acceleration.

In fact, on the Apple A7, it would likely be slower than _software_ SHA-1.

