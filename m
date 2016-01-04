Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:46014 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbcADOhv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jan 2016 09:37:51 -0500
Subject: Re: Confining scrub to a subvolume
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <56831EA2.3090807@totakura.in>
 <20151230173949.GH4227@twin.jikos.cz>
 <pan$88aff$ee7e2e75$cb54e003$bedb8f3a@cox.net>
From: Sree Harsha Totakura <sreeharsha@totakura.in>
Message-ID: <568A5126.20801@totakura.in>
Date: Mon, 4 Jan 2016 12:01:58 +0100
MIME-Version: 1.0
In-Reply-To: <pan$88aff$ee7e2e75$cb54e003$bedb8f3a@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/30/2015 07:26 PM, Duncan wrote:
> David Sterba posted on Wed, 30 Dec 2015 18:39:49 +0100 as excerpted:
> 
>> On Wed, Dec 30, 2015 at 01:00:34AM +0100, Sree Harsha Totakura wrote:
>>> Is it possible to confine scrubbing to a subvolume instead of the whole
>>> file system?
>>
>> No. Srub reads the blocks from devices (without knowing which files own
>> them) and compares them to the stored checksums.
> 
> Of course if like me you prefer not to have all your data eggs in one 
> filesystem basket and have used partitions (or LVM) and multiple 
> independent btrfs, in which case you scrub the filesystem you want, and 
> don't worry about the others. =:^)

I considered it, but after reading somewhere (couldn't find the source)
that having a single btrfs could be beneficial, I decided not to.
Clearly, it doesn't seem to be true in this case.

Thank you all for your comments and suggestions.  I will be using
different btrfs file systems based.

Regards,
Sree Harsha Totakura

