Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:60862 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934057AbdGTWC2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 18:02:28 -0400
Subject: Re: strange No space left on device issues
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Omar Sandoval <osandov@osandov.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500586436.7266.18.camel@scientia.net>
 <20170720214813.GE29924@vader.DHCP.thefacebook.com>
 <1500587596.7266.20.camel@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <da04aa8b-175f-273b-3c05-f132094d3d68@mendix.com>
Date: Fri, 21 Jul 2017 00:02:26 +0200
MIME-Version: 1.0
In-Reply-To: <1500587596.7266.20.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/20/2017 11:53 PM, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 14:48 -0700, Omar Sandoval wrote:
> [...]
> 
>>> I assume you'll take care to get that patch into stable kernels?
>>> Is this patch alone enough to recommend the Debian maintainers to
>>> include it into their 4.9 long term stable kernels?
>>
>> I'll mark it for stable, assuming Debian tracks the upstream LTS
>> releases it should get in.

+1 \o/

> Okay :-)
> 
> Nevertheless I'll open a bug at their BTS, just to be safe.

The Debian kernel teams tries to minimize the amount of patches on top
of the original kernel code. Every patch added comes with a maintenance
burden.

So, the answer will probably be: Please get it in 4.9 itself.

-- 
Hans van Kranenburg
