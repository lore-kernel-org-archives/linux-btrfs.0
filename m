Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30239 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbbDAT2e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Apr 2015 15:28:34 -0400
Date: Wed, 1 Apr 2015 15:28:19 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] fs: btrfs: Add missing include file
To: Guenter Roeck <linux@roeck-us.net>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Message-ID: <1427916499.20109.0@mail.thefacebook.com>
In-Reply-To: <20150330032413.GA26566@roeck-us.net>
References: <1426237126-9700-1-git-send-email-linux@roeck-us.net>
	<20150330032413.GA26566@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 29, 2015 at 11:24 PM, Guenter Roeck <linux@roeck-us.net> 
wrote:
> On Fri, Mar 13, 2015 at 01:58:46AM -0700, Guenter Roeck wrote:
>>  Building alpha:allmodconfig fails with
>> 
>>  fs/btrfs/inode.c: In function 'check_direct_IO':
>>  fs/btrfs/inode.c:8050:2: error: implicit declaration of function 
>> 'iov_iter_alignment'
>> 
>>  due to a missing include file.
>> 
>>  Fixes: 3737c63e1fb0 ("fs: move struct kiocb to fs.h")
>>  Cc: Christoph Hellwig <hch@lst.de>
>>  Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>>  ---
> 
> This problem still affects the following builds as of today.
> 
> alpha:allmodconfig
> i386:allyesconfig
> i386:allmodconfig
> m68k:allmodconfig
> mips:allmodconfig
> xtensa:allmodconfig
> 
> and thus probabably many other allmodconfig builds which I don't try 
> to build.
> 
> This is getting really annoying, and prevents us from finding and 
> fixing
> other build problems.
> 
> It has been more than two weeks since I submitted the patch. This 
> suggests
> that the patch got lost otr that the Powers That Be don't care. Which 
> one
> is it ?
> 
> Should I request to revert 3737c63e1fb0 instead ?

I'll put the include into my branch for -next, thanks!

-chris



