Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:36280 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbcILQ4J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 12:56:09 -0400
Received: by mail-yw0-f177.google.com with SMTP id u124so76399850ywg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 09:56:08 -0700 (PDT)
Subject: Re: Is stability a joke? (wiki updated)
To: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz> <20160912162747.GF16983@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8df2691f-94c1-61de-881f-075682d4a28d@gmail.com>
Date: Mon, 12 Sep 2016 12:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <20160912162747.GF16983@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 12:27, David Sterba wrote:
> On Mon, Sep 12, 2016 at 04:27:14PM +0200, David Sterba wrote:
>>> I therefore would like to propose that some sort of feature / stability
>>> matrix for the latest kernel is added to the wiki preferably somewhere
>>> where it is easy to find. It would be nice to archive old matrix'es as
>>> well in case someone runs on a bit older kernel (we who use Debian tend
>>> to like older kernels). In my opinion it would make things bit easier
>>> and perhaps a bit less scary too. Remember if you get bitten badly once
>>> you tend to stay away from from it all just in case, if you on the other
>>> hand know what bites you can safely pet the fluffy end instead :)
>>
>> Somebody has put that table on the wiki, so it's a good starting point.
>> I'm not sure we can fit everything into one table, some combinations do
>> not bring new information and we'd need n-dimensional matrix to get the
>> whole picture.
>
> https://btrfs.wiki.kernel.org/index.php/Status

Some things to potentially add based on my own experience:

Things listed as TBD status:
1. Seeding: Seems to work fine the couple of times I've tested it, 
however I've only done very light testing, and the whole feature is 
pretty much undocumented.
2. Device Replace: Works perfectly as long as the filesystem itself is 
not corrupted, all the component devices are working, and the FS isn't 
using any raid56 profiles.  Works fine if only the device being replaced 
is failing.  I've not done much testing WRT replacement when multiple 
devices are suspect, but what I've done seems to suggest that it might 
be possible to make it work, but it doesn't currently.  On raid56 it 
sometimes works fine, sometimes corrupts data, and sometimes takes an 
insanely long time to complete (putting data at risk from subsequent 
failures while the replace is running).
3. Balance: Works perfectly as long as the filesystem is not corrupted 
and nothing throws any read or write errors.  IOW, only run this on a 
generally healthy filesystem.  Similar caveats to those for replace with 
raid56 apply here too.
4. File Range Cloning and Out-of-band Dedupe: Similarly, work fine if 
the FS is healthy.

Other stuff:
1. Compression: The specific known issue is that compressed extents 
don't always get recovered properly on failed reads when dealing with 
lots of failed reads.  This can be demonstrated by generating a large 
raid1 filesystem image with huge numbers of small (1MB) readliy 
compressible files, then putting that on top of a dm-flaky or dm-error 
target set to give a high read-error rate, then mounting and running cat 
`find .` > /dev/null from the top level of the FS multiple times in a row.
2. Send: The particular edge case appears to be caused by metadata 
corruption on the sender and results in send choking on the same file 
every time you try to run it.  The quick fix is to copy the contents of 
the file to another file and rename that over the original.
