Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:39484 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdHCECZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 00:02:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dd7Kx-0004rC-2t
        for linux-btrfs@vger.kernel.org; Thu, 03 Aug 2017 06:02:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Date: Thu, 3 Aug 2017 04:02:01 +0000 (UTC)
Message-ID: <pan$14041$94860338$dca2bb98$ddde8163@cox.net>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
        <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
        <20170801172411.GE26357@localhost.localdomain>
        <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
        <20170802175738.GA12533@localhost.localdomain>
        <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
        <20170802202720.GB12533@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo posted on Wed, 02 Aug 2017 14:27:21 -0600 as excerpted:

>> >> It is correct reading this as: all data is written two times ?

If as is being discussed the log is mirrored by default that'd be three 
times...

Parity-raid is slow and of course normally has the infamous write hole 
this patch set is trying to close.  Yes, closing the write hole is 
possible, but for sure it's going to make the performance bite of parity-
raid even worse. =:^(

>> >> Or are logged only the stripes involved by a RMW cycle (i.e. if a
>> >> stripe is fully written, the log is bypassed )?
>> > 
>> > For data, only data in bios from high level will be logged, while for
>> > parity, the whole parity will be logged.
>> > 
>> > Full stripe write still logs all data and parity, as full stripe
>> > write may not survive from unclean shutdown.
>> 
>> Does this matter ? Due to the COW nature of BTRFS if a transaction is
>> interrupted (by an unclean shutdown) the transaction data are all lost.
>> Am I missing something ?
>> 
>> What I want to understand, is if it is possible to log only the
>> "partial stripe"  RMW cycle.
>>
>>
> I think your point is valid if all data is written with datacow.  In
> case of nodatacow, btrfs does overwrite in place, so a full stripe write
> may pollute on-disk data after unclean shutdown.  Checksum can detect
> errors but repair thru raid5 may not recover the correct data.

But nodatacow doesn't have checksum...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

