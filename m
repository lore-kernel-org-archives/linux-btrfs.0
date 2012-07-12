Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:59005 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab2GLBiZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 21:38:25 -0400
Message-ID: <4FFE2A83.3050604@huawei.com>
Date: Thu, 12 Jul 2012 09:38:11 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: kill free_space pointer from inode structure
References: <4FFB9193.6040306@huawei.com> <20120710192953.GF7529@localhost.localdomain>
In-Reply-To: <20120710192953.GF7529@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/7/11 3:29, Josef Bacik wrote:

> On Mon, Jul 09, 2012 at 08:21:07PM -0600, Li Zefan wrote:
>> Inodes always allocate free space with BTRFS_BLOCK_GROUP_DATA type,
>> which means every inode has the same BTRFS_I(inode)->free_space pointer.
>>
>> This shrinks struct btrfs_inode by 4 bytes (or 8 bytes on 64 bits).
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Li I can't apply any of your patches because they are all in base64 format and
> I'm having a hell of a time pulling them out to apply them, can you resend with
> git send-email or something so I can apply them properly?  Thanks,
> 


Hmm.. I got no complaints from Tejun or Chris before, so I didn't realize all
the emails I sent were in base64. It should be the email server that encoded
my patches, so I don't think using git-send-email will make any difference.
(not to mention I failed to make git-send-email work in my office :(

Is it ok if I attach the patches in attachments? Otherwise I'll use gmail
instead when I'm at home.

