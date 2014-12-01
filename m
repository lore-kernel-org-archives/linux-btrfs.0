Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37277 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaLAXuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 18:50:04 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XvajC-0002Id-MP
	for linux-btrfs@vger.kernel.org; Tue, 02 Dec 2014 00:50:02 +0100
Received: from 50.245.141.77 ([50.245.141.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 00:50:02 +0100
Received: from eternaleye by 50.245.141.77 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 00:50:02 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Mon, 01 Dec 2014 15:46:33 -0800
Message-ID: <m5iukq$s45$2@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com> <m5dcia$tk8$1@ger.gmane.org> <CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com> <547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com> <547CA870.9040904@gmail.com> <CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com> <m5ifgo$c1e$1@ger.gmane.org> <CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com> <m5ihkj$cep$1@ger.gmane.org> <m5ihs4$cep$2@ger.gmane.org> <CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com> <m5is7h$peq$1@ger.gmane.org> <CAJBj3vfnvtcb8NTQ2k4eg43oEtOx9YT4SFZ6wfOjC=fvSrHmow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Mon, Dec 1, 2014 at 3:05 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
>> Incidentally, you can be 'skeptical' all you like - per Austin's message
>> upthread, he was testing the Crypto API. Thus, skeptical as you may be,
>> hard evidence shows that SHA-1 was equal to or faster than CRC32, which
>> is unequivocally simpler and faster than CityHash (though CityHash comes
>> close).
>>
>> And the CPUs in question are *not* particularly rare - Intel since Sandy
>> Bridge or so, the majority of SPARC systems, a goodly number of ARM
>> systems via coprocessors...
> 
> You can make convoluted, incorrect claims all you like, but the fact
> is that SHA-1 is not as fast as Spooky2 or CityHash128 on x64 Intel
> CPUs, and Murmur3 is faster on ARM systems. And it is not even close.
> Your claims are absurd.

And that _is_ the case; they are faster... *when both are software 
implementations*

And I'm not sure what is "convoluted" or "incorrect" about saying "Look, 
empirical evidence!"

