Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:49705 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2IJNKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 09:10:20 -0400
Message-ID: <504DE6B3.2010900@oracle.com>
Date: Mon, 10 Sep 2012 21:10:11 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: ching <lsching17@gmail.com>
CC: "Fajar A. Nugraha" <list@fajar.net>, linux-btrfs@vger.kernel.org
Subject: Re: enquiry about defrag
References: <504BDCE0.8020407@gmail.com> <CAMQ-g0d3iF-0RCGWd3RD_buXXa3j3DS2PwyUgXSAJ95=-F=c+Q@mail.gmail.com> <504C49F7.2070201@gmail.com> <CAG1y0sdFTKLX8N1VnSYzxZ-Xr4kDPtYGG6ixMrPwBWQPRVAGgg@mail.gmail.com> <504C861D.2020009@gmail.com> <504DDAD5.8010908@gmail.com>
In-Reply-To: <504DDAD5.8010908@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/2012 08:19 PM, ching wrote:
> On 09/09/2012 08:05 PM, ching wrote:
>> On 09/09/2012 05:11 PM, Fajar A. Nugraha wrote:
>>> On Sun, Sep 9, 2012 at 2:49 PM, ching <lsching17@gmail.com> wrote:
>>>> On 09/09/2012 08:30 AM, Jan Steffens wrote:
>>>>> On Sun, Sep 9, 2012 at 2:03 AM, ching <lsching17@gmail.com> wrote:
>>>>>> 2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.
>>>>> Use the "filefrag" command, part of e2fsprogs.
>>>>>
>>>> my image is a 16G sparse file, after defragment, it still has 101387 extents, is it normal?
>>> Is compression enabled? If so, yes, it's normal.
>>>
>> compression with lzo.
>>
>> thanks. i will retry with compression disabled when 3.6 is stable.
> 
> i just realize that it is possible to control compression per file by file attribute
> 
> http://radudi.com/index.php/2011/08/31/using-btrfs-per-file-and-per-directory-compression/
> 
> when i try to follow example above, no file attribute is shown (my mount option is rw,noatime,compress-force=lzo,space_cache,inode_cache)
> 
> $lsattr -V Linux.raw_image
> lsattr 1.42.5 (29-Jul-2012)
> ---------------- Linux.raw_image
> 
> is there any official resource/web page for control compression per file by file attribute?
> 

FYI, git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

