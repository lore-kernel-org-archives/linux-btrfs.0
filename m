Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33260 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaLBAQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 19:16:18 -0500
Received: by mail-qg0-f41.google.com with SMTP id j5so8613336qga.28
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 16:16:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5ivqh$g6r$1@ger.gmane.org>
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
	<CAJBj3vc3oQ1CKpLi7sMT59=camxVOZa3q-tN6i604VKYpFew1A@mail.gmail.com>
	<m5ivqh$g6r$1@ger.gmane.org>
Date: Mon, 1 Dec 2014 16:16:18 -0800
Message-ID: <CAJBj3vew3K-A1sze0oZSQiTnd3prqv8S+7HP2bCU0w9gWLCgoQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 4:06 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> https://github.com/openssl/openssl/blob/master/crypto/sha/asm/sha1-armv8.pl
>
> #             hardware-assisted software(*)
> # Apple A7    2.31              4.13 (+14%)
> # Cortex-A53  2.19              8.73 (+108%)
> # Cortex-A57  2.35              7.88 (+74%)


Note that those are showing 2 cycles per byte.

> From the CityHash readme, on a Xeon X5550 (which is _considerably_ more
> powerful than any of the above):
>
> On a single core of a 2.67GHz Intel Xeon X5550, CityHashCrc256 peaks at
> about 5 to 5.5 bytes/cycle.

5 bytes per cycle is 0.2 cycles per byte. So your own citation shows
that CityHash is 10 times faster.
