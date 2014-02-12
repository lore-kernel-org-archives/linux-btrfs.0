Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:42661 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBLVDw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Feb 2014 16:03:52 -0500
Message-ID: <52FBE1A9.7080100@libero.it>
Date: Wed, 12 Feb 2014 22:03:37 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: What to do about df and btrfs fi df
References: <52F9014F.6070901@fb.com> <52F95222.1010403@libero.it> <52FA224B.1030805@fb.com> <52FA69E7.7020206@libero.it> <20140211185657.GM6490@carfax.org.uk>
In-Reply-To: <20140211185657.GM6490@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

On 02/11/2014 07:56 PM, Hugo Mills wrote:

>> $ sudo btrfs filesystem df /mnt/btrfs1/
>> Disk size:		 400.00GB
>> Disk unallocated:	 391.97GB
>> Disk allocation:
>>                         Allocated	Used
>>    Data, single:           2.01GB,         1.00GB
>>    System, DUP:            4.00MB          2.00MB
>>    System, single:         4.00MB          1.00MB
>>    Metadata, DUP:          2.00GB        750.00MB
>>    Metadata, single:       8.00MB          2.20MB
>>                            ------         -------
>>    Total:                  7.00GB          1.75GB
> 
>    Two minor nits here: please put a space between the number and the
> units, and distinguish between e.g. MB (powers of 10) and MiB (powers
> of 2).

I will use the pretty_size_snprintf() function, which uses the powers 
of 2 units, but unfortunately doesn't seems to have the space. 
The space could be added with a dedicated patch.

> 
>    Hugo.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
