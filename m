Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:37255 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdHNOXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 10:23:54 -0400
Received: by mail-it0-f46.google.com with SMTP id 76so18894971ith.0
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 07:23:53 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
Date: Mon, 14 Aug 2017 10:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <1502713484.3608.1.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-14 08:24, Christoph Anton Mitterer wrote:
> On Mon, 2017-08-14 at 14:36 +0800, Qu Wenruo wrote:
>>> And how are you going to write your data and checksum atomically
>>> when
>>> doing in-place updates?
>>
>> Exactly, that's the main reason I can figure out why btrfs disables
>> checksum for nodatacow.
> 
> Still, I don't get the problem here...
> 
> Yes it cannot be done atomically (without workarounds like a journal or
> so), but this should be only an issue in case of a crash or similar.
> 
> And in this case nodatacow+nochecksum is anyway already bad, it's also
> not atomic, so data may be completely garbage (e.g. half written)...
> just that no one will ever notice.
> 
> The only problem that nodatacow + checksuming + nonatomic should give
> is when the data was actually correctly written at a crash, but the
> cheksum was not, in which case the bogus checksum would invalidate the
> good data on next read.
> 
> Or do I miss something?
> 
> 
> To me that sounds still much better than having no protection at all.
Assume you have higher level verification.  Would you rather not be able 
to read the data regardless of if it's correct or not, or be able to 
read it and determine yourself if it's correct or not?  For almost 
anybody, the answer is going to be the second case, because the 
application knows better than the OS if the data is correct (and 
'correct' may be a threshold, not some binary determination).  At that 
point, you need to make the checksum error a warning instead of 
returning -EIO.  How do you intend to communicate that warning back to 
the application?  The kernel log won't work, because on any reasonably 
secure system it's not visible to anyone but root.  There's also no side 
channel for the read() system calls that you can utilize.  That then 
means that the checksums end up just being a means for the administrator 
to know some data wasn't written correctly, but they should know that 
anyway because the system crashed.  As a result, the whole thing ends up 
reduced to some extra work for a pointless notification that some people 
may not even see.

Looking at this from a different angle: Without background, what would 
you assume the behavior to be for this?  For most people, the assumption 
would be that this provides the same degree of data safety that the 
checksums do when the data is CoW.  We already have enough issues with 
people misunderstanding how things work and losing data as a result 
(keep in mind that the average user doesn't read documentation and will 
often blindly follow any random advice they see online), and we don't 
need more that are liable to cause data loss.
