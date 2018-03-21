Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([213.209.14.17]:42108 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752954AbeCUUiN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Mar 2018 16:38:13 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs: Allow non-privileged user to delete empty
 subvolume by default
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>,
        "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5164078e-4e15-d6df-7356-fa4f5d70a2db@jp.fujitsu.com>
 <f00fe679-5c18-27db-a921-b303405968bc@libero.it>
 <c4fc8c1f-32cf-06e5-f8fa-ca5574aca347@suse.com>
 <5ce4f667-e97f-c87e-466d-37d488f2abbb@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cf65350d-1985-ac5b-2fb6-72fedfa9adf0@inwind.it>
Date: Wed, 21 Mar 2018 21:38:06 +0100
MIME-Version: 1.0
In-Reply-To: <5ce4f667-e97f-c87e-466d-37d488f2abbb@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/21/2018 12:47 PM, Austin S. Hemmelgarn wrote:
> I agree as well, with the addendum that I'd love to see a new ioctl that does proper permissions checks.  While letting rmdir(2) work for an empty subvolume with the appropriate permissions would be great (it will let rm -r work correctly), it doesn't address the usefulness of being able to just `btrfs subvolume delete` and not have to wait for the command to finish before you can reuse the name.

How this could work ? 

If you want to check all the subvolumes files permissions, this will require some time: you need to traverse all the subvolume-filesystem; and only if all the checks are passed, you can delete the subvolume.

Unfortunately I think that only two options exist:
- don't check permissions, and you can quick remove a subvolume
- check all the permissions, i.e. check all the files permissions, and only if all the permissions are OK, you can delete the subvolume. However this cannot be a "quick" subvolume delete

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
