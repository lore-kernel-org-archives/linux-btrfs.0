Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36692 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbcGKK5P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 06:57:15 -0400
Received: by mail-wm0-f44.google.com with SMTP id f126so84983702wma.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 03:57:13 -0700 (PDT)
Subject: Re: [RESEND PATCH] btrfs: Handle uninitialised inode eviction
To: dsterba@suse.cz, clm@fb.com, linux-btrfs@vger.kernel.org
References: <1468219389-28736-1-git-send-email-kernel@kyup.com>
 <20160711084800.GR13336@twin.jikos.cz>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <57837B86.9070604@kyup.com>
Date: Mon, 11 Jul 2016 13:57:10 +0300
MIME-Version: 1.0
In-Reply-To: <20160711084800.GR13336@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/11/2016 11:48 AM, David Sterba wrote:
> On Mon, Jul 11, 2016 at 09:43:09AM +0300, Nikolay Borisov wrote:
>> The code flow in btrfs_new_inode allows for btrfs_evict_inode to be
>> called with not fully initialised inode (e.g. ->root member not
>> being set). This can happen when btrfs_set_inode_index in
>> btrfs_new_inode fails, which in turn would call iput for the newly
>> allocated inode. This in turn leads to vfs calling into btrfs_evict_inode.
>> This leads to null pointer dereference. To handle this situation check whether
>> the passed inode has root set and just free it in case it doesn't.
>>
>> Signed-off-by: Nikolay Borisov <kernel@kyup.com>
>> Reviewed-by: Josef Bacik <jbacik@fb.com>
>> ---
>>  fs/btrfs/inode.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> Hello, 
>>
>> I belive this is fixes the issue reported in 
>> http://thread.gmane.org/gmane.comp.file-systems.btrfs/57809
> 
> There's some time left before 4.7 release, so I'll send another pull
> request, including this patch.

Now that I think about it, shouldn't this also be queued for stable as well?
