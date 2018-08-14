Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f45.google.com ([209.85.208.45]:42194 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732943AbeHNT54 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Aug 2018 15:57:56 -0400
Received: by mail-ed1-f45.google.com with SMTP id r4-v6so10478794edp.9
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2018 10:09:54 -0700 (PDT)
Subject: Re: trouble mounting btrfs filesystem....
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Dmitrii Tcvetkov <demfloro@demfloro.ru>,
        "Scott E. Blomquist" <sb@techsquare.com>
Cc: linux-btrfs@vger.kernel.org
References: <23408.34902.778845.675960@techsquare.com>
 <23410.52600.89620.15949@techsquare.com>
 <20180814160046.581c1de2@job.localdomain>
 <2ded4b73-8eb5-39e8-cd56-0f205839268d@mendix.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <6fd74846-0796-e836-0651-6fe5a1e72b87@gmail.com>
Date: Tue, 14 Aug 2018 20:09:51 +0300
MIME-Version: 1.0
In-Reply-To: <2ded4b73-8eb5-39e8-cd56-0f205839268d@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

14.08.2018 18:16, Hans van Kranenburg пишет:
> On 08/14/2018 03:00 PM, Dmitrii Tcvetkov wrote:
>>> Scott E. Blomquist writes:
>>>  > Hi All,
>>>  > 
>>>  > [...]
>>
>> I'm not a dev, just user.
>> btrfs-zero-log is for very specific case[1], not for transid errors.
>> Transid errors mean that some metadata writes are missing, if
>> they prevent you from mounting filesystem it's pretty much fatal. If
>> btrfs could recover metadata from good copy it'd have done that.
>>
>> "wanted 2159304 found 2159295" means that some metadata is stale by 
>> 9 commits. You could try to mount it with "ro,usebackuproot" mount
>> options as readonly mount is less strict. If that works you can try
>> "usebackuproot" without ro option. But 9 commits is probably too much
>> and there isn't enough data to rollback so far.
> 
> Keep in mind that a successful mount with usebackuproot does not mean
> you're looking at a consistent filesystem. After each transaction
> commit, disk space that is no longer referenced is immediately freed for
> reuse.
> 

With all respect - in this case btrfs should not even pretend it can do
"usebackuproot". What this option is for then?

> So, even if you can mount with usebackuproot, you have to hope that none
> of the metadata blocks that were used back then have been overwritten
> already, even the ones in distant corners of trees. A full check / scrub
> / etc would be needed to find out.
> 
