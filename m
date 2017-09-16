Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:48023 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751288AbdIPVEz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 17:04:55 -0400
Reply-To: kreijack@inwind.it
Subject: Re: subvolume list as user?
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20170916094504.GL32347@rus.uni-stuttgart.de>
 <684fb723-4270-9589-b80b-e60ccc6dadfe@mendix.com>
 <20170916143702.GO32347@rus.uni-stuttgart.de>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <54b8bb4b-3807-15da-1db5-fab7b0ced253@libero.it>
Date: Sat, 16 Sep 2017 22:56:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170916143702.GO32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2017 04:37 PM, Ulli Horlacher wrote:
> On Sat 2017-09-16 (14:39), Hans van Kranenburg wrote:
>> On 09/16/2017 11:45 AM, Ulli Horlacher wrote:
>>
>>> Every user can create subvolumes (and root cannot prevent it!).
>>> But how can a user list these subvolumes?
>>>
>>> tux@xerus:/test/tux: btrfs subvolume create test
>>> Create subvolume './test'
>>
>> From your other posts I don't quickly get if you actually do want to
>> have this possible, or accept that it's currently like that and try to
>> do damage control by having users also remove their things again.
> 
> I want both, country AND western :-)
> 
> Without joking:
> I just want to learn more about btrfs and I have various use cases to
> handle.
> 
> Different use cases need different actions.
> 
> 
>> Actually, if you don't want this I think it's quite easily to patch your
>> kernel with one or two lines of code to disallow it.
> 
> Kernel patching is a no-go for me. My boss does not allow it. No
> discussion possible on this topic.
> 
> 
>>> tux@xerus:/test/tux: btrfs subvolume list .
>>> ERROR: can't perform the search - Operation not permitted
>>
>> Yes, because the SEARCH ioctl only allows root to directly query any of
>> the filesystem metadata from kernel memory. subvolume list uses this
>> SEARCH ioctl to find it's info.
> 
> This is the explantion why it does not work, but it does not help me. I
> still have the problem: how can a user get a list of his subvolumes? He
> may created them some time ago and forget it. He now wants to have a list
> of them.


Far to be perfect, but this could help

find / -inum 256  2>/dev/null

each subvolume has inode number 256

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
