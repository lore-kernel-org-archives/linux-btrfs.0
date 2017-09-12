Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp97.iad3a.emailsrvr.com ([173.203.187.97]:36131 "EHLO
        smtp97.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751289AbdILL0y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:26:54 -0400
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
To: Adam Borowski <kilobyte@angband.pl>, Duncan <1i5t5.duncan@cox.net>
References: <2ee9f15b-a11a-886e-2460-557bb9f8d41d@rqc.ru>
 <CAGqmi770j8gO8zFNiMgie5n3b6rm2JVdvG+K+HMDJ-CpMCiEiw@mail.gmail.com>
 <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
From: Marat Khalili <mkh@rqc.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
Date: Tue, 12 Sep 2017 14:26:39 +0300
MIME-Version: 1.0
In-Reply-To: <20170912111159.jcwej7s6uluz4dsz@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/17 14:12, Adam Borowski wrote:
> Why would you need support in the hypervisor if cp --reflink=always is
> enough?
+1 :)

But I've already found one problem: I use rsync snapshots for backups, 
and although rsync does have --sparse argument, apparently it conflicts 
with --inplace. You cannot have all nice things :(

I think I'll simply try to minimize size of VM root partitions and won't 
think too much about gig or two extra zeroes in backup, at least until 
some autopunchholes mount option arrives.

--

With Best Regards,
Marat Khalili
