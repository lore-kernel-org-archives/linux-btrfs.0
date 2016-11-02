Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60629 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754930AbcKBATk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 20:19:40 -0400
Subject: Re: Snapper & apt-btrfs-snapshot on Ubuntu
To: badara+ml@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <7d615bfc-b7f0-dd01-6cff-61d0f978fc53@mendix.com>
Date: Wed, 2 Nov 2016 01:19:36 +0100
MIME-Version: 1.0
In-Reply-To: <CAN5=xXnZmaqApRds3w=AKLAvfk=+dEPNazEb+Tzym_=2OdnfzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2016 01:00 AM, Ahmed Badr wrote:
> 
> Btrfs newbie here

Congrats!

> trying to figure out how to use it properly on Ubuntu
> 16.04 server.
> 
> I have root formated using Btrfs, and installed Snapper and everything
> seems to works fine. I installed apt-btrfs-snapshot which takes snapshot
> before and after apt-get just like OpenSUSE/Zypper and that seems to work
> fine too.
> 
> The problem is, unlike OpenSUSE/Zypper, on Ubuntu neither Snapper nor
> apt-btrfs-snapshot see the snapshots made by the other program. So I cannot
> list, compare or manage the apt-btrfs snapshots using snapper. Any way to
> fix this?

To get more info, try 'btrfs sub list -q /mountpoint'. This will show
you in where both tools create their snapshots, and it will show
(parent_uuid field) which subvolume they're taken from.

While all of the snapshots with a matching parent_uuid are snapshots of
the same thing in linear time for btrfs, the tools may have their own
added administration on top (like snapshot names, or directories they're
placed in), which prevents them from being able to do something with the
other ones. This is not the fault of btrfs, it's because those tools
probably are designed to ignore anything they didn't cause to happen
themselves.

-- 
Hans van Kranenburg
