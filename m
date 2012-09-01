Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54376 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab2IAXt1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Sep 2012 19:49:27 -0400
Received: by lagy9 with SMTP id y9so2962927lag.19
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Sep 2012 16:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
References: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
	<CAGDaZ_p2dXLr6rOZewXUEWYKV4b=dW9OZj4yXG4qPoUax2a8CA@mail.gmail.com>
	<CAGJTRciVqG=CqP4gR4gpz2bmFYORS6ExAT_nDbau2NuCJyipeg@mail.gmail.com>
	<CAGDaZ_qm+Z7ptRdp-kJx_AJgcJ+bjWX7OZ5O1ang7sbJ_Y_f-w@mail.gmail.com>
	<CAE5mzvgp1LAaYrMyjbAKZVRyKcaoWAZwQVBfGQQUZh+6+w9Rvw@mail.gmail.com>
	<CAGDaZ_pZvOTCtMkq8+w6wJKpSuBzpntbjTLKBHqGuzpycUndjw@mail.gmail.com>
Date: Sat, 1 Sep 2012 18:49:25 -0500
Message-ID: <CAGJTRcgXRRRoxycOwFurWjK2N6DXfC0v1ZhrMkSx+zi1NACM5w@mail.gmail.com>
Subject: Re: rfc: fuzz testing by direct writes to device
From: Michael <mike@draftx.net>
To: Shentino <shentino@gmail.com>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It should not. It is always preferred that you dd your drive onto
another disk just in case though.

On Sat, Sep 1, 2012 at 5:31 PM, Shentino <shentino@gmail.com> wrote:
> On Sat, Sep 1, 2012 at 1:59 PM, cwillu <cwillu@cwillu.com> wrote:
>> You still haven't said which kernel you were running; the thing to do
>> is try the very latest rc (if not btrfs-next).
>
> Sorry about that!
>
> I thought I included it.
>
> 3.3.8
>
> Hmm...seems it's been EOL'ed.  I need to yell at my distro.
>
> In the meantime, will mounting a btrfs filesystem with a new kernel
> render it unmountable by older kernels?
