Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34859 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756512AbcILRbr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 13:31:47 -0400
Received: by mail-oi0-f48.google.com with SMTP id d191so108797243oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 10:31:47 -0700 (PDT)
Subject: Re: Is stability a joke?
To: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
Date: Mon, 12 Sep 2016 13:31:42 -0400
MIME-Version: 1.0
In-Reply-To: <20160912165107.GG16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 12:51, David Sterba wrote:
> On Mon, Sep 12, 2016 at 10:54:40AM -0400, Austin S. Hemmelgarn wrote:
>>> Somebody has put that table on the wiki, so it's a good starting point.
>>> I'm not sure we can fit everything into one table, some combinations do
>>> not bring new information and we'd need n-dimensional matrix to get the
>>> whole picture.
>> Agreed, especially because some things are only bad in specific
>> circumstances (For example, snapshots generally work fine on almost
>> anything, until you get into the range of more than about 250, then they
>> start causing issues).
>
> The performance aspect could be hard to estimate. Each feature has some
> cost, we can document what's expected hit but various combinations and
> actual runtime performance is unpredictable. I'd rather let the tools do
> what the user asks for, as we might not be able to even detect there are
> some bad external factors. I think that 250 snapshots would perform
> better on an ssd than a rotational disk. In the end this leads to the
> "dos & don'ts".
>
In general yes in this case, but performance starts to degrade 
exponentially beyond a certain point.  The difference between (for 
example) 10 and 20 snapshots is not as much as between 1000 and 1010. 
The problem here is that we don't really have a BCP document that anyone 
ever reads.  A lot of stuff that may seem obvious to us after years of 
working with BTRFS isn't going to be to a newcomer, and it's a lot more 
likely that some random person will get things write if we have a good, 
central BCP document than if it stays as scattered tribal knowledge.
