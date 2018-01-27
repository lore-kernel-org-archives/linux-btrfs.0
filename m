Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:57515 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752932AbeA0O1T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Jan 2018 09:27:19 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 11/26] libbtrfsutil: add btrfs_util_create_snapshot()
To: Omar Sandoval <osandov@osandov.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <cover.1516991902.git.osandov@fb.com>
 <ffe3cf7d259065bbce8e54b7a5bae5528faca3d0.1516991902.git.osandov@fb.com>
 <4c742933-cc46-d93f-da34-5914296f2c8a@libero.it>
 <20180126194633.GA19033@vader.DHCP.thefacebook.com>
 <06676a54-ee0c-45b9-007c-5747cdc02aa4@gmx.com> <20180127054520.GA20914@vader>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <31ab979c-37e7-0d35-e640-c4b0853c3d29@inwind.it>
Date: Sat, 27 Jan 2018 15:19:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180127054520.GA20914@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/27/2018 06:45 AM, Omar Sandoval wrote:
> On Sat, Jan 27, 2018 at 01:00:58PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2018年01月27日 03:46, Omar Sandoval wrote:
>>> On Fri, Jan 26, 2018 at 08:31:06PM +0100, Goffredo Baroncelli wrote:
>>>> On 01/26/2018 07:40 PM, Omar Sandoval wrote:
>>>>> From: Omar Sandoval <osandov@fb.com>
[...]
>> Unfortunately, at least there is also some planned work to bring a
>> shared code base between kernel and btrfs-progs, which is also named
>> libbtrfs, inspired by libxfs.
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

Let me another chance: what about 'ubtrfs_'...



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
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
