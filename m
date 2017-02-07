Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:36677 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdBGU16 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:27:58 -0500
Received: by mail-it0-f54.google.com with SMTP id c7so85602581itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 12:27:39 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q89sm10081242ioi.42.2017.02.07.12.27.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2017 12:27:37 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij3LJeFR1pz9QDOkMEVbh1cws5Rv2KPep3ghVAimJy7aLA@mail.gmail.com>
 <91c8a758-23b6-edf1-74b0-2d87acbb2560@gmail.com>
 <20170207211941.3310d7a8@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6d7eac16-773e-bf6c-a6be-d3950f9b2325@gmail.com>
Date: Tue, 7 Feb 2017 15:27:34 -0500
MIME-Version: 1.0
In-Reply-To: <20170207211941.3310d7a8@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 15:19, Kai Krakow wrote:
> Am Tue, 7 Feb 2017 14:50:04 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>>> Also does autodefrag works with nodatacow (ie with snapshot)  or
>>> are these exclusive ?
>> I'm not sure about this one.  I would assume based on the fact that
>> many other things don't work with nodatacow and that regular defrag
>> doesn't work on files which are currently mapped as executable code
>> that it does not, but I could be completely wrong about this too.
>
> Technically, there's nothing that prevents autodefrag to work for
> nodatacow files. The question is: is it really necessary? Standard file
> systems also have no autodefrag, it's not an issue there because they
> are essentially nodatacow. Simply defrag the database file once and
> you're done. Transactional MySQL uses huge data files, probably
> preallocated. It should simply work with nodatacow.
The thing is, I don't have enough knowledge of how defrag is implemented 
in BTRFS to say for certain that ti doesn't use COW semantics somewhere 
(and I would actually expect it to do so, since that in theory makes 
many things _much_ easier to handle), and if it uses COW somewhere, then 
it by definition doesn't work on NOCOW files.
>
> On the other hand: Using snapshots clearly introduces fragmentation over
> time. If autodefrag kicks in (given, it is supported for nodatacow), it
> will slowly unshare all data over time. This somehow defeats the
> purpose of having snapshots in the first place for this scenario.
>
> In conclusion, I'd recommend to run some maintenance scripts from time
> to time, one to re-share identical blocks, and one to defragment the
> current workspace.
>
> The bees daemon comes into mind here... I haven't tried it but it
> sounds like it could fill a gap here:
>
> https://github.com/Zygo/bees
>
> Another option comes into mind: XFS now supports shared-extents
> copies. You could simply do a cold copy of the database with this
> feature resulting in the same effect as a snapshot, without seeing the
> other performance problems of btrfs. Tho, the fragmentation issue would
> remain, and I think there's no dedupe application for XFS yet.
There isn't, but cp --reflink=auto with a reasonably recent version of 
coreutils should be able to reflink the file properly.

