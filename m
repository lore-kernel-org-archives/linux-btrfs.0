Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbcFWML0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 08:11:26 -0400
Date: Thu, 23 Jun 2016 20:11:24 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs: fix 006 adds _runnt_btrfs_util_prog()
Message-ID: <20160623121124.GM3226@eguan.usersys.redhat.com>
References: <1466678252-4058-1-git-send-email-anand.jain@oracle.com>
 <20160623105302.GJ3226@eguan.usersys.redhat.com>
 <24a2491d-91d7-0e45-5008-e784b7a699fd@oracle.com>
 <20160623111843.GL3226@eguan.usersys.redhat.com>
 <98fc270c-cd74-23cb-7bd6-b02ff75a7b91@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <98fc270c-cd74-23cb-7bd6-b02ff75a7b91@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 07:34:49PM +0800, Anand Jain wrote:
> 
> 
> On 06/23/2016 07:18 PM, Eryu Guan wrote:
> > On Thu, Jun 23, 2016 at 07:03:59PM +0800, Anand Jain wrote:
> > > 
> > > 
> > > On 06/23/2016 06:53 PM, Eryu Guan wrote:
> > [snip]
> > > > > diff --git a/common/rc b/common/rc
> > > > > index a44fb8750220..2a10fbb2d341 100644
> > > > > --- a/common/rc
> > > > > +++ b/common/rc
> > > > > @@ -3114,6 +3114,17 @@ _min_dio_alignment()
> > > > >      fi
> > > > >  }
> > > > > 
> > > > > +run_check_dontfail()
> > > > > +{
> > > > > +	echo "# $@" >> $seqres.full 2>&1
> > > > > +	"$@" >> $seqres.full 2>&1 || echo "failed: '$@'"
> > > > > +}
> > > > > +
> > > > > +_runnt_btrfs_util_prog()
> > > > > +{
> > > > > +	run_check_dontfail $BTRFS_UTIL_PROG $*
> > > > > +}
> > > > > +
> > > > >  run_check()
> > > > >  {
> > > > >  	echo "# $@" >> $seqres.full 2>&1
> > > > > diff --git a/tests/btrfs/006 b/tests/btrfs/006
> > > > > index 715fd80fb6fc..9d1fe09e07de 100755
> > > > > --- a/tests/btrfs/006
> > > > > +++ b/tests/btrfs/006
> > > > > @@ -79,7 +79,7 @@ echo "== Show filesystem by UUID"
> > > > >  $BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show $TOTAL_DEVS $UUID
> > > > > 
> > > > >  echo "== Sync filesystem"
> > > > > -$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
> > > > > +_runnt_btrfs_util_prog filesystem sync $SCRATCH_MNT
> > > > 
> > > > Still, I don't think this helper is necessary.
> > > > 
> > > > $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null
> > > > 
> > > > doesn't _fail on failure, output error messages breaks golden image, and
> > > > is much simpler. Do I miss anything?
> > > 
> > >  runnt_btrfs_util_prog() checks the return status of the command,
> > >  if failed (!0) it will echo so to break the golden image.
> > 
> > So it fails silently now? (return non-zero value and print no error
> > message) That seems a btrfs-progs bug to me.. It should print error
> > messages to stderr on failure, so we don't have to check the return
> > value explicitly.
> 
>  For programming interfaces I would rather depend more on the return
>  value, than the UI/error strings.

I checked btrfs-progs code, it does print error message on failure. So
the question is whether should we depend on return value of commands.

fstests is designed to let users to ignore return value and depend on
error messages to break golden image, so we don't have to check every
command's return value. Quating Dave's previous review [1]:

"
the test harness infrastructure is designed specifcally so
that we don't need to check the error status of every program we
run.  Programs need to give users obvious feedback of failure (i.e.
stdout/stderr) because users *do not check return codes*, and the
test harness is designed around ensuring programs generate useful
error messages.
"

And the usage of run_check is not encouraged[2], and even is considered
harmful [3].

So please depend on error messages in fstests and avoid using helpers
like run_check.

Thanks,
Eryu

[1] http://www.spinics.net/lists/fstests/msg01333.html
[2] http://www.spinics.net/lists/fstests/msg01299.html
[3] http://www.spinics.net/lists/fstests/msg01489.html
