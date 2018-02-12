Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36515 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbeBLSHM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 13:07:12 -0500
Received: by mail-io0-f178.google.com with SMTP id l17so18261710ioc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 10:07:12 -0800 (PST)
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <20180210220549.GA30438@polanet.pl>
 <6abc187c-b5fe-a776-6b89-ca5b6c7ee790@panasas.com>
 <20c617b6-7179-a67a-3997-8fee766088a5@mendix.com>
 <c7e267a4-d47d-9713-c222-81dcb441e009@panasas.com>
 <57d8d368-9c96-db65-14a6-2af39cc509f9@gmail.com>
 <41d6badc-90d4-54f9-085e-fd75afde74eb@panasas.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <300f0068-d83a-5eeb-e0e0-039badcea6f4@gmail.com>
Date: Mon, 12 Feb 2018 13:07:07 -0500
MIME-Version: 1.0
In-Reply-To: <41d6badc-90d4-54f9-085e-fd75afde74eb@panasas.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-12 11:39, Ellis H. Wilson III wrote:
> On 02/12/2018 11:02 AM, Austin S. Hemmelgarn wrote:
>> BTRFS in general works fine at that scale, dependent of course on the 
>> level of concurrent access you need to support.  Each tree update 
>> needs to lock a bunch of things in the tree itself, and having large 
>> numbers of clients writing to the same set of files concurrently can 
>> cause lock contention issues because of this, especially if all of 
>> them are calling fsync() or fdatasync() regularly.  These issues can 
>> be mitigated by segregating workloads into their own subvolumes (each 
>> subvolume is a mostly independent filesystem tree), but it sounds like 
>> you're already doing that, so I don't think that would be an issue for 
>> you.
> Hmm...I'll think harder about this.  There is potential for us to 
> artificially divide access to files across subvolumes automatically 
> because of the way we are using BTRFS as a backing store for our 
> parallel file system.  So far even with around 1000 threads across about 
> 10 machines accessing BTRFS via our parallel filesystem over the wire 
> we've not seen issues, but if we do I have some ways out I've not 
> explored yet.  Thanks!
For what it's worth, most of the issues I've personally seen with 
parallel performance involved very heavy use of fsync(), or lots of 
parallel calls to stat() and statvfs() happening while files are also 
being written to, so it may just be the way you happen to be doing 
things just doesn't cause issues.

