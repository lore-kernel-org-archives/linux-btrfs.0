Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbbDXNmi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 09:42:38 -0400
Date: Fri, 24 Apr 2015 15:42:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: xuw2015@gmail.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix btrfs quota rescan failed on PPC64 arch
Message-ID: <20150424134236.GP4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
 <4064896.UsZQ5YB6B2@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4064896.UsZQ5YB6B2@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 10:43:29PM +0530, Chandan Rajendra wrote:
> On Monday 20 Apr 2015 13:33:16 xuw2015@gmail.com wrote:
> > From: George Wang <xuw2015@gmail.com>
> > 
> > PPC64 arch use such following IOC values "
> > \#define _IOC_NONE       1U
> > \#define _IOC_READ       2U
> > \#define _IOC_WRITE      4U
> > " comparing to the default IOC values "
> > \#define _IOC_NONE       0U
> > \#define _IOC_READ       2U
> > \#define _IOC_WRITE      1U"
> > 
> > This means the value "_IOW*" will be negative when we store it in the int
> > variables. Such as the "BTRFS_IOC_QGROUP_CREATE", it will be "0x4010942e" on
> > X86_64, but "0x8010942e" on PPC64.
> > Notice that the IOC values are the "unsigned long" type, so we use the
> > "unsigned long" to store it, and this can insure the comparison between the
> > variable and BTRFS_IOC_* valid.
> > 
> > Signed-off-by: George Wang <xuw2015@gmail.com>
> 
> Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Thanks for testing, commit updated.
