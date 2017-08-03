Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38277 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdHCRZj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 13:25:39 -0400
Received: by mail-it0-f43.google.com with SMTP id h199so674632ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 10:25:38 -0700 (PDT)
Subject: Re: Massive loss of disk space
To: Marat Khalili <mkh@rqc.ru>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org
Cc: pwm <pwm@iapetus.neab.net>, Hugo Mills <hugo@carfax.org.uk>
References: <alpine.DEB.2.02.1708011253230.31126@iapetus.neab.net>
 <20170801122039.GX7140@carfax.org.uk>
 <alpine.DEB.2.02.1708011520490.31126@iapetus.neab.net>
 <b30d1b78-7cbd-9bf5-3507-b028b9b8191f@gmail.com>
 <7f2b5c3a-2f5c-e857-d2dc-3ea16b58ecaf@gmail.com>
 <798a9077-bcbd-076c-a458-3403010ce8ac@libero.it>
 <e8abbe21-8cde-1650-8012-9b20a3fcfeec@rqc.ru>
 <ed61fc9b-6d12-f9d1-6e5a-b11b357d377c@inwind.it>
 <AAADF381-631F-4630-B855-46A1658498B2@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2face7a2-2992-d3ad-01f6-8e167bc9d55e@gmail.com>
Date: Thu, 3 Aug 2017 13:25:34 -0400
MIME-Version: 1.0
In-Reply-To: <AAADF381-631F-4630-B855-46A1658498B2@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-03 13:15, Marat Khalili wrote:
> On August 3, 2017 7:01:06 PM GMT+03:00, Goffredo Baroncelli
>> The file is physically extended
>>
>> ghigo@venice:/tmp$ fallocate -l 1000 foo.txt
> 
> For clarity let's replace the fallocate above with:
> $ head -c 1000 </dev/urandom >foo.txt
> 
>> ghigo@venice:/tmp$ ls -l foo.txt
>> -rw-r--r-- 1 ghigo ghigo 1000 Aug  3 18:00 foo.txt
>> ghigo@venice:/tmp$ fallocate -o 500 -l 1000 foo.txt
>> ghigo@venice:/tmp$ ls -l foo.txt
>> -rw-r--r-- 1 ghigo ghigo 1500 Aug  3 18:00 foo.txt
>> ghigo@venice:/tmp$
> 
> According to explanation by Austin the foo.txt at this point somehow occupies 2000 bytes of space because I can reflink it and then write another 1000 bytes of data into it without losing 1000 bytes I already have or getting out of drive space. (Or is it only true while there are open file handles?)
> 
OK, I think there may be some misunderstanding here.  By 'CoW unwritten 
extents', I mean that when we write to the extent, a CoW operation 
happens, instead of the data being written directly into the extent.  In 
this case, it has nothing to do with reflinking, and Goffredo is correct 
that if your filesystem is small enough, the second fallocate will fail 
there.
