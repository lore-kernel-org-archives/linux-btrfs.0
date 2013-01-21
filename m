Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53154 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab3AUWoE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jan 2013 17:44:04 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so1729854pbb.27
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2013 14:44:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130120132229.GA28546@carfax.org.uk>
References: <CAPVzhpyj8oXMGyoPop6FadcDRAyDTmvX7VPncBLo0wuUOKxvwA@mail.gmail.com>
	<20130120132229.GA28546@carfax.org.uk>
Date: Mon, 21 Jan 2013 19:44:03 -0300
Message-ID: <CAPVzhpz7HcFqnE_M_8T=wcDuOyPjiEiAzDZokW6okeXhJmx8XA@mail.gmail.com>
Subject: Re: btrfs: failed to read chunk tree on vde1 (f18 anaconda crash)
From: Reartes Guillermo <rtguille@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Reartes Guillermo <rtguille@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for asking, but in the end it was not btrfs related at all.

Virt-Manager failed to issue a warning (for yet unknown reasons) and a
single hard disk image was being accessed as two
different devices...

I spent quite a bit of time until i found it. (normally, virt-manager
prevents this)

Cheers.


On Sun, Jan 20, 2013 at 10:22 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Jan 19, 2013 at 07:53:08PM -0300, Reartes Guillermo wrote:
>> Hi,
>>
>> I reported a bug to anaconda (rhbz 901905), but it might be btfs related.
>>
>> Anaconda does this:
>>
>> 18:49:10,317 INFO program: Running... mkfs.btrfs --data=single
>> --label=fedora /dev/vdb1 /dev/vdc1 /dev/vdd1 /dev/vde1
>> 18:49:10,742 INFO program:
>> 18:49:10,746 INFO program: WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>> 18:49:10,746 INFO program: WARNING! - see http://btrfs.wiki.kernel.org
>> before using
>> 18:49:10,748 INFO program:
>> 18:49:10,749 INFO program: SMALL VOLUME: forcing mixed metadata/data groups
>> 18:49:10,750 INFO program: Created a data/metadata chunk of size 8388608
>> 18:49:10,750 INFO program: adding device /dev/vdc1 id 2
>> 18:49:10,751 INFO program: adding device /dev/vdd1 id 3
>> 18:49:10,752 INFO program: adding device /dev/vde1 id 4
>> 18:49:10,752 INFO program: fs created label fedora on /dev/vdb1
>
>    Out of interest, how big are these devices?
>
>    Hugo.
>
> [snip]
>> I booted again and did both the mk.btrfs and the mount manually and i
>> got the same error.
>>
>> Is it a known issue?
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- We believe in free will because we have no choice. ---
