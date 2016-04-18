Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33841 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbcDRMOx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 08:14:53 -0400
Received: by mail-io0-f194.google.com with SMTP id z133so22947812iod.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 05:14:52 -0700 (PDT)
Subject: Re: btrfrs send ... | ... receive ... stores files sparsely?
To: Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAD=QJKjqh_yyfwGdjbBFp-UF0-szpr3xKGV2Bfvnbzc7kVgndA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5714CF85.6020201@gmail.com>
Date: Mon, 18 Apr 2016 08:13:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjqh_yyfwGdjbBFp-UF0-szpr3xKGV2Bfvnbzc7kVgndA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-15 18:04, Nicholas D Steeves wrote:
> Hi,
>
> I happened to notice this when checking free space of my backup and
> primary system.  I'll use an example of a file that won't have any
> private or confidential information.  For du -hc
> ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache; ls -alh
> ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache; sha512sum
> ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
>
> On the sending system:
> 11M     ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
> 11M     total
> -rw-r--r-- 1 kdm nogroup 11M Apr  2 18:00
> ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
> 0ba53df610f35ef5170fe33fda4304456f4df2e9944447fa06467f8f6cfc89adc7da1698a1882929df56ce6be0e0846380cccfa411b4c7857f10a5c23d7797cb
>   ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
>
> On the receiving system:
> 64K     ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
> 64K     total
> -rw-r--r-- 1 114 nogroup 11M Apr  2 18:00
> ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
> 0ba53df610f35ef5170fe33fda4304456f4df2e9944447fa06467f8f6cfc89adc7da1698a1882929df56ce6be0e0846380cccfa411b4c7857f10a5c23d7797cb
>   ./var/tmp/kdecache-kdmtjNM8H/icon-cache.kcache
>
> The only thing I can think of is that something in btrfs send ... |
> ... receive ... is converting to sparse storage.  Is this intentional?
>   I suppose with a COW filesystem preallocating empty space to prevent
> fragmentation doesn't work, because as soon as that
> cache/database/whatever_file changes the filesystem COWs the changes
> to a location that will almost certainly require a seek...  That said,
> will the way btrfs-progs is doing it cause similar issues with
> converting to sparse storage that I've observed with tar and rsync?
That does appear to be the case, which is slightly surprising to me, as 
I would have expected it to replicate the extent layout also (or at 
least, replicate what parts of the file were allocated and which were 
unwritten extents).

As far as 'similar issues with converting to sparse storage', I'm not 
entirely sure what you might mean, so I can't really say if it will or 
won't cause issues.

