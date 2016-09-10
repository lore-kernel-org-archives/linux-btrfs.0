Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:36638 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754784AbcIJP6M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 11:58:12 -0400
Date: Sat, 10 Sep 2016 23:58:05 +0800
From: Sean Fu <fxinrong@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, clm@fb.com, anand.jain@oracle.com,
        Filipe Manana <FdManana@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove unnecessary code of chunk_root assignment
 in btrfs_read_chunk_tree.
Message-ID: <20160910155804.GB5659@linux-zmni.DHCP>
References: <1472990010-10707-1-git-send-email-fxinrong@gmail.com>
 <002501d20713$7ee67050$7cb350f0$@cn.fujitsu.com>
 <e48353fc-cd00-789c-291e-80c684afe2e2@cn.fujitsu.com>
 <57CE326C.8000105@suse.com>
 <57CE3464.7090107@suse.com>
 <20160906095858.GA16983@suse.cz>
 <61eeb5da-c537-2392-74e4-eac77eda6264@suse.com>
 <20160909030836.GA15304@linux-zmni.apac.novell.com>
 <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e1d0adbb-922d-0778-a59d-6e6922c2ab68@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 11:25:48PM -0400, Jeff Mahoney wrote:
> On 9/8/16 11:08 PM, Sean Fu wrote:
> > On Tue, Sep 06, 2016 at 11:12:20AM -0400, Jeff Mahoney wrote:
> >> On 9/6/16 5:58 AM, David Sterba wrote:
> >>> On Mon, Sep 05, 2016 at 11:13:40PM -0400, Jeff Mahoney wrote:
> >>>>>> Since root is only used to get fs_info->chunk_root, why not use fs_info
> >>>>>> directly?
> >>>>>
> >>>>> Weird.  Exactly this was a part of my fs_info patchset.  I guess I need
> >>>>> to go back and check what else is missing.
> >>>>
> >>>> Actually, most of this didn't land.  Pretty much anything that's a root
> >>>> ->fs_info conversion is in there.
> >>>
> >>> Only half of the patchset has been merged so far because it did not pass
> >>> testing, so I bisected to some point. I was about to let you know once
> >>> most of 4.9 patches are prepared so there are less merge conflicts.
> >>
> >> Ok, thanks.  I was going to start the rebase today but I'll hold off
> >> until you're set for 4.9.
> >>
> > Hi Jeff, Could you please share your patch? Where can i get it?
> > I wanna have a look at it.
> 
> Sure, it's the whole series that starts with this commit:
> commit 160ceedfd40085cfb1e08305917fcc24cefdad93
> Author: Jeff Mahoney <jeffm@suse.com>
> Date:   Wed Aug 31 23:55:33 2016 -0400
> 
>     btrfs: add dynamic debug support
> 
> ... I still need to do clean up some commits that need merging.
> 
> https://git.kernel.org/cgit/linux/kernel/git/jeffm/linux-btrfs.git/log/?h=btrfs-testing/kdave/misc-4.9/root-fsinfo-cleanup
> 
Nice work. Thanks for your explaination.
I have one more question about it.
Although the total text size of this function is not changed, using
fs_info should need one more instruction to get chunk_root field of
fs_info than using chunk_root directly.
Does it cause any performance impact?

Sean
> -Jeff
> 
> 
> > Thanks
> >> -Jeff
> >>
> >> -- 
> >> Jeff Mahoney
> >> SUSE Labs
> >>
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> Jeff Mahoney
> SUSE Labs
> 



