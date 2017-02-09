Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:36435 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751760AbdBIRyZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 12:54:25 -0500
Received: by mail-it0-f48.google.com with SMTP id c7so130824494itd.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Feb 2017 09:54:03 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id o80sm5105487ioe.17.2017.02.09.09.54.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2017 09:54:01 -0800 (PST)
Subject: Re: understanding disk space usage
To: linux-btrfs@vger.kernel.org
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
 <20170209132504.ukjehzba5w7k42ow@angband.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d208b9d4-4e82-f6bc-109a-aca8951495cf@gmail.com>
Date: Thu, 9 Feb 2017 12:53:56 -0500
MIME-Version: 1.0
In-Reply-To: <20170209132504.ukjehzba5w7k42ow@angband.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-09 08:25, Adam Borowski wrote:
> On Wed, Feb 08, 2017 at 11:48:04AM +0800, Qu Wenruo wrote:
>> Just don't believe the vanilla df output for btrfs.
>>
>> For btrfs, unlike other fs like ext4/xfs, which allocates chunk dynamically
>> and has different metadata/data profile, we can only get a clear view of the
>> fs from both chunk level(allocated/unallocated) and extent
>> level(total/used).
>
> Actually, df lies on ext4 too.  sysvfs-derived filesystems have statically
> allocated inodes, which means that if you try to store small files, at some
> point you'll run out of space despite df claiming you have plenty left.
Which is why the `-i` option for df exists.

That said, not having any more space is not the same as not being able 
to create more files, and that's been the case since long before Linux 
even existed.  Most people don't think about this though because ext4 
and most other filesystems that use static inode tables allocate insane 
numbers of inodes at mkfs time so it (usually) doesn't ever become an issue.

