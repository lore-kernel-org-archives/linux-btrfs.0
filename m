Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f51.google.com ([209.85.192.51]:54051 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbaLBAaL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 19:30:11 -0500
Received: by mail-qg0-f51.google.com with SMTP id l89so8567767qgf.10
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 16:30:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5j0aq$g6r$3@ger.gmane.org>
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
	<CAJBj3vfnvtcb8NTQ2k4eg43oEtOx9YT4SFZ6wfOjC=fvSrHmow@mail.gmail.com>
	<m5iukq$s45$2@ger.gmane.org>
	<CAJBj3vc_rRoXT-qhu6ji3qPG_u=Piu6XSUzXRhbJ_FeGHB4jcg@mail.gmail.com>
	<m5j0aq$g6r$3@ger.gmane.org>
Date: Mon, 1 Dec 2014 16:30:09 -0800
Message-ID: <CAJBj3vd83Vgfxsfitbz0vVma-jPWb22nj=PC-kigxnipV=BrKA@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 4:15 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> There's a thing called the transitive property. When CRC32 is faster than
> SpookyHash and CityHash (while admittedly weaker), and SHA-1 on SPARC is
> faster than CRC32, there are comparisons that can be made.

And yet you applied the transitive property with poor assumptions and
in a convoluted way to come up with an incorrect conclusion.


> It's that the flat assertion that "CityHash/SpookyHash/etc is always faster"
> is _unwarranted_, as hardware acceleration _has a huge effect_.

Actually, the assertion is true and backed up by evidence that I
cited. I'm not sure why you think hardware acceleration only helps
SHA-1 and does not help CityHash or SpookyHash.
