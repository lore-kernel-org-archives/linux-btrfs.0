Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from columbia.partiallystapled.com ([199.38.182.105]:53140 "EHLO
	columbia.partiallystapled.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbbDMOih (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:38:37 -0400
Message-ID: <552BD4E8.6070703@partiallystapled.com>
Date: Mon, 13 Apr 2015 10:38:32 -0400
From: Michael Tharp <gxti@partiallystapled.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Degraded volume silently fails to mount
References: <552BC9CD.6090406@partiallystapled.com> <20150413140736.GC22084@carfax.org.uk>
In-Reply-To: <20150413140736.GC22084@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/13/2015 10:07, Hugo Mills wrote:
> On Mon, Apr 13, 2015 at 09:51:09AM -0400, Michael Tharp wrote:
>> Hi list,
>>
>> I've got a 4 disk raid1 volume that has one failed disk. I have so
>> far been unable to mount it in degraded mode, but the failure is
>> that "mount" silently does nothing.
>
>     Check to see if systemd is unmounting it immediately after
> mount. This seems to be the usual reason for silent failures to mount
> an FS these days.

Sigh, that was it. Thanks. Faith in btrfs restored.

I had a custom unit file because the generated ones weren't getting the 
LUKS device dependencies correct. When the drive failed I commented out 
the fstab and crypttab entries but forgot about the custom unit file.
