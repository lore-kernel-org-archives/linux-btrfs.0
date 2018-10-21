Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA10ECDE43
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 09:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DEBF20838
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 09:31:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HsTznG4G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DEBF20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbeJURpZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 13:45:25 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:39493 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbeJURpZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 13:45:25 -0400
Received: by mail-vs1-f68.google.com with SMTP id m5so27805175vsk.6;
        Sun, 21 Oct 2018 02:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=QBLUGbFci5KrNNymi2yT8ntnXUV4JOG+Xiz/x+0CXPg=;
        b=HsTznG4GLxsHFON0tttkx6R5V123DM1Ozgs0mEhuu9Ea3z13TRPGMHcIYfDgPYSeYL
         HttPzaA9tuuGTTkgKwfgfYoCseIKGU8nnz2W7o/Br+wEI8YBT7nBz02gMQacm4Od93A9
         l5zliyuI59fK9R8xdJaTzhFb66nf3SQNGYaSkIi3oqDBUaHA5LZG65sJM9Idak4ZlKfU
         QyDVIuVQgha7ODgu4XoFHLT9iIfCiAL5mcOaIMmxFUVqrKydzPFn3BfVGXsq+g/5HFgJ
         Fnr+GeyRF5XZlPUPEj/kA/Yfda2DlYpK6PNrDNgt0rWilrXLvtcz0XKQ12gaNZCeT9Fn
         kBzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=QBLUGbFci5KrNNymi2yT8ntnXUV4JOG+Xiz/x+0CXPg=;
        b=X1HGnsz/nDS4H+UsqHYGj1N4SuEEz86KK54nbXuoESjFn3vLE324mFNSwSfbChx6Cr
         ehGHzHJnVxC4YZuIX5YPf+fKOBVpdl1SmFlPaDlJB8QClID8SD/m+TrZk6246gGp8OEm
         nKBuN3lHW3RAIU+7IzbIrvuMLtgSkFjimCjSgMBcbODbpvqoKUSe1hpc5cXpHiRUYRzU
         D+XsQFiRWLo1Df5g41OYUjskbKtvyAmp1PwaoRtWW5I6SXO7W78bv690QzMUoHSwPMXc
         3sHi0fDHJRRyWhj7TjUvOFrfycJU5RXt/bCtq+jfw9IG5nmixinTTxyiexjX7yxQvfNR
         Xk+A==
X-Gm-Message-State: ABuFfoi6BooahVPu7mU4x1aQ85GMwexlsZY+CZKV9H4mLGGC1i+PFJmO
        8/V1UA200FcpyFRvDNktsMJvOa7MBQV7KX01uAY=
X-Google-Smtp-Source: ACcGV60dtcIxD2n7t4rIKT8SGS6RVYO3LxStiRH9RgDql1V4nIMqJBUh1uZpN7n44UCtKxmWZAvNPV+lvEBjnaKaBnQ=
X-Received: by 2002:a67:4482:: with SMTP id y2mr16910077vsf.90.1540114303030;
 Sun, 21 Oct 2018 02:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <20171113022541.7413-1-anand.jain@oracle.com> <CAL3q7H41dQpiVaCyre3sCgAaVXd19-cWbLO68z4ovJz2F1E2-g@mail.gmail.com>
 <a83fb0ce-dff8-9389-2371-f2e7a5164153@suse.com>
In-Reply-To: <a83fb0ce-dff8-9389-2371-f2e7a5164153@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Sun, 21 Oct 2018 10:31:31 +0100
Message-ID: <CAL3q7H7inq5UCgihaP8i+9NOGiSvDGc6ndphMyuONc6OTJFtiw@mail.gmail.com>
Subject: Re: [PATCH] btrfs/154: test for device dynamic rescan
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>,
        fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 21, 2018 at 10:20 AM Nikolay Borisov <nborisov@suse.com> wrote:
>
>
>
> On 21.10.2018 10:16, Filipe Manana wrote:
> > On Mon, Nov 13, 2017 at 2:26 AM Anand Jain <anand.jain@oracle.com> wrot=
e:
> >>
> >> Make sure missing device is included in the alloc list when it is
> >> scanned on a mounted FS.
> >>
> >> This test case needs btrfs kernel patch which is in the ML
> >>   [PATCH] btrfs: handle dynamically reappearing missing device
> >> Without the kernel patch, the test will run, but reports as
> >> failed, as the device scanned won't appear in the alloc_list.
> >
> > So that patch was never merged, at least not with that subject.
> > What happened?
>
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/btrfs/1=
54
>
> In my testing of misc-next this test has been failing for me.

Yes, that's why I'm asking.
It's not uncommon for Anand to submit tests that never get the
corresponding kernel patch merged or, like in his recent hole punch
test, that doesn't have a corresponding kernel fix.

Anand, what's the deal here? Are you planning on pushing the fixes to
the kernel? And for the hole punch test, are you working on a fix or
just hoping someone else will fix it?

