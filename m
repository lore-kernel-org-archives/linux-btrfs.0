Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934312AbcCQO3f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 10:29:35 -0400
Date: Thu, 17 Mar 2016 15:29:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Davide Italiano <dccitaliano@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>, dsterba@suse.cz,
        bo.li.liu@oracle.com
Subject: Re: [PATCH] Btrfs: Improve FL_KEEP_SIZE handling in fallocate.
Message-ID: <20160317142908.GV21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1428383355-1686-1-git-send-email-dccitaliano@gmail.com>
 <1428383355-1686-2-git-send-email-dccitaliano@gmail.com>
 <20150626140823.GU726@twin.jikos.cz>
 <CADob98SbbLfLorGX0W4MRWMYe_uWFVQA88k7VRJLkv0nhANReg@mail.gmail.com>
 <CADob98QV6MLi9W_T+EdPyLc=UJ9=hzycJ7J=uVPT-6p4zqH8GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADob98QV6MLi9W_T+EdPyLc=UJ9=hzycJ7J=uVPT-6p4zqH8GQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 21, 2015 at 10:16:46AM -0700, Davide Italiano wrote:
> On Wed, Jul 22, 2015 at 10:45 AM, Davide Italiano <dccitaliano@gmail.com> wrote:
> > On Fri, Jun 26, 2015 at 7:08 AM, David Sterba <dsterba@suse.cz> wrote:
> >> On Mon, Apr 06, 2015 at 10:09:15PM -0700, Davide Italiano wrote:
> >>> - We call inode_size_ok() only if FL_KEEP_SIZE isn't specified.
> >>> - As an optimisation we can skip the call if (off + len)
> >>>   isn't greater than the current size of the file. This operation
> >>>   is called under the lock so the less work we do, the better.
> >>> - If we call inode_size_ok() pass to it the correct value rather
> >>>   than a more conservative estimation.
> >>>
> >>> Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
> >>
> >> Reviewed-by: David Sterba <dsterba@suse.cz>
> >
> > Hi Chris, this has been around for a while and it's been reviewed by
> > multiple people. Any chances you can pull in your branch?

I'm adding this patch to my for-next, sorry for late response.
