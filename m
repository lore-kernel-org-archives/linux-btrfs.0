Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727773AbeINTqx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 15:46:53 -0400
Date: Fri, 14 Sep 2018 16:32:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Continue checking even we found something
 wrong in free space cache
Message-ID: <20180914143206.GK5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180904124128.22367-1-wqu@suse.com>
 <20180911144809.GB2154@twin.jikos.cz>
 <251a3f20-617f-1bee-4567-c563b0744c30@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <251a3f20-617f-1bee-4567-c563b0744c30@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 07:43:27AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/9/11 下午10:48, David Sterba wrote:
> > On Tue, Sep 04, 2018 at 08:41:28PM +0800, Qu Wenruo wrote:
> >> No need to abort checking, especially for RO check free space cache is
> >> meaningless, the errors in fs/extent tree is more interesting for
> >> developers.
> >>
> >> So continue checking even something in free space cache is wrong.
> >>
> >> Reported-by: Etienne Champetier <champetier.etienne@gmail.com>
> >> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >> ---
> >>  check/main.c | 1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/check/main.c b/check/main.c
> >> index b361cd7e26a0..4f720163221e 100644
> >> --- a/check/main.c
> >> +++ b/check/main.c
> >> @@ -9885,7 +9885,6 @@ int cmd_check(int argc, char **argv)
> >>  			error("errors found in free space tree");
> >>  		else
> >>  			error("errors found in free space cache");
> > 
> > Please make it a warning and update the message so it says that it will
> > continue despite the errors found.
> 
> I'm fine to add warning, but isn't it the expected behavior?
> 
> In fact I'm quite surprised that when we found something wrong we just
> abort checking.
> 
> It's never the case for file/extent tree check. We always report all
> errors we found, not only the first error and exit.

You're right, in context of 'check' this is the expected behaviour. So
let's keep error().
