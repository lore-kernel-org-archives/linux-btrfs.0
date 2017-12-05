Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58200 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751774AbdLEIkn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:40:43 -0500
Date: Tue, 5 Dec 2017 16:40:41 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs/124: add balance --full-balance option
Message-ID: <20171205084041.GL2749@eguan.usersys.redhat.com>
References: <20171205082628.1676-1-anand.jain@oracle.com>
 <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <0a70d47c-7bcc-a6ff-c79e-b988fd305818@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 05, 2017 at 04:30:33PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年12月05日 16:26, Anand Jain wrote:
> > btrfs balance needs --full-balance option since 4.6, so check the
> > version and then use it.
> > 
> > As this may be useful for other btrfs tests as well, so this patch
> > adds _btrfs_full_balance_option() to the common/btrfs file.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> > ---
> >  common/btrfs    | 13 +++++++++++++
> >  tests/btrfs/124 |  3 ++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/btrfs b/common/btrfs
> > index c09206c6f292..8ca6486b26dc 100644
> > --- a/common/btrfs
> > +++ b/common/btrfs
> > @@ -356,3 +356,16 @@ _btrfs_compression_algos()
> >  		echo "${feature#/sys/fs/btrfs/features/compress_}"
> >  	done
> >  }
> > +
> > +#btrfs-progs adds required --full-balance option since v4.6 so check for
> > +#that and then return the required option.
> > +_btrfs_full_balance_option()
> > +{
> > +	ver=$($BTRFS_UTIL_PROG --version|awk '{print $2}'|cut -d"-" -f1 | cut -d"v" -f2)
> 
> I'm never a fan of version check.
> Backporting or modified package version can easily screw this up.

Agreed, avoid version checking if possible.

> 
> Why not directly checking the help message of "btrfs balance start"?
> 
> Thanks,
> Qu
> 
> > +	tup1=$(echo $ver| cut -d"." -f1)
> > +	tup2=$(echo $ver| cut -d"." -f2)

And please declare local variables as 'local'.

> > +
> > +	RET=""
> > +	(("$tup1" > "4")) && RET="--full-balance"
> > +	(("$tup1" == "4")) && (("tup2" >= "6")) && RET="--full-balance"
> > +}
> > diff --git a/tests/btrfs/124 b/tests/btrfs/124
> > index a6486270a972..ec1d24b5ef42 100755
> > --- a/tests/btrfs/124
> > +++ b/tests/btrfs/124
> > @@ -129,7 +129,8 @@ _run_btrfs_util_prog device scan
> >  _scratch_mount >> $seqres.full 2>&1
> >  _run_btrfs_util_prog filesystem show
> >  echo >> $seqres.full
> > -_run_btrfs_util_prog balance start ${SCRATCH_MNT}
> > +_btrfs_full_balance_option
> > +_run_btrfs_util_prog balance start $RET ${SCRATCH_MNT}

This usage depends on the implicit global variable RET, which seems a
bit hard to follow. How about let the new helper return the expected
option string, and use that string in test, either assign it to a local
var or use it in command line directly.

Think about it more, perhaps we can introduce a new helper, e.g.
_run_btrfs_balance, and hide all these details, just call balance with
--full-balance when possible?

Thanks,
Eryu

> >  
> >  checkpoint2=`md5sum $SCRATCH_MNT/tf2`
> >  echo $checkpoint2 >> $seqres.full 2>&1
> > 
> 



