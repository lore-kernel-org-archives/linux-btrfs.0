Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:60978 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaD3Rf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 13:35:27 -0400
Received: from venice.bhome (151.29.84.244) by outrelay07.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 535FA3830064E4B6 for linux-btrfs@vger.kernel.org; Wed, 30 Apr 2014 19:35:25 +0200
Message-ID: <536134F8.2000908@libero.it>
Date: Wed, 30 Apr 2014 19:38:00 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/14] btrfs-progs: Print more info about device sizes
References: <cover.1398786620.git.dsterba@suse.cz> <cfc78e5581e0142caf9a5fe049213c8e5de90efa.1398786620.git.dsterba@suse.cz> <CAMU1PDj3CwYJgiGG27cR+XgZvRFLxY8sAQocRavi8oT9-2Kz+Q@mail.gmail.com> <5360E0EF.8030109@libero.it> <20140430121140.GI5988@twin.jikos.cz> <5360FB26.9090009@kingswood-consulting.co.uk> <20140430133715.GA7571@yadt.co.uk>
In-Reply-To: <20140430133715.GA7571@yadt.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/30/2014 03:37 PM, David Taylor wrote:
> On Wed, 30 Apr 2014, Frank Kingswood wrote:
>> On 30/04/14 13:11, David Sterba wrote:
>>> On Wed, Apr 30, 2014 at 01:39:27PM +0200, Goffredo Baroncelli wrote:
>>>>
>>>> I found a bit unclear the "FS occupied" terms.
>>>
>>> We're running out of terms to describe and distinguish the space that
>>> the filesystem uses.
>>>
>>> 'occupied' seemed like a good choice to me, though it may be not obvious
>>
>> The space that the filesystem uses in total seems to me is called the
>> "size". It has nothing to do with utilization.
>>
>> /dev/sda6, ID: 2
>>     Device size:            10.00GiB
>>     Filesystem size:         5.00GiB
> 
> FS size was what I was about to suggest, before I saw your reply.

Pay attention that this value is not the Filesystem size, 
but to the maximum space the of THE DEVICE the filesystem is allowed to use.

The filesystem size (the space available or the sum of the space available and
the one occupied) is based on this value but it should be very different (think
about a RAID 1 on three device of different sizes....)

> 
> It makes more sense to me than 'Occupied' and seems cleaner than
> 'Resized To'.  It sort of mirrors how LVM describes PV / VG / LV
> sizes, too.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
