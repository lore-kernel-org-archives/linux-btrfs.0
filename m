Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([212.48.14.170]:48343 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751345AbdIFSo2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Sep 2017 14:44:28 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/5] Mkfs: Rework --rootdir to a more generic behavior
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
 <20170904180856.GG31874@twin.jikos.cz>
 <b2299128-307f-b35f-e4c7-396d3a5d3a17@gmx.com>
 <a82d6478-9af3-6876-6b29-1b9c4d73b291@libero.it>
 <724a29dd-54c1-77ae-3c3b-82c409e5d20b@gmx.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <7028aaba-7ce6-956a-415f-695414c11115@inwind.it>
Date: Wed, 6 Sep 2017 20:44:26 +0200
MIME-Version: 1.0
In-Reply-To: <724a29dd-54c1-77ae-3c3b-82c409e5d20b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/06/2017 05:20 AM, Qu Wenruo wrote:
>>
>> BTW I compiled successfully the patches, and these seems to work.
>>
>> PS: I tried to cross-compile mkfs.btrfs ton arm, but mkfs.btrfs was unable to work:
>>
>> $ uname -a
>> Linux bananapi 4.4.66-bananian #2 SMP Sat May 6 19:26:50 UTC 2017 armv7l GNU/Linux
>> $ sudo ./mkfs.btrfs /dev/loop0
>> btrfs-progs v4.12.1-5-g3c9451cd
>> See http://btrfs.wiki.kernel.org for more information.
>>
>> ERROR: superblock magic doesn't match
>> Performing full device TRIM /dev/loop0 (10.00GiB) ...
>> ERROR: open ctree failed
>>
>> However this problem exists even with a plain v4.12.1. The first error seems to suggest that there is some endian-ness issue
> 
> I'd better get one cheap ARM board if I want to do native debug.
> 
> BTW, what's the output of dump-super here?

Further tests seems to highlight that it was a my setup problem. Before I build mkfs.btrfs cross-compiling from an amd64, and I got the error; retrying on the native environment I was unable to reproduce the problem.

So please ignore the previous email.

> Which may gives us some clue to fix it.
> 
> Thanks,
> Qu


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
