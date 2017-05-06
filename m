Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34884 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdEFPbm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 May 2017 11:31:42 -0400
Received: by mail-ua0-f193.google.com with SMTP id e28so2998897uah.2
        for <linux-btrfs@vger.kernel.org>; Sat, 06 May 2017 08:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a1fc8d12-e9c3-45ec-a70c-a6732750d4ca@cn.fujitsu.com>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
 <20170417032642.30770-10-quwenruo@cn.fujitsu.com> <CAKuJGC8vX53NExNAYj-de9vta_y5rdv3fC2z9-fP=rPatv-OOg@mail.gmail.com>
 <33ef367f-85a5-8418-d57e-b38b22214487@cn.fujitsu.com> <CAKuJGC9tcGh49XGv+tU729Y0BNnnMEwDk7axGQv6RAV0ZbFCGQ@mail.gmail.com>
 <9e8c3a66-f43a-bce8-36b1-5f358c6cab4a@cn.fujitsu.com> <CAKuJGC9Lcc+0hw7CQCMC2QhEUH1hm1doOxNsPv8Z-sqR4oErkQ@mail.gmail.com>
 <20170504165327.GA10575@twin.jikos.cz> <a1fc8d12-e9c3-45ec-a70c-a6732750d4ca@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sat, 6 May 2017 21:01:40 +0530
Message-ID: <CAKuJGC9Ycw-YW+6aKB_kj=O4XtP=zHJ3YgF-uXkXJd+eppruEQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] btrfs-progs: modify: Introduce option to specify the
 pattern to fill mirror
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

okay, but I'm not sure whether it can be useful here other than the
sample cli usage. The reason, this tool relies heavily on Python/C
layer[1]. The framework works like this:

C-api(fs-progs) <--> Python/C api <--> Python program.

C-api is typical fs library (like libext2fs/libbtrfs) and C/Python
used  to export every on-disk fs structure as an python-object along
with few fs-library functions. Finally in python script we can perform
stuffs like:

--
import fslib as fs

disk_object=fs.get_inode("/file/path")
#set few values finally make a call
retval = fs.corrupt_object(disk_object, offset, size, optype, fixcrc)
---

at C-python layer above python-object converted into C appropriate
data-type and passed on to C-layer.

hard-part will be troubleshooting issues, tracking them is difficult
because both gdb and pdb can help only upto certain point.

[1]: https://docs.python.org/2/extending/extending.html

Cheers.
Lakshmipathi.G


On 5/5/17, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 05/05/2017 12:53 AM, David Sterba wrote:
>> On Sun, Apr 23, 2017 at 01:12:42PM +0530, Lakshmipathi.G wrote:
>>> Thanks for the example and details. I understood some and need to
>>> re-read couple of more times to understand the remaining.
>>>
>>> btw, I created a corruption framework(with previous org), the sample
>>> usage and example is below. It looks similar to Btrfs corruption tool.
>>> thanks.
>>>
>>> --
>>> corrupt.py --help
>> [...]
>>
>> Interesting, can you please share the script? This is another
>> alternative that seems more plausible for rapid prototyping of various
>> corruption scenarios. The C utility (either existing btrfs-corrupt-block
>> or the proposed btrfs-modify) can become tedious to change, but can be
>> compiled and distributed without the python dependency.
>>
>> I wanted to use something python-based for tests when Hans announced the
>> python-btrfs project, but it has broader goals than just the testsuite
>> needs.  So we could have our own corrupt.py, just for our internal use.
>>
>> I'm not sure if a compiled tool like btrfs-modify is really needed, but
>> why we can't have both.
>>
>>
> Python based tool is always a good idea.
>
> If python based lib can provide the same capability of current C
> facilities (btrfs_search_slot() at least) and have better encapsulation,
> I'm totally committed to python based one.
>
> Although I'm a little afraid that the python script is not using the low
> level btrfs_search_slot(), but just getting chunk layout then do
> mathematics to get stripe location.
>
> Thanks,
> Qu
>
>
>
