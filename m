Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41963 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2JSS0i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 14:26:38 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so556921pad.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 11:26:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK0PdAk5jUMFkYek1r-M-D0OygqXbqZD+_fQ9RBZTE7gsEymFQ@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
	<20121018132850.GA22010@shiny>
	<CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
	<CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
	<CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
	<CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
	<CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
	<CAE5mzvh9VFUxdsRehuZdTC-0VYdwbEL=cmtoU=gqTs8Ne29m8A@mail.gmail.com>
	<CAK0PdAk5jUMFkYek1r-M-D0OygqXbqZD+_fQ9RBZTE7gsEymFQ@mail.gmail.com>
Date: Fri, 19 Oct 2012 12:26:37 -0600
Message-ID: <CAE5mzvggOwC3W-Jak0GAGky7a2fhWFK-d61US30C9STxbyMVxw@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
From: cwillu <cwillu@cwillu.com>
To: Marguerite Su <i@marguerite.su>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 19, 2012 at 11:02 AM, Marguerite Su <i@marguerite.su> wrote:
> On Sat, Oct 20, 2012 at 12:55 AM, cwillu <cwillu@cwillu.com> wrote:
>> It appears space_cache isn't enabled on your rootfs; can you do a
>> "mount / -o remount,space_cache", sync a couple times, make some
>> coffee, and then reboot, and see if it's better?
>>
>> You should see two instances of "btrfs: disk space caching is enabled"
>> in your dmesg, one for / and the second for /home.
>>
>> Also, make sure to reply-all so that others interested can still follow along.
>
> like this
>
> UUID=9b9aa9d9-760e-445c-a0ab-68e102d9f02e /                    btrfs
>    defaults,space_cache,comment=systemd.automount              1 0
>
> UUID=559dec06-4fd0-47c1-97b8-cc4fa6153fa0 /home                btrfs
>     defaults,space_cache,comment=systemd.automount              1 0
>
> in /etc/fstab?

That would work, but it's only necessary to mount with it once (and
it's probably been done already with /home), hence the -o
remount,space_cache
