Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:54893 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751718AbdILRVa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:21:30 -0400
Date: Tue, 12 Sep 2017 19:21:25 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Marat Khalili <mkh@rqc.ru>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912172125.rb6gtqdxqneb36js@angband.pl>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 02:26:39PM +0300, Marat Khalili wrote:
> On 12/09/17 14:12, Adam Borowski wrote:
> > Why would you need support in the hypervisor if cp --reflink=always is
> > enough?
> +1 :)
> 
> But I've already found one problem: I use rsync snapshots for backups, and
> although rsync does have --sparse argument, apparently it conflicts with
> --inplace. You cannot have all nice things :(

There's fallocate -d, but that for some reason touches mtime which makes
rsync go again.  This can be handled manually but is still not nice.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
