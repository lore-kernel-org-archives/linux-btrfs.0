Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39915 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab2JSQ3r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 12:29:47 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so554527pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 09:29:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
	<20121018132850.GA22010@shiny>
	<CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
	<CAE5mzvi6B_KqmVBSsNRyK6==k9f_MgYK1y4Aw-5jxZ1AhoxxOg@mail.gmail.com>
	<CAK0PdAk+Q=bY8OMn8mP8HB4iorgLYLYQv6bJM_uLkBozFJwQcg@mail.gmail.com>
	<CAK0PdA=DSoWV-8RDFy10guE1QEL4VegUwrM4JwC5HNpQF8eK5w@mail.gmail.com>
Date: Fri, 19 Oct 2012 10:29:46 -0600
Message-ID: <CAE5mzvj4_vknNaKnpFG+Q+Tpg1dxA+W+g9xWhDPMLrmt2_Lk3A@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
From: cwillu <cwillu@cwillu.com>
To: Marguerite Su <i@marguerite.su>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 19, 2012 at 10:18 AM, Marguerite Su <i@marguerite.su> wrote:
> On Fri, Oct 19, 2012 at 11:41 PM, cwillu <cwillu@cwillu.com> wrote:
>> Also, next time just put the output directly in the email, that way
>> it's permanently around to look at and search for.
>
> Hi,
>
> I did it. here's my dmesg:

> I made the snapshot at:
>
> mount -o rw,defaults,comment=systemd.automount -t btrfs /dev/root /root
>
> and
>
> Starting Tell Plymouth To Write Out Runtime Data...
> Started Recreate Volatile Files and Directories
>
>
> is it useful this time?

More useful every time!

Can you post the full output of dmesg, or at least the first couple
hundred seconds of it?
