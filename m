Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52605 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3LPXyU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 18:54:20 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so5851699oag.30
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 15:54:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ABF7C191-D33A-4DE2-9E31-D44B7CE16475@colorremedies.com>
References: <CAO5znau9bYtjLmcwSE9uD7tRo0uY_CLHhLNCoYW7cpRLJtve-g@mail.gmail.com>
	<ABF7C191-D33A-4DE2-9E31-D44B7CE16475@colorremedies.com>
Date: Tue, 17 Dec 2013 00:54:19 +0100
Message-ID: <CAO5znatm9bKq2a3WBSAZTEPjHQgS3DZpRwGY7pDsyN9J1WsWNQ@mail.gmail.com>
Subject: Re: Understanding subvolume hierarchy
From: Nicolas Michel <be.nicolas.michel@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK. thanks for your pretty fast answer :)

Now my last question is: in this case it was "easy" as I know that I
created all these subvolumes as parts of volume 0. But in the btrfs
subv list / I don't see any information that tells me they belongs to
id 0. If I have to debug a server/desktop and I don't know the
hierarchy that has been made, how can I know that my tmp subvolume is
indeed a child of id 0 ?


2013/12/17 Chris Murphy <lists@colorremedies.com>:
>
> On Dec 16, 2013, at 4:20 PM, Nicolas Michel <be.nicolas.michel@gmail.com> wrote:
>
>>
>> So now, I wanted to delete the old subvolumes I created. I ran into
>> problems: the Ubuntu installer set the default subvolume to @ (id=5).
>
> This is normal. id=0 maps to id=5
>
>
>
>> So when I try to delete my previous subvolumes it tells me it doesn't
>> find it ... Here are some output to be more concrete:
>>
>> root@my-tour:~# btrfs subv get-default /
>> ID 5 (FS_TREE)
>> root@my-tour:~# btrfs subv list /
>> ID 258 gen 6 top level 5 path home
>> ID 259 gen 7 top level 5 path tmp
>> ID 260 gen 8 top level 5 path home-root
>> ID 261 gen 9 top level 5 path logs
>> ID 262 gen 138 top level 5 path @
>> ID 263 gen 139 top level 5 path @home
>> root@my-tour:~# btrfs subv del tmp
>> ERROR: error accessing 'tmp'
>
> This is because / is subvol=@, so your delete request is in effect asking to delete subvolume /@/tmp which doesn't exist. To access tmp, the top level default subvolume needs to be mounted.
>
>>
>> The only way I found to circumvent the problem was to mount the root
>> volume (id=0) on /mnt with "-o subvolid=0" and then from there I'm
>> able to delete anything.
>
> So long as nothing has used set-default to change it from the default of 0/5, you don't need to specify the subvol or subvolid mount option. You can just mount /dev/sdXY /mnt and that will mount the default subvolume.
>
>
>> My questions are :
>> - can I directly delete a subvolume with its ID? (so I don't have to
>> mount the id 0 to do it)
>
>> - or is there a way to specify the path starting not from the default
>> volume but forcing to start from id 0? Something like "btrfs subv del
>> 0/tmp" (I tried, it doesn't work ;)
>
> They are separate fs trees, so you can see them as separate fs's and ones above aren't accessible from below. So a subvol above the subvol you want to delete needs to be mounted.
>
> Chris Murphy



-- 
Nicolas MICHEL
