Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.ord1d.emailsrvr.com ([184.106.54.105]:39961 "EHLO
        smtp105.ord1d.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751313AbdILKjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 06:39:06 -0400
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>, Duncan <1i5t5.duncan@cox.net>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
Cc: linux-btrfs@vger.kernel.org
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
Date: Tue, 12 Sep 2017 13:39:04 +0300
MIME-Version: 1.0
In-Reply-To: <20170912103214.6dzjlugcr7q47x6g@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/17 13:01, Duncan wrote:
> AFAIK that's wrong -- the only time the app should see the error on btrfs
> raid1 is if the second copy is also bad
So thought I, but...

> IIRC from what I've read on-list, qcow2 isn't the best alternative for hosting VMs on
> top of btrfs.
Yeah, I've seen discussions about it here too, but in my case VMs write 
very little (mostly logs and distro updates), so I decided it can live 
as it is for a while. But I'm looking for better solutions as long as 
they are not too complicated.


On 12/09/17 13:32, Adam Borowski wrote:
> Just use raw -- btrfs already has every feature that qcow2 has, and does it
> better.  This doesn't mean btrfs is the best choice for hosting VM files,
> just that raw-over-btrfs is strictly better than qcow2-over-btrfs.
Thanks for advice, I wasn't sure I won't lose features, and was too lazy 
to investigate/ask. Now it looks simple.

--

With Best Regards,
Marat Khalili
