Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:57204 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932351Ab2GLN1y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 09:27:54 -0400
Date: Thu, 12 Jul 2012 09:27:51 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Li Zefan <lizefan@huawei.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: kill free_space pointer from inode structure
Message-ID: <20120712132751.GC2059@localhost.localdomain>
References: <4FFB9193.6040306@huawei.com>
 <20120710192953.GF7529@localhost.localdomain>
 <4FFE2A83.3050604@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FFE2A83.3050604@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 11, 2012 at 07:38:11PM -0600, Li Zefan wrote:
> On 2012/7/11 3:29, Josef Bacik wrote:
> 
> > On Mon, Jul 09, 2012 at 08:21:07PM -0600, Li Zefan wrote:
> >> Inodes always allocate free space with BTRFS_BLOCK_GROUP_DATA type,
> >> which means every inode has the same BTRFS_I(inode)->free_space pointer.
> >>
> >> This shrinks struct btrfs_inode by 4 bytes (or 8 bytes on 64 bits).
> >>
> >> Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> > Li I can't apply any of your patches because they are all in base64 format and
> > I'm having a hell of a time pulling them out to apply them, can you resend with
> > git send-email or something so I can apply them properly?  Thanks,
> > 
> 
> 
> Hmm.. I got no complaints from Tejun or Chris before, so I didn't realize all
> the emails I sent were in base64. It should be the email server that encoded
> my patches, so I don't think using git-send-email will make any difference.
> (not to mention I failed to make git-send-email work in my office :(
> 
> Is it ok if I attach the patches in attachments? Otherwise I'll use gmail
> instead when I'm at home.
> 

Sorry I'll just pull them out somewhere else, for some reason notmuch doesn't
want to decode them properly so I just get garbage.  I'll just pull it out of
thunderbird by hand, hopefully that will work properly.  Thanks,

Josef
