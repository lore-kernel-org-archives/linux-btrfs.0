Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35331 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaLAXhi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 18:37:38 -0500
Received: by mail-qg0-f50.google.com with SMTP id i50so8356326qgf.37
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 15:37:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5is7h$peq$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<20141125163905.GJ26471@twin.jikos.cz>
	<m5dash$58v$1@ger.gmane.org>
	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
	<m5dcia$tk8$1@ger.gmane.org>
	<CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>
	<547C618C.8020201@gmail.com>
	<CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
	<547CA870.9040904@gmail.com>
	<CAJBj3vekJ6B45SnbL_TSuCm6Z-YOX-B1XNPxUuJgu4Cy2b3y-A@mail.gmail.com>
	<m5ifgo$c1e$1@ger.gmane.org>
	<CAJBj3veLYPPhsiX12BdSerJwP4izsb4d-=HN91CnSm-+vKE5Tw@mail.gmail.com>
	<m5ihkj$cep$1@ger.gmane.org>
	<m5ihs4$cep$2@ger.gmane.org>
	<CAJBj3venQGosBDUrKicGK1qgymBEBF=VWSiJjQiPpnis+Rrhpg@mail.gmail.com>
	<m5is7h$peq$1@ger.gmane.org>
Date: Mon, 1 Dec 2014 15:37:37 -0800
Message-ID: <CAJBj3vfnvtcb8NTQ2k4eg43oEtOx9YT4SFZ6wfOjC=fvSrHmow@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 3:05 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> Incidentally, you can be 'skeptical' all you like - per Austin's message
> upthread, he was testing the Crypto API. Thus, skeptical as you may be, hard
> evidence shows that SHA-1 was equal to or faster than CRC32, which is
> unequivocally simpler and faster than CityHash (though CityHash comes
> close).
>
> And the CPUs in question are *not* particularly rare - Intel since Sandy
> Bridge or so, the majority of SPARC systems, a goodly number of ARM systems
> via coprocessors...

You can make convoluted, incorrect claims all you like, but the fact
is that SHA-1 is not as fast as Spooky2 or CityHash128 on x64 Intel
CPUs, and Murmur3 is faster on ARM systems. And it is not even close.
Your claims are absurd.
