Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:52384 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbbDAT6M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 15:58:12 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1YdOmA-002FHo-P1
	for linux-btrfs@vger.kernel.org; Wed, 01 Apr 2015 19:58:10 +0000
Message-ID: <551C4DCC.2090208@roeck-us.net>
Date: Wed, 01 Apr 2015 12:58:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fs: btrfs: Add missing include file
References: <1426237126-9700-1-git-send-email-linux@roeck-us.net>	<20150330032413.GA26566@roeck-us.net> <1427916499.20109.0@mail.thefacebook.com>
In-Reply-To: <1427916499.20109.0@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/01/2015 12:28 PM, Chris Mason wrote:
> On Sun, Mar 29, 2015 at 11:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On Fri, Mar 13, 2015 at 01:58:46AM -0700, Guenter Roeck wrote:
>>>  Building alpha:allmodconfig fails with
>>>
>>>  fs/btrfs/inode.c: In function 'check_direct_Excellent idea. Done,IO':
>>>  fs/btrfs/inode.c:8050:2: error: implicit declaration of function 'iov_iter_alignment'
>>>
>>>  due to a missing include file.
>>>
>>>  Fixes: 3737c63e1fb0 ("fs: move struct kiocb to fs.h")
>>>  Cc: Christoph Hellwig <hch@lst.de>
>>>  Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>>  ---
>>
>> This problem still affects the following builds as of today.
>>
>> alpha:allmodconfig
>> i386:allyesconfig
>> i386:allmodconfig
>> m68k:allmodconfig
>> mips:allmodconfig
>> xtensa:allmodconfig
>>
>> and thus probabably many other allmodconfig builds which I don't try to build.
>>
>> This is getting really annoying, and prevents us from finding and fixing
>> other build problems.
>>
>> It has been more than two weeks since I submitted the patch. This suggests
>> that the patch got lost otr that the Powers That Be don't care. Which one
>> is it ?
>>
>> Should I request to revert 3737c63e1fb0 instead ?
>
> I'll put the include into my branch for -next, thanks!
>

I have not seen the problem in the latest -next build,
which presumably means that some other patch must have
fixed the problem or at least hides it now. No idea
which one, though.

Guenter

