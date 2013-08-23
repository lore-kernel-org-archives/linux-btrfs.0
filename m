Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47059 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab3HWKKE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 06:10:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCoJf-0007zM-Ew
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 12:10:03 +0200
Received: from gw.corp.inasset.net ([82.193.33.243])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:10:03 +0200
Received: from michele by gw.corp.inasset.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: mpe <michele@unipex.it>
Subject: Re: Deduplication
Date: Fri, 23 Aug 2013 12:04:10 +0200
Message-ID: <kv7c2j$3gf$1@ger.gmane.org>
References: <CAJtBfr-ZncC9iOB=GegDXhOsayEXVk6gfu2P2X8PeeOQk3hZ3Q@mail.gmail.com> <20130823074236.GA2229@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <20130823074236.GA2229@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/08/2013 09:42, Liu Bo wrote:
> Hi,
>
> On Thu, Aug 22, 2013 at 09:28:09PM +0200, Florian Lindner wrote:
>> Hello,
>>
>> some questions regarding btrfs deduplication.
>>
>> - What is the state of it? Is it "safe" to use?
>> https://btrfs.wiki.kernel.org/index.php/Deduplication does not yield
>> much information.
>
> For inband dedup, it's experimental because it introduces some format changes.
>

In our tests we are trying btrfs for our internal storage backup backend 
and we like a lot compression! Now would like to test inband dedup.
Does those patchs (are v6 the last?) can be used on ubuntu lts? Do have 
a simple howt-to to follow?

Thanks,
Michele

