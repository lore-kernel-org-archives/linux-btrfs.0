Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48471 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3KOMVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 07:21:38 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 09F659A06F8
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 05:21:38 -0700 (MST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131115113216.GA7777@osiris>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Mark Brown <broonie@kernel.org>
References: <20131114171952.3802.93244@localhost.localdomain>
 <20131115113216.GA7777@osiris>
Message-ID: <20131115122131.3802.25439@localhost.localdomain>
Subject: Re: [GIT PULL] Btrfs
Date: Fri, 15 Nov 2013 07:21:31 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Heiko Carstens (2013-11-15 06:32:16)
> On Thu, Nov 14, 2013 at 12:19:52PM -0500, Chris Mason wrote:
> > Hi Linus,
> > 
> > Please pull my for-linus branch:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > 
> > This is our usual merge window set of bug fixes, performance
> > improvements and cleanups.  Miao Xie has some really nice optimizations
> > for writeback.
> > 
> > Josef also expanded our sanity checks quite a bit; these make up a big
> > chunk of the new lines.
> 
> Hmm..  b19e68439375  "btrfs: Remove redundant local zero structure" seems to
> use the empty_zero_page incorrectly and causes this compile warning on s390:
> 
>   CC      fs/btrfs/ioctl.o
> fs/btrfs/ioctl.c: In function 'btrfs_is_empty_uuid':
> fs/btrfs/ioctl.c:372:2: warning: passing argument 2 of 'memcmp' makes pointer from
>                         integer without a cast [enabled by default]
>   return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
>   ^
> 
> In fact there seem to be two more incorrect usages in the kernel. The patch
> below is not really tested.

Thanks Heiko,

I'll make a new pull with the btrfs part of this.

-chris
