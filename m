Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47857 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3Vjl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 17:39:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so457127pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 14:39:41 -0700 (PDT)
Message-ID: <5090491A.4020306@gmail.com>
Date: Wed, 31 Oct 2012 05:39:38 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: Felix Pepinghege <postfach@pepinghege.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net>
In-Reply-To: <508FC26A.1010206@pepinghege.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/30/2012 08:04 PM, Felix Pepinghege wrote:
> Hi ching!
>
> Am 30.10.2012 12:04, schrieb ching:
>> Hi all,
>>
>> I am testing my btrfs root partition with "max_inline=0", and 64k leaf size for weeks and it seems that it is fine.
>>
>>
>> AFAIK btrfs inline small files into metadata by default, I am curious why?
>>
>> If there is only a few small files, then there will be neither effect nor benefit at all
>
> I disagree in this point. There will be a (probably huge) benefit in terms of performance. If the file data is inlined, you have a good chance (especially with large leaf sizes, although even then it is not guaranteed) that the data is in the same leaf as the inode element. So you already have the file data as you always access complete leafs. If you would store the data in extents, you would need to read the respective extent, which can be anywhere on the disk. That is, you most likely need to move the head. This brings overhead (especially with small files, as the reading process is relatively fast compared to the time you need to position the head).

You may be correct.

But I doubt inline data may bring possible performance benefit, bigger metadata always means more trouble for concurrency/performance and cache miss ratio

>
>> If there is a lot of small files, then the size of metadata will be undesirable due to deduplication
>
> Yes, that is a fact, but if that really matters depends on the use-case (e.g., the small files to large files ratio, ...). But as btrfs is designed explicitly as a general purpose file system, you usually want the good performance instead of the better disk-usage (especially as disk space isn't expensive anymore).

Yes, but as a general purpose filesystem, i guess that the default behaviour should be "safe"?

Not many user is patient enough to troubleshoot metadata "explosion".
