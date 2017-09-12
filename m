Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:46315 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdILKcQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 06:32:16 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1driUJ-0002EH-2W
        for linux-btrfs@vger.kernel.org; Tue, 12 Sep 2017 12:32:15 +0200
Date: Tue, 12 Sep 2017 12:32:14 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912103214.6dzjlugcr7q47x6g@angband.pl>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 10:01:07AM +0000, Duncan wrote:
> BTW, I am most definitely /not/ a VM expert, and won't pretend to 
> understand the details or be able to explain further, but IIRC from what 
> I've read on-list, qcow2 isn't the best alternative for hosting VMs on 
> top of btrfs.  Something about it being cow-based as well, which means cow
> (qcow2)-on-cow(btrfs), which tends to lead to /extreme/ fragmentation, 
> leading to low performance.
> 
> I don't know enough about it to know what the alternatives to qcow2 are, 
> but something that not itself cow when it's on cow-based btrfs, would 
> presumably be a better alternative.

Just use raw -- btrfs already has every feature that qcow2 has, and does it
better.  This doesn't mean btrfs is the best choice for hosting VM files,
just that raw-over-btrfs is strictly better than qcow2-over-btrfs.

And like qcow2, with raw over btrfs you have the choice between a fully
pre-written nocow file and a sparse file.  For the latter, you want discard
in the guest (not supported over ide and virtio, supported over scsi and
virtio-scsi), and you get the full list of btrfs goodies like snapshots or
dedup.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
