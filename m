Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17211 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbbHUPYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 11:24:52 -0400
Date: Fri, 21 Aug 2015 11:23:40 -0400
From: Chris Mason <clm@fb.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next conflict resolution branch for btrfs
Message-ID: <20150821152340.GA28016@ret>
References: <20150820173918.GA10637@ret.thefacebook.com>
 <20150821104524.2f759d74@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150821104524.2f759d74@canb.auug.org.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 21, 2015 at 10:45:24AM +1000, Stephen Rothwell wrote:
> Hi Chris,
> 
> On Thu, 20 Aug 2015 13:39:18 -0400 Chris Mason <clm@fb.com> wrote:
> >
> > There are a few conflicts for btrfs in linux-next this time.  They are
> > small, but I pushed out the merge commit I'm using here:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next-merge
> 
> Thanks for that.  It seems to have merged OK but maybe it conflicts
> with something later in linux-next.  Unfortunately see my other email
> about a build problem.  I will keep this example merge in mind for
> later.

Ok, sorry about that one.  We probably want the ifdefs up in Tejun's
code, but I'll talk with him about it today and get it fixed up.

Thanks,
Chris
