Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752798AbeDKPik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 11:38:40 -0400
Date: Wed, 11 Apr 2018 17:36:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: test mkfs.btrfs fails on small
 backing size thin provision device
Message-ID: <20180411153610.GE21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180411070330.31196-1-suy.fnst@cn.fujitsu.com>
 <70266c36-62b0-a373-82a5-668d6f188370@gmx.com>
 <df5b305b-8492-f058-4ace-6dfec23fa97b@cn.fujitsu.com>
 <9223c83d-53d9-c319-939e-a1cb6e5dc98e@gmx.com>
 <97214535-91b0-6a45-43a8-b74ee008d19d@suse.com>
 <bb635465-afaf-4748-6fd7-d3e47240db6b@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bb635465-afaf-4748-6fd7-d3e47240db6b@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2018 at 03:47:35PM +0800, Qu Wenruo wrote:
> >>>> What about using lvm other than plain dmsetup to create thin provision
> >>>> devices?
> >>>> IIRC this should be much easier to implement, without all the linear
> >>>> target hassles.
> >>>
> >>> Yes, doing it by LVM is more convenient.
> >>> However, LVM seems too abstract and it's never used in btrfs-progs.
> >>>
> >>> I have no idea whether LVM other tools should be used or not.
> >>
> >> We have check_global_prereq(), so it's no a problem to use external tools.
> > 
> > IMHO it's a good idea to keep requirements to the bare minimum. While
> > LVM will indeed be more user (in this case developer) friendly, I think
> > it's abstracting too much. So I'd rather stick with plain dm-setup.
> 
> Well, when we using device mappers, we're already introducing a lot of
> requirement, like kernel dm targets.
> 
> IMHO, if we can make test case shorter, it would help both test case
> developer and later developer who exposes problem on this test case.
> So I still prefer to use LVM to make test case smaller and easier to
> understand. (even this means extra infrastructures)

I think using dmsetup is still ok, the complexity can be factored out to
helpers if we need that again. We already use dmsetup so there's no
change necessary in the testing environment.
