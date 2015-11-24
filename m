Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbbKXEkx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 23:40:53 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <5653EA53.9020405@redhat.com>
Date: Mon, 23 Nov 2015 22:40:51 -0600
MIME-Version: 1.0
In-Reply-To: <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/23/15 10:35 PM, Duncan wrote:
> Christoph Anton Mitterer posted on Tue, 24 Nov 2015 05:02:34 +0100 as
> excerpted:
> 
>> Hey.
>>
>> Short question since that came up on debian-devel.
>>
>> Now that btrfs check get's more and more useful, are the developers
>> going to recommend running it periodically on boot (of course that
>> wouldn't work right now, as it would *always* check)?
> 
> I'm a list regular and btrfs user, not a dev, but all the indications 
> continue to point to _not_ running it automatically at boot, nobody even 
> _suggesting_ otherwise.  The btrfs kernel code itself detects and often 
> corrects many problems, and btrfs check is simply not recommended for 
> automatic at-boot scheduling -- if the kernel code can't fix it without 
> intervention, then the problem is too serious to be fixed without 
> intervention by some scheduled btrfs check run, as well.
> 
> In fact, take a look at the shipped fsck.btrfs shell-script, based upon 
> the xfs one.

FWIW, fsck.xfs is a no-op because xfs is a *journaling filesystem* and an
unclean shutdown is not a reason to force a filesystem repair on the next
boot.

...that's what the journal was for...!  The filesystem should be 100%
consistent after a mount & a log replay.

The only reason fsck.xfs came into existence was to satisfy initscripts,
IIRC.

-Eric

