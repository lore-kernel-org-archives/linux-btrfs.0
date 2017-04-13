Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36730 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753074AbdDMLkW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Apr 2017 07:40:22 -0400
Received: by mail-io0-f172.google.com with SMTP id l7so74725915ioe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Apr 2017 04:40:22 -0700 (PDT)
Subject: Re: Deduplication tools
To: Marat Khalili <mkh@rqc.ru>, linux-btrfs@vger.kernel.org
References: <37e02202-b9a9-3953-7bc8-92c4d1fd485f@rqc.ru>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8f0fd545-a2f0-f966-67c4-436e2870baa9@gmail.com>
Date: Thu, 13 Apr 2017 07:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <37e02202-b9a9-3953-7bc8-92c4d1fd485f@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-13 07:06, Marat Khalili wrote:
> After reading this maillist for a while I became a bit more cautious
> about using various BTRFS features, so decided to ask just in case: is
> it safe to use out-of-band deduplication tools
> <https://btrfs.wiki.kernel.org/index.php/Deduplication>, and which of
> them are considered more stable/mainstream? Also, won't running these
> tools exacerbate often mentioned stability/performance problems with
> too-many-snapshots? Any first-hand experience is very welcome.
As a general rule, as long as you're careful, you generally shouldn't 
have many issues.  duperemove is the tool I would suggest for just 
generic deduplication on BTRFS, as I know the developer is still active 
and generally does a good job of getting bugs fixed.  It may well make 
performance problems with large numbers of snapshots worse, but probably 
not by as much as you think (unless you have huge amounts of duplicate 
data).  Keep in mind also that batch deduplication can take a very long 
time to do.

As a general rule though, if you're storing data that's consistently 
structured and organized, you may want to consider doing a custom tool 
to make the process more efficient.  Any generic deduplication tool is 
generally going to be pretty slow on large amounts of data, but 
depending on what the data is and how it's organized, it may be possible 
to determine duplicate data more efficiently than the block hashing 
method used by most deduplication tools.

