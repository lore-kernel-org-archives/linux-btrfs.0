Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:27755
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732521AbeHOCBA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 22:01:00 -0400
Subject: Re: trouble mounting btrfs filesystem....
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        "Scott E. Blomquist" <sb@techsquare.com>
Cc: linux-btrfs@vger.kernel.org
References: <23408.34902.778845.675960@techsquare.com>
 <23410.52600.89620.15949@techsquare.com>
 <20180814160046.581c1de2@job.localdomain>
 <2ded4b73-8eb5-39e8-cd56-0f205839268d@mendix.com>
 <6fd74846-0796-e836-0651-6fe5a1e72b87@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <648a229d-94da-760a-ee04-0fd528f16a40@mendix.com>
Date: Wed, 15 Aug 2018 01:11:29 +0200
MIME-Version: 1.0
In-Reply-To: <6fd74846-0796-e836-0651-6fe5a1e72b87@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/14/2018 07:09 PM, Andrei Borzenkov wrote:
> 14.08.2018 18:16, Hans van Kranenburg пишет:
>> On 08/14/2018 03:00 PM, Dmitrii Tcvetkov wrote:
>>>> Scott E. Blomquist writes:
>>>>  > Hi All,
>>>>  > 
>>>>  > [...]
>>>
>>> I'm not a dev, just user.
>>> btrfs-zero-log is for very specific case[1], not for transid errors.
>>> Transid errors mean that some metadata writes are missing, if
>>> they prevent you from mounting filesystem it's pretty much fatal. If
>>> btrfs could recover metadata from good copy it'd have done that.
>>>
>>> "wanted 2159304 found 2159295" means that some metadata is stale by 
>>> 9 commits. You could try to mount it with "ro,usebackuproot" mount
>>> options as readonly mount is less strict. If that works you can try
>>> "usebackuproot" without ro option. But 9 commits is probably too much
>>> and there isn't enough data to rollback so far.
>>
>> Keep in mind that a successful mount with usebackuproot does not mean
>> you're looking at a consistent filesystem. After each transaction
>> commit, disk space that is no longer referenced is immediately freed for
>> reuse.
>>
> 
> With all respect - in this case btrfs should not even pretend it can do
> "usebackuproot". What this option is for then?

I have no idea. As the Dutch say: "schiet mij maar in de kerstboom". The
commit that introduces it contains no explanation at all.

The only thing I can think of is when you're a developer and writing
buggy code that writes out corrupted tree root blocks, which makes the
filesystem crash in some way directly after a transaction ends while no
other new writes are done again yet, combined with getting fed up of
having to mkfs and put your testdata back all the time.

>> So, even if you can mount with usebackuproot, you have to hope that none
>> of the metadata blocks that were used back then have been overwritten
>> already, even the ones in distant corners of trees. A full check / scrub
>> / etc would be needed to find out.

-- 
Hans van Kranenburg
