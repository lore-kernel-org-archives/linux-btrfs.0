Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:61870 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3KSTYC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 14:24:02 -0500
Received: by mail-ie0-f177.google.com with SMTP id tp5so4501010ieb.8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 11:24:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131119090602.GV4315@carfax.org.uk>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
	<20131119090602.GV4315@carfax.org.uk>
Date: Tue, 19 Nov 2013 13:24:01 -0600
Message-ID: <CAEWPe=rMXVehpFNko-wZ1i4dKP21J8wJKj1R2jDSK2HsEYmduQ@mail.gmail.com>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
From: deadhorseconsulting <deadhorseconsulting@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        deadhorseconsulting <deadhorseconsulting@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Interesting, this confirms what I was observing.
Given the wording in man pages for "-m" and "-d" which states "Specify
how the metadata or data must be spanned across the devices
specified."
I took "devices specified" to literally mean the devices specified
after the according switch.

- DHC


On Tue, Nov 19, 2013 at 3:06 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Nov 18, 2013 at 11:12:03PM -0600, deadhorseconsulting wrote:
>> In theory (going by the man page and available documentation, not 100%
>> clear) does the following command indeed actually work as advertised
>> and specify how metadata should be placed and kept only on the
>> "devices" specified after the "-m" flag?
>>
>> Thus given the following example:
>> mkfs.btrfs -L foo -m raid10 <ssd> <ssd> <ssd> <ssd> -d raid10 <rust>
>> <rust> <rust> <rust>
>>
>> Would btrfs stripe/mirror and only keep metadata on the 4 specified SSD devices?
>> Likewise then stripe/mirror and only keep data on the specified 4 spinning rust?
>
>    No. The devices are general purpose. The -d and -m options only
> specify the type of redundancy, not the devices to use. There's a
> project[1] to look at this kind of more intelligent chunk allocator,
> but it's not been updated in a while.
>
> [1] https://btrfs.wiki.kernel.org/index.php/Project_ideas#Device_IO_Priorities
>
>> In trying and creating this type of setup it appears that data is also
>> being stored on the devices specified as "metadata devices". This is
>> observed through via a "btrfs filesystem show". after committing a
>> large amount of data to the filesystem The data devices have balanced
>> data as expected with plenty of free space but the SSD device are
>> reported as either nearly used or completely used.
>
>    This will happen with RAID-10. The allocator will write stripes as
> wide as it can: in this case, the first stripes will run across all 8
> devices, until the SSDs are full, and then will write across the
> remaining 4 devices.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>                 --- If it ain't broke,  hit it again. ---
