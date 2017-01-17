Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:33160 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdAQVwy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 16:52:54 -0500
Received: by mail-yw0-f174.google.com with SMTP id l75so100054973ywb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jan 2017 13:52:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lgu9cu2v.fsf@grothesque.org>
References: <87o9z7dzvd.fsf@grothesque.org> <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
 <871sw2cbzb.fsf@grothesque.org> <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
 <87lgu9cu2v.fsf@grothesque.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 17 Jan 2017 14:52:52 -0700
Message-ID: <CAJCQCtTGUpVUZYB=Rz4Rif5Te2LqSUAdxvu3FLooEMdWO-nitw@mail.gmail.com>
Subject: Re: Unocorrectable errors with RAID1
To: Christoph Groth <christoph@grothesque.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2017 at 1:25 PM, Christoph Groth
<christoph@grothesque.org> wrote:
> Goldwyn Rodrigues wrote:
>>
>> On 01/17/2017 02:44 AM, Christoph Groth wrote:
>>>
>>> Goldwyn Rodrigues wrote:
>>>
>>>> Would you be able to upload a btrfs-image for me to examine. This is a
>>>> core ctree error where most probably item size is incorrectly
>>>> registered.
>>>
>>>
>>> Sure, I can do that.  I'd like to use the -s option, will this be fine?
>>
>>
>> Yes, I think that should be fine.
>
>
> Unfortunately, giving -s causes btrfs-image to segfault.  I tried both
> btrfs-progs 4.7.3 and 4.4.  I also tried different compression levels.
>
> Without -s it works, but since this file system contains the complete
> digital life of our family, I would rather not share even the file names.
>
> Any ideas on what could be done?  If you need help to debug the problem with
> btrfs-image, please tell me what I should do.  I can keep the broken file
> system around until an image can be created at some later time.

Try 4.9, or even 4.8.5, tons of bugs have been fixed since 4.7.3
although I don't know off hand if this particular bug is fixed. I did
recently do a btrfs-image with btrfs-progs v4.9 with -s and did not
get a segfault.



-- 
Chris Murphy
