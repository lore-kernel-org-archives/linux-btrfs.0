Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51839 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaK2VHf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 16:07:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XupEr-0000Gh-QS
	for linux-btrfs@vger.kernel.org; Sat, 29 Nov 2014 22:07:33 +0100
Received: from 66.87.138.157 ([66.87.138.157])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 22:07:33 +0100
Received: from eternaleye by 66.87.138.157 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Nov 2014 22:07:33 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Sat, 29 Nov 2014 13:07:20 -0800
Message-ID: <m5dcia$tk8$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <20141125163905.GJ26471@twin.jikos.cz> <m5dash$58v$1@ger.gmane.org> <CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

John Williams wrote:

> On Sat, Nov 29, 2014 at 12:38 PM, Alex Elsayed <eternaleye@gmail.com>
> wrote:
>> Why not just use the kernel crypto API? Then the user can just specify
>> any hash the kernel supports.
> 
> One reason is that crytographic hashes are an order of magnitude
> slower than the fastest non-cryptographic hashes. And for filesystem
> checksums, I do not see a need for crypotgraphic hashes.

I'd suggest looking more closely at the crypto api section of menuconfig - 
it already has crc32c, among others. Just because it's called the "crypto 
api" doesn't mean it only has cryptographically-strong algorithms. As a side 
benefit, if someone implements (say) SipHash for it, then not only could 
btrfs benefit, but also all other users of the API, including (now) 
userspace.

The crypto api also has compression, for zlib/lzo/lz4/lz4hc, but I'm given 
to understand that btrfs' usage of compression doesn't match well to that 
API.

