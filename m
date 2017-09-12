Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47353 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdILLMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:12:07 -0400
Date: Tue, 12 Sep 2017 13:12:03 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912111159.jcwej7s6uluz4dsz@angband.pl>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 02:01:53PM +0300, Timofey Titovets wrote:
> > On 12/09/17 13:32, Adam Borowski wrote:
> >> Just use raw -- btrfs already has every feature that qcow2 has, and
> >> does it better.  This doesn't mean btrfs is the best choice for hosting
> >> VM files, just that raw-over-btrfs is strictly better than
> >> qcow2-over-btrfs.
> >
> > Thanks for advice, I wasn't sure I won't lose features, and was too lazy to
> > investigate/ask. Now it looks simple.
> 
> The main problem with Raw over Btrfs is that (IIRC) no one support
> btrfs features.
> 
>  - Patches for libvirt not merged and obsolete
>  - Patches for Proxmox also not merged
>  - Other VM hypervisor like Virtualbox, VMware just ignore btrfs features.
> 
> So with raw you will have a problems like: no snapshot support

Why would you need support in the hypervisor if cp --reflink=always is
enough?  Likewise, I wouldn't expect hypervisors to implement support for
every dedup tool -- it'd be a layering violation[1].  It's not emacs or
systemd, you really can use an external tool instead of adding a lawnmower
to the kitchen sink.


Meow!

[1] Yeah, talking about layering violations in btrfs context is a bit weird,
but it's better to at least try.
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
