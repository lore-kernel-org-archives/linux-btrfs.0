Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:23818 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdJBX6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 19:58:11 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 651DBAC01C7
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 08:58:06 +0900 (JST)
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to also
 accept subvol path
To: Hugo Mills <hugo@carfax.org.uk>, Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
 <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
 <20171002090129.GB3293@carfax.org.uk>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <45a84df9-fd06-ca72-3379-4594fceb4b5a@jp.fujitsu.com>
Date: Tue, 3 Oct 2017 08:57:52 +0900
MIME-Version: 1.0
In-Reply-To: <20171002090129.GB3293@carfax.org.uk>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/10/02 18:01, Hugo Mills wrote:
> On Mon, Oct 02, 2017 at 11:39:05AM +0300, Andrei Borzenkov wrote:
>> On Mon, Oct 2, 2017 at 11:19 AM, Misono, Tomohiro
>> <misono.tomohiro@jp.fujitsu.com> wrote:
>>> This patch changes "subvol set-default" to also accept the subvolume path
>>> for convenience.
>>>
>>> This is the one of the issue on github:
>>> https://github.com/kdave/btrfs-progs/issues/35
>>>
>>> If there are two args, they are assumed as subvol id and path to the fs
>>> (the same as current behavior), and if there is only one arg, it is assumed
>>> as the path to the subvolume. Therefore there is no ambiguity between subvol
>>> id and subvol name, which is mentioned in the above issue page.
>>>
>>> Only the absolute path to the subvolume is allowed, for the safety when
>>> multiple filesystems are used.
>>>
>>> subvol id is resolved by get_subvol_info() which is used by "subvol show".
>>>
>>> change to v2:
>>> restrict the path to only allow absolute path.
>>
>> This is absolutely arbitrary restriction. Why we can do "btrfs
>> subvolume create ./relative/path" but cannot do "btrfs subvolume
>> set-default ./relative/path"?
> 
>    Indeed. In fact, it's precisely the _opposite_ of the way that
> every other command works -- you provide the path to the subvolume in
> the *current namespace*.
> 
>    This approach would be just a major misfeature at this point.
> 
>    Hugo.
> 

Ok, I understood the point and want to revert this.
Please review the first version if possible:
https://mail-archive.com/linux-btrfs@vger.kernel.org/msg68486.html

Thanks,
Tomohiro

