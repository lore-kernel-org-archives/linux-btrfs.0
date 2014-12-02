Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38653 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaLBAUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 19:20:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvbCG-00054B-5G
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 01:20:04 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:20:04 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 01:20:04 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 16:15:21 -0800
Message-ID: <m5j0aq$g6r$3@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com> <m5ihkj$cep$1@ger.gmane.org> <m5ihs4$cep$2@ger.gmane.org> <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com> <m5is7h$peq$1@ger.gmane.org> <CAJBj3vfnvtcb8NTQ2k4eg43oEtOx9YT4SFZ6wfOjC=fvSrHmow@mail.gmail.com> <m5iukq$s45$2@ger.gmane.org> <CAJBj3vc_rRoXT-qhu6ji3qPG_u=Piu6XSUzXRhbJ_FeGHB4jcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 3:46 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
>> And I'm not sure what is "convoluted" or "incorrect" about saying "Look,
>> empirical evidence!"
> 
> No empirical evidence of the speed of SpookyHash or CityHash versus
> SHA-1 was cited. The only empirical data mentioned was on an
> UltraSPARC CPU, and did not include any SpookyHash or CityHash
> measurements, and yet you made a claim about the speeds on Intel and
> ARM CPUs.

There's a thing called the transitive property. When CRC32 is faster than 
SpookyHash and CityHash (while admittedly weaker), and SHA-1 on SPARC is 
faster than CRC32, there are comparisons that can be made.

And what I've been trying to say this whole time is not some point about an 
individual architecture.

It's that the flat assertion that "CityHash/SpookyHash/etc is always faster" 
is _unwarranted_, as hardware acceleration _has a huge effect_.

On SPARC, it's empirically enough for SHA-1 to match CRC32.
On ARMv8, it brings SHA-1 from 4-8 cycles per byte down to _2_.
On Intel, when the Skylake SHA extensions land, it will likely have an 
enormous impact as well.

Broad, sweeping generalizations are great - so long as they are _properly 
qualified_.

For instance, I would agree *wholeheartedly* that a good software 
implementation of CityHash/SpookyHash/etc would beat the *pants* off a good 
software implementation of SHA-1. No question.

