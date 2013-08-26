Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44721 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab3HZBW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 21:22:57 -0400
Date: Mon, 26 Aug 2013 09:22:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: mpe <michele@unipex.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Deduplication
Message-ID: <20130826012228.GA17457@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAJtBfr-ZncC9iOB=GegDXhOsayEXVk6gfu2P2X8PeeOQk3hZ3Q@mail.gmail.com>
 <20130823074236.GA2229@localhost.localdomain>
 <kv7c2j$3gf$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <kv7c2j$3gf$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 12:04:10PM +0200, mpe wrote:
> On 23/08/2013 09:42, Liu Bo wrote:
> >Hi,
> >
> >On Thu, Aug 22, 2013 at 09:28:09PM +0200, Florian Lindner wrote:
> >>Hello,
> >>
> >>some questions regarding btrfs deduplication.
> >>
> >>- What is the state of it? Is it "safe" to use?
> >>https://btrfs.wiki.kernel.org/index.php/Deduplication does not yield
> >>much information.
> >
> >For inband dedup, it's experimental because it introduces some format changes.
> >
> 
> In our tests we are trying btrfs for our internal storage backup
> backend and we like a lot compression! Now would like to test inband
> dedup.

dedup can cope with compression, too.

> Does those patchs (are v6 the last?) can be used on ubuntu lts? Do
> have a simple howt-to to follow?

I didn't try ubuntu lts yet, but the v6 patch set can be well applied on
3.11-rc4.

To enable dedup, you need to
1) mount DEV /PATH_OF_MNT -o dedup (or -o dedup_bs=xxxK)
2) btrfs dedup register /PATH_OF_MNT
3) write your data now :)


Feel free to tell me if any questions, thanks.

-liubo
