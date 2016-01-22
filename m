Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35573 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbcAVMPg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 07:15:36 -0500
Received: by mail-io0-f173.google.com with SMTP id 77so85893939ioc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jan 2016 04:15:36 -0800 (PST)
Subject: Re: Interjection: autodefrag mount option aye, nae?
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
 <5697D0E9.3080007@gmail.com> <20160114192647.GB24567@localhost.localdomain>
 <5697F9E7.1020004@gmail.com> <loom.20160120T163054-326@post.gmane.org>
 <569FAA4E.1040204@gmail.com>
 <20160121215932.3e6654af@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A21D41.3020004@gmail.com>
Date: Fri, 22 Jan 2016 07:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <20160121215932.3e6654af@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-21 15:59, Kai Krakow wrote:
> Am Wed, 20 Jan 2016 10:39:58 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>> On 2016-01-20 10:33, Al wrote:
>>> [very quietly] I've had autodefrag out of my mount options for a
>>> long while now. Is that still the recommended position?
>> I think it really depends on what you're doing.  In my case, I
>> usually have it on, and the only issue I've ever seen is that Chrome
>> sometimes loads pages from local cache slower than it should be.  I
>> also don't use ridiculous numbers of snapshots either (I use them
>> only to get a stable view of the filesystem when generating a
>> backup), so I don't have much experience with how they interact with
>> autodefrag.
>
> I'd recommend to set chrome caching to simple http cache in
> chrome://flags as this is more suitable for btrfs (as for most Unix
> file systems which deal with many small files better than with random
> updates in a big fat files).
>
> I experienced much improved performance and responsiveness with it. May
> be worth a try for you. I'd be interested in your results.
>
> chrome://flags/#enable-simple-cache-backend
>
Thanks for the suggestion, it does in fact appear to improve things on 
BTRFS.
