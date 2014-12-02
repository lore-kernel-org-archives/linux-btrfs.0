Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:39295 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbaLBADr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 19:03:47 -0500
Received: by mail-qg0-f43.google.com with SMTP id q108so8601002qgd.30
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 16:03:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m5iukq$s45$2@ger.gmane.org>
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
Date: Mon, 1 Dec 2014 16:03:46 -0800
Message-ID: <CAJBj3vc_rRoXT-qhu6ji3qPG_u=Piu6XSUzXRhbJ_FeGHB4jcg@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
To: Alex Elsayed <eternaleye@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 3:46 PM, Alex Elsayed <eternaleye@gmail.com> wrote:
> And I'm not sure what is "convoluted" or "incorrect" about saying "Look,
> empirical evidence!"

No empirical evidence of the speed of SpookyHash or CityHash versus
SHA-1 was cited. The only empirical data mentioned was on an
UltraSPARC CPU, and did not include any SpookyHash or CityHash
measurements, and yet you made a claim about the speeds on Intel and
ARM CPUs.
