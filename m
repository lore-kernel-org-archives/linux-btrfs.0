Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:39132 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab3AGSeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 13:34:03 -0500
Message-ID: <50EB14FB.3080002@tiscalinet.it>
Date: Mon, 07 Jan 2013 19:33:31 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
References: <50E9C267.3050302@inwind.it> <20130107163327.GK20089@twin.jikos.cz> <50EB11E0.8030403@tiscalinet.it> <20130107182426.GM19051@carfax.org.uk>
In-Reply-To: <20130107182426.GM19051@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi hugo

On 01/07/2013 07:24 PM, Hugo Mills wrote:
[...]

>>     print "Superblock #%d - %20d - '%s'"%(i,pos,sign)
>>
>> $ python extract-sign.py
>> Superblock #0 -                65600 - '_BHRfS_M'
> 
> 64 KiB

OK, (above)
> 
>> Superblock #1 -             67108928 - '_BHRfS_M'
> 
> 256 MiB

.... above is 64M, below is 256M !
> 
>> Superblock #2 -         274877907008 - '_BHRfS_M'
> 
> 1 TiB
> 
>> Superblock #3 -     1125899906842688 - ''
> 
> 4 PiB
> 
>> Superblock #4 -  4611686018427387968 - ''
> 
> 16 EiB

Not reachable in linux. There is a VFS limits to 8EB.
> 
> 
>> To me it seems that in a 7TB filesystem there is only 3 superblocks.
> 
>    That would be as expected. How many on a 5 PiB filesystem, though?
> Or a 20 EiB one?

I wrote 7TB, but I meant 8EB. I first tried a test with 7TB and I wrote
the email, but then I retested with 8EB and I corrected the email,
forgetting some 7t instead of 8e...

Anyway, if BTRFS would allow more than three super-block,  in the 7TB
case, the super-block at 1TB would appeared
> 
>    Hugo.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
