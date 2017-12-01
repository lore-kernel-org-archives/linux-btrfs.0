Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36216 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdLASE5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 13:04:57 -0500
Received: by mail-io0-f169.google.com with SMTP id 81so12153748iof.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Dec 2017 10:04:57 -0800 (PST)
Subject: Re: btrfs-transacti hammering the system
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Matt McKinnon <matt@techsquare.com>, linux-btrfs@vger.kernel.org
References: <bb2cfbcb-31dd-715c-114f-59d574a2012b@techsquare.com>
 <9703c200-28af-f26d-b3b2-6982fb289ac8@mendix.com>
 <1d11e03c-7d02-3f66-8b97-4c1b857566fa@techsquare.com>
 <b52265f9-2703-7f25-b1b9-6e84bc7db62e@mendix.com>
 <c9e5ef0a-e60b-b892-272c-1594d47f0657@techsquare.com>
 <5ecddad2-bb6a-2991-c8d0-be97a4541b0d@mendix.com>
 <09218217-6c17-80df-380a-6c20366c70f3@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dc6eb5d9-f514-3f49-7ab6-64ab1cf30462@gmail.com>
Date: Fri, 1 Dec 2017 13:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <09218217-6c17-80df-380a-6c20366c70f3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-01 12:13, Andrei Borzenkov wrote:
> 01.12.2017 20:06, Hans van Kranenburg пишет:
>>
>> Additional tips (forgot to ask for your /proc/mounts before):
>> * Use the noatime mount option, so that only accessing files does not
>> lead to changes in metadata,
> 
> Is not 'lazytime" default today? It gives you correct atime + no extra
> metadata update cause by update of atime only.
Unless things have changed since the last time this came up, BTRFS does 
not support the 'lazytime' mount option (but it doesn't complain about 
it either).

Also, lazytime is independent from noatime, and using both can have 
benefits (lazytime will still have to write out the inode for every file 
read on the system every 24 hours, but with noatime it only has to write 
out the inode for files that have changed).

On top of all that though, you generally shouldn't be trusting atime 
because:
1. Many people run with noatime (or patch their kernels to default to 
noatime instead of relatime), so you can't be certain if the atime is 
accurate at all.
2. It has somewhat non-intuitive semantics when dealing with directories.
3. Even without noatime thrown in, you only get 1 day resolution by 
default (as per the operation of 'relatime').
4. Essentially nothing uses it other than find (which only has one day 
resolution as it's typically used) and older versions of mutt (which use 
it because of lazy programming), which is why issue 1 and 3 are the case.