> >
> >>
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >>  tests/btrfs/154     | 188 +++++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  tests/btrfs/154.out |  10 +++
> >>  tests/btrfs/group   |   1 +
> >>  3 files changed, 199 insertions(+)
> >>  create mode 100755 tests/btrfs/154
> >>  create mode 100644 tests/btrfs/154.out
> >>
> >> diff --git a/tests/btrfs/154 b/tests/btrfs/154
> >> new file mode 100755
> >> index 000000000000..8b06fc4d9347
> >> --- /dev/null
> >> +++ b/tests/btrfs/154
> >> @@ -0,0 +1,188 @@
> >> +#! /bin/bash
> >> +# FS QA Test 154
> >> +#
> >> +# Test for reappearing missing device functionality.
> >> +#   This test will fail without the btrfs kernel patch
> >> +#   [PATCH] btrfs: handle dynamically reappearing missing device
> >> +#
> >> +#--------------------------------------------------------------------=
-
> >> +# Copyright (c) 2017 Oracle.  All Rights Reserved.
> >> +# Author: Anand Jain <anand.jain@oracle.com>
> >> +#
> >> +# This program is free software; you can redistribute it and/or
> >> +# modify it under the terms of the GNU General Public License as
> >> +# published by the Free Software Foundation.
> >> +#
> >> +# This program is distributed in the hope that it would be useful,
> >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> +# GNU General Public License for more details.
> >> +#
> >> +# You should have received a copy of the GNU General Public License
> >> +# along with this program; if not, write the Free Software Foundation=
,
> >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> +#--------------------------------------------------------------------=
-
> >> +#
> >> +
> >> +seq=3D`basename $0`
> >> +seqres=3D$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=3D`pwd`
> >> +tmp=3D/tmp/$$
> >> +status=3D1       # failure is the default!
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +       cd /
> >> +       rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/filter
> >> +. ./common/module
> >> +
> >> +# remove previous $seqres.full before test
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +
> >> +_supported_fs btrfs
> >> +_supported_os Linux
> >> +_require_scratch_dev_pool 2
> >> +_test_unmount
> >> +_require_loadable_fs_module "btrfs"
> >> +
> >> +_scratch_dev_pool_get 2
> >> +
> >> +DEV1=3D`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> >> +DEV2=3D`echo $SCRATCH_DEV_POOL | awk '{print $2}'`
> >> +
> >> +echo DEV1=3D$DEV1 >> $seqres.full
> >> +echo DEV2=3D$DEV2 >> $seqres.full
> >> +
> >> +# Balance won't be successful if filled too much
> >> +DEV1_SZ=3D`blockdev --getsize64 $DEV1`
> >> +DEV2_SZ=3D`blockdev --getsize64 $DEV2`
> >> +
> >> +# get min
> >> +MAX_FS_SZ=3D`echo -e "$DEV1_SZ\n$DEV2_SZ" | sort | head -1`
> >> +# Need disks with more than 2G
> >> +if [ $MAX_FS_SZ -lt 2000000000 ]; then
> >> +       _scratch_dev_pool_put
> >> +       _test_mount
> >> +       _notrun "Smallest dev size $MAX_FS_SZ, Need at least 2G"
> >> +fi
> >> +
> >> +MAX_FS_SZ=3D100000000
> >> +bs=3D"1M"
> >> +COUNT=3D$(($MAX_FS_SZ / 1000000))
> >> +CHECKPOINT1=3D0
> >> +CHECKPOINT2=3D0
> >> +
> >> +setup()
> >> +{
> >> +       echo >> $seqres.full
> >> +       echo "MAX_FS_SZ=3D$MAX_FS_SZ COUNT=3D$COUNT" >> $seqres.full
> >> +       echo "setup"
> >> +       echo "-----setup-----" >> $seqres.full
> >> +       _scratch_pool_mkfs "-mraid1 -draid1" >> $seqres.full 2>&1
> >> +       _scratch_mount >> $seqres.full 2>&1
> >> +       dd if=3D/dev/urandom of=3D"$SCRATCH_MNT"/tf bs=3D$bs count=3D1=
 \
> >> +                                       >>$seqres.full 2>&1
> >> +       _run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
> >> +       _run_btrfs_util_prog filesystem df $SCRATCH_MNT
> >> +       COUNT=3D$(( $COUNT - 1 ))
> >> +       echo "unmount" >> $seqres.full
> >> +       _scratch_unmount
> >> +}
> >> +
> >> +degrade_mount_write()
> >> +{
> >> +       echo >> $seqres.full
> >> +       echo "--degraded mount: max_fs_sz $max_fs_sz bytes--" >> $seqr=
es.full
> >> +       echo
> >> +       echo "degraded mount"
> >> +
> >> +       echo "clean btrfs ko" >> $seqres.full
> >> +       # un-scan the btrfs devices
> >> +       _reload_fs_module "btrfs"
> >> +       _mount -o degraded $DEV1 $SCRATCH_MNT >>$seqres.full 2>&1
> >> +       cnt=3D$(( $COUNT/10 ))
> >> +       dd if=3D/dev/urandom of=3D"$SCRATCH_MNT"/tf1 bs=3D$bs count=3D=
$cnt \
> >> +                                       >>$seqres.full 2>&1
> >> +       COUNT=3D$(( $COUNT - $cnt ))
> >> +       _run_btrfs_util_prog filesystem show -m $SCRATCH_MNT
> >> +       _run_btrfs_util_prog filesystem df $SCRATCH_MNT
> >> +       CHECKPOINT1=3D`md5sum $SCRATCH_MNT/tf1`
> >> +       echo $SCRATCH_MNT/tf1:$CHECKPOINT1 >> $seqres.full 2>&1
> >> +}
> >> +
> >> +scan_missing_dev_and_write()
> >> +{
> >> +       echo >> $seqres.full
> >> +       echo "--scan missing $DEV2--" >> $seqres.full
> >> +       echo
> >> +       echo "scan missing dev and write"
> >> +
> >> +       _run_btrfs_util_prog device scan $DEV2
> >> +
> >> +       echo >> $seqres.full
> >> +
> >> +       _run_btrfs_util_prog filesystem show -m ${SCRATCH_MNT}
> >> +       _run_btrfs_util_prog filesystem df ${SCRATCH_MNT}
> >> +
> >> +       dd if=3D/dev/urandom of=3D"$SCRATCH_MNT"/tf2 bs=3D$bs count=3D=
$COUNT \
> >> +                                               >>$seqres.full 2>&1
> >> +       CHECKPOINT2=3D`md5sum $SCRATCH_MNT/tf2`
> >> +       echo $SCRATCH_MNT/tf2:$CHECKPOINT2 >> $seqres.full 2>&1
> >> +}
> >> +
> >> +balance_convert()
> >> +{
> >> +       echo >> $seqres.full
> >> +       echo "----- run balance -----" >> $seqres.full
> >> +       echo
> >> +       echo "run balance"
> >> +
> >> +       _run_btrfs_util_prog bal start --full-balance -dconvert=3Draid=
1 \
> >> +                               -mconvert=3Draid1 ${SCRATCH_MNT}
> >> +}
> >> +
> >> +verify()
> >> +{
> >> +       echo >> $seqres.full
> >> +       echo "--mount reconstructed dev only and check md5sum--" >> $s=
eqres.full
> >> +       echo
> >> +       echo "mount reconstructed dev only and check md5sum"
> >> +       echo "unmount" >> $seqres.full
> >> +
> >> +       _scratch_unmount
> >> +       _reload_fs_module "btrfs"
> >> +       _mount -o degraded $DEV2 $SCRATCH_MNT >>$seqres.full 2>&1
> >> +       verify_checkpoint1=3D`md5sum $SCRATCH_MNT/tf1`
> >> +       verify_checkpoint2=3D`md5sum $SCRATCH_MNT/tf2`
> >> +
> >> +       if [ "$verify_checkpoint1" !=3D "$CHECKPOINT1" ]; then
> >> +               echo "checkpoint1 does not match with after scrub"
> >> +       fi
> >> +
> >> +       if [ "$verify_checkpoint2" !=3D "$CHECKPOINT2" ]; then
> >> +               echo "checkpoint2 does not match with after scrub"
> >> +       fi
> >> +}
> >> +
> >> +setup
> >> +degrade_mount_write
> >> +scan_missing_dev_and_write
> >> +balance_convert
> >> +verify
> >> +
> >> +$UMOUNT_PROG $DEV2
> >> +_scratch_dev_pool_put
> >> +_test_mount
> >> +
> >> +status=3D0
> >> +exit
> >> diff --git a/tests/btrfs/154.out b/tests/btrfs/154.out
> >> new file mode 100644
> >> index 000000000000..4a4939d448aa
> >> --- /dev/null
> >> +++ b/tests/btrfs/154.out
> >> @@ -0,0 +1,10 @@
> >> +QA output created by 154
> >> +setup
> >> +
> >> +degraded mount
> >> +
> >> +scan missing dev and write
> >> +
> >> +run balance
> >> +
> >> +mount reconstructed dev only and check md5sum
> >> diff --git a/tests/btrfs/group b/tests/btrfs/group
> >> index 15c2ecbf553c..c98cf823224e 100644
> >> --- a/tests/btrfs/group
> >> +++ b/tests/btrfs/group
> >> @@ -156,3 +156,4 @@
> >>  151 auto quick
> >>  152 auto quick metadata qgroup send
> >>  153 auto quick qgroup
> >> +154 auto quick
> >> --
> >> 2.13.1
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> >



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
