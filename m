Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:50899 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab3BBQ0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2013 11:26:39 -0500
Received: by mail-wi0-f169.google.com with SMTP id l13so1155641wie.0
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2013 08:26:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130202161959.GS16285@carfax.org.uk>
References: <CAOeZVicqqcrBrL6EiVBgsUzc5uTSTzwghktS2ebtP09Gdg2miw@mail.gmail.com>
	<20130202161959.GS16285@carfax.org.uk>
Date: Sat, 2 Feb 2013 21:56:37 +0530
Message-ID: <CAOeZVicJEMg6OmDdkV5_Ti8==527bsH+VDbKkrgQe+Myyg4_gg@mail.gmail.com>
Subject: Re: Newbie help-- Making BTRFS partition
From: Atri Sharma <atri.jiit@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Atri Sharma <atri.jiit@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Thanks.
 I was having some issues with my priviledges, and sorting them out has worked.

Thanks a ton,

Atri

On Sat, Feb 2, 2013 at 9:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Feb 02, 2013 at 08:56:20PM +0530, Atri Sharma wrote:
>> Hi all,
>>
>> I am running a Fedora 17 system. I am trying to set up a new partition
>> of 2 GB size which has BTRFS as file system.
>>
>> When I am trying to do mkfs.btrfs on a partition, I get:
>>
>> [atri@AtriServer ~]$ mkfs.btrfs /dev/sda3
>>
>> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> check_mounted(): Could not open /dev/sda3
>> error checking /dev/sda3 mount status
>
>    You need to be root, or (typically) to be in the "disk" group in
> order to write to a block device.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>   --- "What's so bad about being drunk?" "You ask a glass of water" ---
>



-- 
Regards,

Atri
l'apprenant
