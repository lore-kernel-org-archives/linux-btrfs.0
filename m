Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:15061 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbeCWG3x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 02:29:53 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 07EA6AC011A
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 15:29:49 +0900 (JST)
Subject: Re: [PATCH] btrfs: Allow non-privileged user to delete empty
 subvolume by default
To: Nikolay Borisov <nborisov@suse.com>, <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5164078e-4e15-d6df-7356-fa4f5d70a2db@jp.fujitsu.com>
 <f00fe679-5c18-27db-a921-b303405968bc@libero.it>
 <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <6bfe41e5-4193-fa49-ef8e-9ec751e72c05@jp.fujitsu.com>
Date: Fri, 23 Mar 2018 15:29:42 +0900
MIME-Version: 1.0
In-Reply-To: <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/21 16:46, Nikolay Borisov wrote:
> 
> 
> On 20.03.2018 22:06, Goffredo Baroncelli wrote:
>> On 03/20/2018 07:45 AM, Misono, Tomohiro wrote:
>>> Deletion of subvolume by non-privileged user is completely restricted
>>> by default because we can delete a subvolume even if it is not empty
>>> and may cause data loss. In other words, when user_subvol_rm_allowed
>>> mount option is used, a user can delete a subvolume containing the
>>> directory which cannot be deleted directly by the user.
>>>
>>> However, there should be no harm to allow users to delete empty subvolumes
>>> when rmdir(2) would have been allowed if they were normal directories.
>>> This patch allows deletion of empty subvolume by default.
>>
>> Instead of modifying the ioctl, what about allowing rmdir(2) to work for an _empty_ subvolume (and all the permission check are satisfied) ?
> 
> I'm inclined to agree with Goffredo. user_subvol_rm_allowed flag really
> looks like a hack ontop of the ioctl. I'd rather we modify the generic
> behavior.

Ok, I will send another patch which allows rmdir(2) to delete a subvolume.

Thanks,
Tomohiro Misono


