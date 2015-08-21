Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30754 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbbHUSGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 14:06:46 -0400
Date: Fri, 21 Aug 2015 14:06:41 -0400
From: Chris Mason <clm@fb.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next conflict resolution branch for btrfs
Message-ID: <20150821180641.GA30284@ret.event.rightround.com>
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

Ok, I put the ifdefs in btrfs.  Really what I need to do is change
bio_clone to do this work, but that means making sure its the right
thing for dm/md first.

I also added ifdefs for bio->bi_ioc in fs/btrfs/volumes.c, but
another commit in linux-next actually deletes the whole function from
btrfs.  I've redone the example merge:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git next-merge

-chris
