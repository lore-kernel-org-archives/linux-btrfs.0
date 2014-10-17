Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17723 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835AbaJQKJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 06:09:35 -0400
Message-ID: <5440EAD8.4060801@fb.com>
Date: Fri, 17 Oct 2014 06:09:28 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs corruption fix
References: <543F78F1.6040203@fb.com>
In-Reply-To: <543F78F1.6040203@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/16/2014 03:51 AM, Chris Mason wrote:
> Hi Linus,
> 
> I'm testing a pull with more fixes, but wanted to get this one out so
> Greg can pick it up.  The corruption isn't easy to hit, you have to do a
> readonly snapshot and have orphans in the snapshot.  But my review and
> testing missed the bug.  Filipe has added a better xfstest to cover it.
> 
> Please pull:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Sorry Linus, I realized this morning I forgot my sob.  I've pushed out an
updated commit to a new for-linus-update branch.  The code and diffstat are 
exactly the same:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus-update

> 
> Chris Mason (1) commits (+33/-36):
>     Revert "Btrfs: race free update of commit root for ro snapshots"
> 
> Total: (1) commits (+33/-36)
> 
>  fs/btrfs/inode.c | 36 ------------------------------------
>  fs/btrfs/ioctl.c | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 36 deletions(-)
> 

-chris
