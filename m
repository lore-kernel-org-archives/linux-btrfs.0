Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:56843 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbIQVtP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 17:49:15 -0400
Subject: Re: BTRFS as image store for KVM?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <20150917194314.GA29926@carfax.org.uk>
From: Gert Menke <gert@menke.ac>
Message-ID: <55FB3556.1070004@menke.ac>
Date: Thu, 17 Sep 2015 23:49:10 +0200
MIME-Version: 1.0
In-Reply-To: <20150917194314.GA29926@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17.09.2015 at 21:43, Hugo Mills wrote:
> On Thu, Sep 17, 2015 at 07:56:08PM +0200, Gert Menke wrote:
>> BTRFS looks really nice feature-wise, but is not (yet) optimized for
>> my use-case I guess. Disabling COW would certainly help, but I don't
>> want to lose the data checksums. Is nodatacowbutkeepdatachecksums a
>> feature that might turn up in the future?
> [snip]
>
>     No. If you try doing that particular combination of features, you
> end up with a filesystem that can be inconsistent: there's a race
> condition between updating the data in a file and updating the csum
> record for it, and the race can't be fixed.
I'm no filesystem expert, but isn't that what an intent log is for? 
(Does btrfs have an intent log?)

And, is this also true for mirrored or raid5 disks?
I'm thinking something like "if the data does not match the checksum, 
just restore both from mirror/parity" should be possible, right?

Gert
