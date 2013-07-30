Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:44151 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756954Ab3G3Svs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 14:51:48 -0400
Date: Tue, 30 Jul 2013 13:51:47 -0500
From: Ben Myers <bpm@sgi.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Josef Bacik <jbacik@fusionio.com>, sandeen@redhat.com,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: generic/315: allow a little tolerance for
 our used check
Message-ID: <20130730185147.GP3111@sgi.com>
References: <1375124156-17620-1-git-send-email-jbacik@fusionio.com>
 <51F7377A.9090707@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51F7377A.9090707@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 30, 2013 at 11:48:10AM +0800, Jeff Liu wrote:
> On 07/30/2013 02:55 AM, Josef Bacik wrote:
> 
> > So df in btrfs is tricky at best, and relying on it for accurate information is
> > not great, but it's the best way to verify this test.  To get around btrfs being
> > inconsistent sometimes just use _within_tolerance to check our new df value to
> > make sure that our truncate did something.  With this patch I no longer see
> > transient failures of this test.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> >  tests/generic/315 |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tests/generic/315 b/tests/generic/315
> > index 7cfc40d..9c01b5e 100644
> > --- a/tests/generic/315
> > +++ b/tests/generic/315
> > @@ -73,7 +73,8 @@ sync
> >  
> >  # Preallocated disk space should be released
> >  avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
> > -[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
> > +_within_tolerance "df" $avail_done $avail_begin 1%
> > +[ $? -eq 0 ] || _fail "Available disk space ($avail_done KiB) wanted ($avail_begin KiB)"
> 
> Looks good to me.
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Applied.
