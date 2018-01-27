Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49175 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752108AbeA0RoJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 12:44:09 -0500
Subject: Re: [PATCH 11/26] libbtrfsutil: add btrfs_util_create_snapshot()
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
 <4c742933-cc46-d93f-da34-5914296f2c8a@libero.it>
 <20180126194633.GA19033@vader.DHCP.thefacebook.com>
 <06676a54-ee0c-45b9-007c-5747cdc02aa4@gmx.com> <20180127054520.GA20914@vader>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ed764385-5c93-e20d-d832-283a056551b5@suse.com>
Date: Sat, 27 Jan 2018 18:31:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180127054520.GA20914@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.01.2018 07:45, Omar Sandoval wrote:
> On Sat, Jan 27, 2018 at 01:00:58PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年01月27日 03:46, Omar Sandoval wrote:
>>> On Fri, Jan 26, 2018 at 08:31:06PM +0100, Goffredo Baroncelli wrote:
>>>> On 01/26/2018 07:40 PM, Omar Sandoval wrote:
>>>>> From: Omar Sandoval <osandov@fb.com>
>>>>
>>>>
>>>> Hi,
>>>>
>>>> this is a great work; only few comments:
>>>> 1) I found not intuitive the naming of the function: i.e. you have 
>>>>
>>>> btrfs_util_create_snapshot()
>>>> btrfs_util_f_create_snapshot()
>>>>
>>>> To me it seems more clear to have
>>>>
>>>> btrfs_util_create_snapshot()
>>>> btrfs_util_create_snapshot_f()
>>>>
>>>> I think that it is better move the 'f' at the end: at the begin you have the library "btrfs_util", in the middle you have the library function 'create_snapshot', at the end there is the function variant ('f', because it uses a file descriptor).
>>>>
>>>> This is my opinion, even tough there are both examples like you (stat/fstat/lstat) and like my one (capt_get_fd/cap_get_file)...
>>>
>>> Yup, I was going off of the fstat/fsync/etc. convention. I don't
>>> particularly like, e.g., btrfs_create_snapshot_f(), but
>>> btrfs_create_snapshot_fd() isn't so bad.
>>
>> _fd() suffix sounds more reasonable to me too.
>>
>>>
>>>> 2) I find the prefix 'btrfs_util_' a bit verbose. Why not a simple 'btrfs_', even at the cost of a possible renaming of the conflicting function in the current btrfs code.
>>>
>>> That's a reasonable idea, I mostly wanted to avoid naming conflicts but
>>> if this is the "one true Btrfs library" it shouldn't be a concern.
>>
>> Unfortunately, at least there is also some planned work to bring a
>> shared code base between kernel and btrfs-progs, which is also named
>> libbtrfs, inspired by libxfs.

So why don't we implement the shared code as part of this library, won't
it result in just some more files + btrfs_* named function? This "core"
part will be built always when compiling the kernel/userspace progs. In
case we are compiling the userspace progs, additionally we can compile
in the libbtrfsutil essentially + the python modules? Why do we need to
keep the 2 libraries completely separate? For example we can have
something like:

libbtrfs/common/ - here lives the common Userspace/kernel code
libbtrfs/userspace/ - here lives the code of libbtrfsutil, which will
presumably consume certain function from the common dir?

> 
> That's right, I forgot about that. There's definitely value in having a
> distinction between btrfs_util_ (userspace interfaces) and btrfs_
> (filesystem disk format).
> 
>> And depending on the respect of view, some developer may prefer the
>> short btrfs_ prefix for libbtrfs, while other developers/users will
>> definitely prefer btrfs_ prefix for libbtrfsutil.
>>
>> What about shorted prefix like butil_ or btrutil_?
> 
> Those aren't very informative, I think sticking with btrfs_util_ is
> fine, it's not that bad to type out.
> 
>> Thanks,
>> Qu
>>
>>>
>>> I'll wait a bit for people to bikeshed on the naming before I go and
>>> rename everything, but I'm leaning towards the shorter name and
>>> appending _fd instead of prepending f_.
>>>
>>>> 3) regarding the btrfs_util_create_snapshot() function, I think that it would be useful to add some more information:
>>>> a) if used recursive is NOT atomic
>>>> b) if used recursive, root capabilities are needed
>>>>
>>>> The same for the other functions: mark with a 'root required' tag all the functions which require the root capabilities.
>>>
>>> That's a great point, I'll document that.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
