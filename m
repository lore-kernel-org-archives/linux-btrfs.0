Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33488 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbDGLJA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Apr 2015 07:09:00 -0400
Received: by lbbzk7 with SMTP id zk7so39721562lbb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 04:08:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150407110354.GH13864@carfax.org.uk>
References: <CAK1hC9skBYrM7nPyU-2mCuey6VkFOGMUCi0umYduX3ePNJ2mpg@mail.gmail.com>
	<CAK1hC9tBAvqOhGLGcX=1Ls2QwtaB6fe6Wzf89vH4=Y+kvxHR_Q@mail.gmail.com>
	<20150407110354.GH13864@carfax.org.uk>
Date: Tue, 7 Apr 2015 13:08:59 +0200
Message-ID: <CAK1hC9vDQ4j3CZ=7T30-Sg+Q8FYFOzntgmz57WMWRU5WELpDnA@mail.gmail.com>
Subject: Re: btrfs subvolume & default subvolume
From: arnaud gaboury <arnaud.gaboury@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, arnaud gaboury <arnaud.gaboury@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 7, 2015 at 1:03 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Apr 07, 2015 at 12:58:28PM +0200, arnaud gaboury wrote:
>> On Tue, Apr 7, 2015 at 11:57 AM, arnaud gaboury
>> <arnaud.gaboury@gmail.com> wrote:
>> >
>> > I plan to install my OS on a btrfs partition, with some subvolumes.
>> > Once the partition has been btrfs formated, I mounted it somewhere, cd
>> > and then run <btrfs subvolume create>.
>> >
>> > I did these two subvolumes for now:
>> > # btrfs subvolume list .
>> > ID 256 gen 6 top level 5 path var
>> > ID 257 gen 7 top level 5 path home
>> >
>> > Now I am wondering if I need to create the root filesystem partition
>> > (/)? If yes, is this correct:
>> > # btrfs subvolume create root
>>
>>
>> After more reading, it seems to me creating a top root subvolume is
>> the right thing to do:
>> # btrfs subvolume create root
>> # btrfs subvolume create root/var
>> # btrfs subvolume create root/home
>>
>> Am I right?
>
>    Not how I'd recommend doing it. I'd say:
>
> # btrfs sub crea root
> # btrfs sub crea var
> # btrfs sub crea home
>
>    Then fstab:
>
> LABEL=myfs    /      btrfs    subvol=root         0 0
> LABEL=myfs    /var   btrfs    subvol=var          0 0
> LABEL=myfs    /home  btrfs    subvol=home         0 0
>
>    And finally, add this to your kernel command line in the bootloader
> to specify how to mount root:
>
> rootflags=subvol=root
>
>    Hugo.

Thank you Hugo. May you please tell why your recommendation is better
than my settings, if I thereafter make root as the default sub-volume?
I changed the root name to active and avoid any confusion:

# btrfs subvolume list .
ID 260 gen 17 top level 5 path active
ID 261 gen 15 top level 260 path active/home
ID 262 gen 16 top level 260 path active/var
ID 263 gen 17 top level 260 path active/etc

# btrfs subvolume set-default 260 .

In this way, I will not need any kernel command line.

>
> --
> Hugo Mills             | The trouble with you, Ibid, is you think you know
> hugo@... carfax.org.uk | everything.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 

google.com/+arnaudgabourygabx
