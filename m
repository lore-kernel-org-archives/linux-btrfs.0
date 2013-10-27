Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40478 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab3J0U1J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Oct 2013 16:27:09 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so3529535pbc.9
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Oct 2013 13:27:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131027201750.GG31029@carfax.org.uk>
References: <CAOeUAF_msDRoi2CDnAhwqC+=_oqNqH0=94+N9qjXpi4m4ChVLg@mail.gmail.com>
	<20131027201750.GG31029@carfax.org.uk>
Date: Mon, 28 Oct 2013 04:27:08 +0800
Message-ID: <CAOeUAF9FWCMwktn-nZR6wn+RiKHf9Qy_Yk7maqy0LzP8iQ6X6Q@mail.gmail.com>
Subject: Re: Total fs size does not match with the actual size of the setup
From: Lester B <b.lester011+btrfs@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Lester B <b.lester011+btrfs@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2013/10/28 Hugo Mills <hugo@carfax.org.uk>:
> On Mon, Oct 28, 2013 at 04:09:18AM +0800, Lester B wrote:
>> The btrfs setup only have one device of size 7 GiB but
>> when I run df, the total size shown is 15 GiB. Running
>> btrfs --repair
>
>    I'd recommend not running btrfs check --repair unless you really
> know what you're doing, or you've checked with someone knowledgable
> and they say you should try it. On a non-broken filesystem (as here),
> it's probably OK, though.
>
>> displays an error "cache and super
>> generation don't match, space cache will be invalidated."
>
>    This is harmless.
>
>> How can I correct the total fs size as shown in df?
>
>    You can't. It's an artefact of the fact that you've got a RAID-1
> (or RAID-10, or --mixed and DUP) filesystem, and that the standard
> kernel interface for df doesn't allow us to report the correct figures
> -- see [1] (and the subsequent entry as well) for a more detailed
> description.
>
>    Hugo.
>
> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- Nothing right in my left brain. Nothing left in ---
>                              my right brain.


But my setup is a simple one without any RAID levels or other things so at least
df size column should show the actual size of my setup.
