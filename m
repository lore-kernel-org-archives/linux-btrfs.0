Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49992 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932404AbbKMDXX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 22:23:23 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
 <5645474D.8000804@cn.fujitsu.com> <1447381613.7045.21.camel@scientia.net>
 <56455073.1060406@cn.fujitsu.com> <1447383793.7045.27.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564557A7.4030505@cn.fujitsu.com>
Date: Fri, 13 Nov 2015 11:23:19 +0800
MIME-Version: 1.0
In-Reply-To: <1447383793.7045.27.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/13 04:03 +0100:
> On Fri, 2015-11-13 at 10:52 +0800, Qu Wenruo wrote:
>> You can provide the output of "btrfs-debug-tree -t 2 <dev>" to help
>> further debug.
>> It would be quite big, so it's better to zip it.
> That would contain all the filenames, right? Hmm that could be
> problematic because of privacy issues...

No, "-t 2" means only dump extent tree, no privacy issues at all.
Since only numeric inode/snapshot number and offset inside file.
Or I'll give you a warning on privacy.

No file name at all, just try it yourself.
>
>
>> Although it may not help a lot, but at least I can tell you which
>> file
>> extents are affected. (By the hard way, I can only tell you which
>> inode
>> in which subvolume is affected, all in numeric form)
>>
>> And I could get enough info to determine what's the wrong type.
>> (data extent in metadata chunk or vice verse, or even system chunk is
>> involved)
> sigh... I mean... how can that happen, if nothing of the more recent
> things is used... I'd have guess others would have noted such a bug
> before.

It may happened in older kernels, just recent btrfsck can detect the 
problem.

>
>
>>> And is there any way to tell more certain, whether the balance
>>> would
>>> help or whether I'd just get more possibly even hidden corruptions?
>>> I
>>> mean right... well it would be painful to recover from the most
>>> recent
>>> backup, but not extremely painful.
>>
>> When extent and chunk type get wrong, only god knows what will
>> happen...
>> So no useful help here.
> If btrfs check already notices the mismatch, shouldn't it then be
> possible to set the correct type?

Not possible yet.
Since there is not relocation facility in btrfs-progs to do the fix.

>
>
>> If the type mismatch errors are the only error output from fsck, then
>> scrub should not help or report anything useful.
> I see...
>
>
>> And at last, what's the kernel and btrfs-progs version?
> kernel 4.2.6
> btrfsprogs 4.3
>
New enough, that's the only good news yet...

Thanks,
Qu
