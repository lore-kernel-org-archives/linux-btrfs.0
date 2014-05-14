Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:38583 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbaENPLC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 11:11:02 -0400
Message-ID: <53738839.90801@libero.it>
Date: Wed, 14 May 2014 17:14:01 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: jshubin@redhat.com, Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <5373803E.9000406@libero.it> <5373808F.4020403@redhat.com>
In-Reply-To: <5373808F.4020403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2014 04:41 PM, Eric Sandeen wrote:

>> I am not against this option; I am suggesting to add a explicit
>> warning to the user about the risk of doing that, both on the man
>> pages and into the program. The warning should say that this option
>> is only for testing. Better ask for a confirmation (even with an
>> undocumented switch like
>> '--I-know-that-I-am-doing-something-really-dangerous').
> 
> meh.  ext4 and xfs have had the ability to either set or change the
> UUID for years, and I've not heard of any horror stories.

BTRFS tracks the filesystem by UUID, so it behaves strange when two FS have the same UUID. This is the reason for adding further warning. If it would behave like ext4/xfs I didn't suggested to add any warning.

> 
>>
>> For the record, BTRFS seems unable to mount at the same time two different filesystems with the same UUID:
>>
>> $ #
>> $ # try to mount two fs with the same UUID, but BTRFS doesn't allow it
>> $ #
>> $ sudo mount /dev/vdh /mnt/btrfs2
>> $ sudo mount /dev/vdg /mnt/btrfs1
>> ERROR: mount failed : 16 - Device or resource busy
> 
> (presumably the kernel said something, too?)
I see nothing. Maybe it thinks that these are two disks of a multivolume-filesystem...
> 
> and this seems to make it even more safe.
> 
> -Eric
> 
>>
>> BR
>> G.Baroncelli
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
