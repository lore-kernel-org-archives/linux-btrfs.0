Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35159 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcA2SNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 13:13:35 -0500
Received: by mail-io0-f182.google.com with SMTP id d63so80396514ioj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 10:13:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
References: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
From: John Smith <lenovomi@gmail.com>
Date: Fri, 29 Jan 2016 19:13:06 +0100
Message-ID: <CAAcrkYJ_Dm5uW3djxv+PE2m8G6qXmXiSkJuekThkE5RDoDxmbA@mail.gmail.com>
Subject: Re: csum failed : d-raid0, m-raid1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

the out of the smartctl of both drives is here :

https://drive.google.com/folderview?id=0B6RZ_9vVuTEcRnFfRzhGZEdWSjA&usp=sharing



thanks

On Fri, Jan 29, 2016 at 7:04 PM, John Smith <lenovomi@gmail.com> wrote:
> Hi
>
> i built btrfs volume using 2x3tb brand new /tested for badblocks
> drives. I copied into volume around 5Tb of data.
>
> I tried to read one file which is around 4GB and i got input / output error.
>
> Dmesg contains:
>
> [154159.040059] BTRFS warning (device sdd): csum failed ino 9995246
> off 4506214400 csum 383964635 expected csum 6478505
>
>
> Any idea what is it? Whats the reason that this happened? Can I recover?
>
>
> Thank you!
