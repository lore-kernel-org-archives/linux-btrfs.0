Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:38967 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751908AbeCVMPT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 08:15:19 -0400
Received: by mail-io0-f169.google.com with SMTP id v13so10686810iob.6
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 05:15:19 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Allow non-privileged user to delete empty
 subvolume by default
To: kreijack@inwind.it, Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5164078e-4e15-d6df-7356-fa4f5d70a2db@jp.fujitsu.com>
 <f00fe679-5c18-27db-a921-b303405968bc@libero.it>
 <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
 <5ce4f667-e97f-c87e-466d-37d488f2abbb@gmail.com>
 <cf65350d-1985-ac5b-2fb6-72fedfa9adf0@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <53ff753f-6078-ddf7-3107-14f1fddd7c26@gmail.com>
Date: Thu, 22 Mar 2018 08:15:16 -0400
MIME-Version: 1.0
In-Reply-To: <cf65350d-1985-ac5b-2fb6-72fedfa9adf0@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-21 16:38, Goffredo Baroncelli wrote:
> On 03/21/2018 12:47 PM, Austin S. Hemmelgarn wrote:
>> I agree as well, with the addendum that I'd love to see a new ioctl that does proper permissions checks.  While letting rmdir(2) work for an empty subvolume with the appropriate permissions would be great (it will let rm -r work correctly), it doesn't address the usefulness of being able to just `btrfs subvolume delete` and not have to wait for the command to finish before you can reuse the name.
> 
> How this could work ?
> 
> If you want to check all the subvolumes files permissions, this will require some time: you need to traverse all the subvolume-filesystem; and only if all the checks are passed, you can delete the subvolume.
> 
> Unfortunately I think that only two options exist:
> - don't check permissions, and you can quick remove a subvolume
> - check all the permissions, i.e. check all the files permissions, and only if all the permissions are OK, you can delete the subvolume. However this cannot be a "quick" subvolume delete

Why exactly would you need to check everything?  What I'm talking about 
is having behavior like `user_subvol_rm_allowed` be the default, with an 
additional check emulating the regular dentry removal check (namely that 
the user has appropriate permissions on the parent directory) so that 
people can't delete things like their own home directories.  We're 
already _way_ beyond POSIX semantics here because we're debating the 
handling of permissions for an ioctl that takes a different fd than what 
it functionally operates on, so I see no reason whatsoever that we need 
to enforce POSIX semantics to that degree.
