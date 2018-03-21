Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35457 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbeCULrg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 07:47:36 -0400
Received: by mail-io0-f194.google.com with SMTP id e7so6272432iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Mar 2018 04:47:36 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Allow non-privileged user to delete empty
 subvolume by default
To: Nikolay Borisov <nborisov@suse.com>, kreijack@inwind.it,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5164078e-4e15-d6df-7356-fa4f5d70a2db@jp.fujitsu.com>
 <f00fe679-5c18-27db-a921-b303405968bc@libero.it>
 <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5ce4f667-e97f-c87e-466d-37d488f2abbb@gmail.com>
Date: Wed, 21 Mar 2018 07:47:31 -0400
MIME-Version: 1.0
In-Reply-To: <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-21 03:46, Nikolay Borisov wrote:
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
I agree as well, with the addendum that I'd love to see a new ioctl that 
does proper permissions checks.  While letting rmdir(2) work for an 
empty subvolume with the appropriate permissions would be great (it will 
let rm -r work correctly), it doesn't address the usefulness of being 
able to just `btrfs subvolume delete` and not have to wait for the 
command to finish before you can reuse the name.
