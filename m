Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61683 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaG3Fp3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 01:45:29 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6U5jPEj018161
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 13:45:25 +0800
Message-ID: <1406698778.30821.8.camel@localhost.localdomain>
Subject: Re: [PATCH 4/4] btrfs-progs: correct manpage option description for
 scrub
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Date: Wed, 30 Jul 2014 13:39:38 +0800
In-Reply-To: <53D8808E.4020609@jp.fujitsu.com>
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1405564839-28702-4-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <53D8808E.4020609@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-07-30 at 14:20 +0900, Satoru Takeuchi wrote:
> Hi Gui,
> 
> (2014/07/17 11:40), Gui Hecheng wrote:
> > The -f option of scrub means to skip checking running scrub,
> > not to force checking.
> > 
> > Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> > ---
> >   Documentation/btrfs-scrub.txt | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
> > index 7b27d63..1af9b9f 100644
> > --- a/Documentation/btrfs-scrub.txt
> > +++ b/Documentation/btrfs-scrub.txt
> > @@ -47,7 +47,7 @@ manpage).
> >   -n <ioprio_classdata>::::
> >   Set IO priority classdata (see `ionice`(1) manpage).
> >   -f::::
> > -force to check whether scrub has started or resumed in userspace.
> > +force to skip checking whether scrub has started or resumed in userspace.

Hi Satoru,
Thanks for your comments first. My opinions are as follows:

> I consider "scrub has started and resumed" is not user-friendly
> expression. First, it can be replaced with more easy one,
> "scrub is running". Second, there in no explanation about
> this checking behavior before "-f" option's description.

Yes, "Scrub is running" is more precise.

> So, how about the following idea?
> 
>  Fix 1. Add "If scrub is already running running, it fails."
>         to the description before `Options` section
  This is really a valuable idea. 

>  Fix 2. Replace "force to check ..." with
>         "force starting new scrub even if scrub is already running."
  This is more precise.

>  Fix 3. Fix cmd_scrub_start_usage too.
  Of course, thanks for reminding me.

So please let me rework this patch, could I add your sign-off-by then?

Thanks,
Gui
> 
> Thanks,
> Satoru
> 
> >   this is useful when scrub stat record file is damaged.
> >   
> >   *cancel* <path>|<device>::
> > 
> 


