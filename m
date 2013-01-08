Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:44167 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3AHUJa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 15:09:30 -0500
Message-ID: <50EC7CF9.9010308@tiscalinet.it>
Date: Tue, 08 Jan 2013 21:09:29 +0100
From: Goffredo Baroncelli <kreijack@tiscalinet.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>, Chris Mason <chris.mason@fusionio.com>
CC: Goffredo Baroncelli <kreijack@inwind.it>, util-linux@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
References: <50E9C267.3050302@inwind.it> <20130108180126.GB9177@x2.net.home>
In-Reply-To: <20130108180126.GB9177@x2.net.home>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Karel,

On 01/08/2013 07:01 PM, Karel Zak wrote:
> On Sun, Jan 06, 2013 at 07:28:55PM +0100, Goffredo Baroncelli wrote:
>> If the first superblock is valid except that the "magic field" is zeroed,
>> btrfs skips the check of the other superblocks.
>> If the first superblock is fully invalid, btrfs checks for the other
>> superblock.
> 
>  Hmm... why inconsistent (or missing) superblock is not reported as a
>  problem? If I good understand the filesystem is still mountable,
>  right?

It should, however my tests were unsuccessful :-(... Chris ?


> 
>> So zeroing the first superblock "magic field" at the beginning seems
>> that the filesystem is wiped.
> 
>  Well, this is exactly the idea behind wipefs(8), just wipe minimal
>  number of bytes from the device to make the filesystem invisible for
>  libblkid (udev, ...). This concept is relatively safe, if you make a
>  mistake than you can restore the magic string, your data should not
>  be affected by wipefs(8).

I fully agree. However wipefs should zero all three superblock

> 
>     Karel
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
