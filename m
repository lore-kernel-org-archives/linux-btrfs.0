Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38322 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932147AbdBHMVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 07:21:06 -0500
Received: by mail-it0-f49.google.com with SMTP id c7so101403108itd.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 04:21:06 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id v68sm11155474ioi.20.2017.02.08.04.12.19
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Feb 2017 04:12:20 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
 <91c8a758-23b6-edf1-74b0-2d87acbb2560@gmail.com>
 <20170207211941.3310d7a8@jupiter.sol.kaishome.de>
 <6d7eac16-773e-bf6c-a6be-d3950f9b2325@gmail.com>
 <20170207215408.65030acd@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <50cd6718-b0f6-90f2-b9b4-b60228c131e3@gmail.com>
Date: Wed, 8 Feb 2017 07:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <20170207215408.65030acd@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 15:54, Kai Krakow wrote:
> Am Tue, 7 Feb 2017 15:27:34 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>>>> I'm not sure about this one.  I would assume based on the fact that
>>>> many other things don't work with nodatacow and that regular defrag
>>>> doesn't work on files which are currently mapped as executable code
>>>> that it does not, but I could be completely wrong about this too.
>>>
>>> Technically, there's nothing that prevents autodefrag to work for
>>> nodatacow files. The question is: is it really necessary? Standard
>>> file systems also have no autodefrag, it's not an issue there
>>> because they are essentially nodatacow. Simply defrag the database
>>> file once and you're done. Transactional MySQL uses huge data
>>> files, probably preallocated. It should simply work with
>>> nodatacow.
>> The thing is, I don't have enough knowledge of how defrag is
>> implemented in BTRFS to say for certain that ti doesn't use COW
>> semantics somewhere (and I would actually expect it to do so, since
>> that in theory makes many things _much_ easier to handle), and if it
>> uses COW somewhere, then it by definition doesn't work on NOCOW files.
>
> A dev would be needed on this. But from a non-dev point of view, the
> defrag operation itself is CoW: Blocks are rewritten to another
> location in contiguous order. Only metadata CoW should be needed for
> this operation.
>
> It should be nothing else than writing to a nodatacow snapshot... Just
> that the snapshot is more or less implicit and temporary.
>
> Hmm? *curious*
>
The gimmicky part though is that the file has to remain accessible 
throughout the entire operation, and the defrad can't lose changes that 
occur while the file is being defragmented.  In many filesystems (NTFS 
on Windows for example), a defrag functions similarly to a pvmove 
operation in LVM, as each extent gets moved, writes to that region get 
indirected to the new location and treat the areas that were written to 
as having been moved already.  The thing is, on BTRFS that would result 
in extents getting split, which means COW is probably involved at some 
level in the data path too.
