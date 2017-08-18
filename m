Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:51423 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750807AbdHRHWF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 03:22:05 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Nikolay Borisov <nborisov@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Piotr Szymaniak <szarpaj@grubelek.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170814225740.GK19638@pontus.sran>
 <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
 <CAJCQCtTU9EGhjeug-AzS0TDfySwTQi=dPrFLRDE1Go71E7+W+g@mail.gmail.com>
 <9d24b092-6b03-8d97-b4bd-feb36e00b9e0@inwind.it>
 <e965d461-7185-59ef-d025-d51a886aacb7@suse.com>
 <6b16fa81-a1a5-3243-0f7d-59a7ec9ae168@inwind.it>
 <496d27de-43c8-4508-a664-71083d90ae1b@suse.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <f94e9e0e-fd1b-0674-7987-3849a45cf653@inwind.it>
Date: Fri, 18 Aug 2017 09:22:03 +0200
MIME-Version: 1.0
In-Reply-To: <496d27de-43c8-4508-a664-71083d90ae1b@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2017 09:12 AM, Nikolay Borisov wrote:
> 
> 
> On 18.08.2017 10:09, Goffredo Baroncelli wrote:
>> On 08/18/2017 08:34 AM, Nikolay Borisov wrote:
[...]
>>> It would be awesome if you manage to introduce xfstests for this case
>>
>> I am not sure if this is the right thing to do: the bugs are related to 
>> a) an incorrect error handling of the function lookup_path_rootid()
>> b) the strange behavior of the BTRFS_EMPTY_SUBVOL_DIR_OBJECTID directory
>>
>> For a) it is impossible to check for each lookup_path_rootid() call from a xfstest; for b) I am quite sure that there are a lot of corner case not properly handled in btrfs progs (and still btrfs fi-du handle it wrongly)
> 
> So the bug is actually in the btrfsprogs not in the fs, am I correct?
> 
Yes, definitively


BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
