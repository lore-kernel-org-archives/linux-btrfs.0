Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16371 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754880AbaG3HdY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 03:33:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6U7XKcU024741
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:33:20 +0800
Message-ID: <1406705253.30821.29.camel@localhost.localdomain>
Subject: Re: [PATCH 1/4] btrfs-progs: adjust the return values for scrub
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 30 Jul 2014 15:27:33 +0800
In-Reply-To: <53D8927C.6000006@jp.fujitsu.com>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <53D88AA2.90804@jp.fujitsu.com> <53D8927C.6000006@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Satoru, I just give a reply to the former 2 mails together here.

On Wed, 2014-07-30 at 15:36 +0900, Satoru Takeuchi wrote:
> Hi Gui,
> 
> (2014/07/30 15:03), Satoru Takeuchi wrote:
> > Hi Gui,
> > 
> > (2014/07/17 11:40), Gui Hecheng wrote:
> >> o Return 0 to indicate success,
> >>     when detected errors were corrected during scrubbing.
> >>     P.s. This is also to facilitate scripting when return value
> >>          is to be checked.
> >> o Warn the users if there are uncorrectable errors detected.
> >>
> >> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> >> ---
> >>    cmds-scrub.c | 13 ++++++++-----
> >>    1 file changed, 8 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/cmds-scrub.c b/cmds-scrub.c
> >> index 5265a2b..f9e2b40 100644
> >> --- a/cmds-scrub.c
> >> +++ b/cmds-scrub.c
> >> @@ -1514,14 +1514,17 @@ out:
> >>    	}
> >>    	close_file_or_dir(fdmnt, dirstream);
> >>    
> >> -	if (nothing_to_resume)
> >> -		return 2;
> >>    	if (err)
> >>    		return 1;
> >> -	if (e_correctable)
> >> +	if (nothing_to_resume)
> >> +		return 2;
> >> +	if (e_uncorrectable) {
> >> +		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
> >>    		return 3;
> >> -	if (e_uncorrectable)
> >> -		return 4;
> >> +	}
> >> +	if (e_correctable)
> >> +		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
> >> +
> > 
> > 1. ERR() messages are not necessary since start command
> >     reports its status in the middle of scrub_start().
> >     It includes both the number of correctable/uncorrectable errors.
	Ok, it may not seems "neccessary", but these ERR()s serve as
conclusions at the end to the users. Because users care whether a scrub
is able to detect errors and if yes, whether the errors are corrected.
So it adds to user experience.

> > 2. It prints messages even if this program runs as foreground mode.
> >     Checking do_print is necessary.
	The do_print serves to control whether "sub procedures(such as
pthread_create/join, scrub_write_progress etc.)" failed or not in
foreground mode, so do_print should not effect conclusion outputs since
all the "sub procedures" succeeded.
 
> > 3. Whether correctable/uncorrectable error exists in a file system
> >     is not related to the exist status of scrub. The role of this
> >     program is
> > 
> >      a) reading all data from all devices and verify checksums, and
> >      b) correct checksum errors "if possible".
> > 
> >     So, I consider scrub only returns error if this program itself
> >     failed to finish.
> 
> Sorry, I understood what you said. It's no problem to exit with
> error codes to detect whether correctable/uncorrectable errors happen
> or not. Sorry for noise.
> 
> Thanks,
> Satoru

Oh, it is really kind of you to spend time reviewing. Thanks very much.

-Gui
> > 
> > Thanks,
> > Satoru
> > 
> >>    	return 0;
> >>    }
> >>    
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


