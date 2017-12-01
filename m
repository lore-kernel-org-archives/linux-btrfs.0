Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:45931 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdLAJaF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 04:30:05 -0500
Received: by mail-wm0-f51.google.com with SMTP id 9so2312321wme.4
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Dec 2017 01:30:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$5abb1$c7dbef76$8f3acd4$8912c489@cox.net>
References: <CAKYHq8+crFyGA7UjaTQehOY5BcKnFLXPVMQ=VZqbeV-XhU63Yw@mail.gmail.com>
 <pan$5abb1$c7dbef76$8f3acd4$8912c489@cox.net>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 1 Dec 2017 10:29:43 +0100
Message-ID: <CAA7pwKOhxP=zLreSXoZfG5TzmiHhfAetVuqXxfz7a=KrkJXoQw@mail.gmail.com>
Subject: Re: btrfs-progs - failed btrfs replace on RAID1 seems to have left
 things in a wrong state
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 December 2017 at 08:18, Duncan <1i5t5.duncan@cox.net> wrote:
>
> When udev sees a device it triggers
> a btrfs device scan, which lets btrfs know which devices belong to which
> individual btrfs.  But once it associates a device with a particular
> btrfs, there's nothing to unassociate it -- the only way to do that on
> a running kernel is to successfully complete a btrfs device remove or
> replacement... and your replace didn't complete due to error.
>
> Of course the other way to do it is to reboot, fresh kernel, fresh
> btrfs state, and it learns again what devices go with which btrfs
> when the appearing devices trigger the udev rule that triggers a
> btrfs scan.

Or reload the btrfs module.
