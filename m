Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-02.dd24.net ([193.46.215.43]:44493 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeCJQ6n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 11:58:43 -0500
Message-ID: <1520701119.24363.33.camel@scientia.net>
Subject: Re: zerofree btrfs support?
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Adam Borowski <kilobyte@angband.pl>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Sat, 10 Mar 2018 17:58:39 +0100
In-Reply-To: <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
References: <1520650525.5641.47.camel@scientia.net>
         <20180310081606.7c2u2dtopijujhbz@angband.pl>
         <1520691545.24363.10.camel@scientia.net> <20180310193722.2d6b494a@natsu>
         <20180310155022.wtdmwiyxu7mxt74s@angband.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2018-03-10 at 16:50 +0100, Adam Borowski wrote:
> Since we're on a btrfs mailing list
Well... my original question was whether someone could make zerofree
support for btrfs (which I think would be best if someone who knows how
btrfs really works)... thus I directed the question to this list and
not to some of qemu :-)


> It works only with scsi and virtio-scsi drivers.  Most qemu setups
> use
> either ide (ouch!) or virtio-blk.
Seems my libvirt created VMs use "sata" per default... and it does seem
to work with that either in the meantime.


Thanks :-)

Chris.
