Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CBEC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 11:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C85420842
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 11:00:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CI23dqCI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfBLLAE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 06:00:04 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39499 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfBLLAE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 06:00:04 -0500
Received: by mail-vs1-f67.google.com with SMTP id e16so1302153vsq.6;
        Tue, 12 Feb 2019 03:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=oaQPCTTN7ZFE3bIcdGYuKv7on3KQkQF0UVzj2xCpxhM=;
        b=CI23dqCIX3P283ZAy50JhbHnGr9a9J2xcyMXXuZoc32NxrVbuoPKQBIgMhNAP8TAAB
         HPN4BwjfUDA9FYSOoTcY6OtXdCki/0Pwdo72dEthbvsk/JxcNsx4ZutAM/v5NehJW53y
         GVc2g+hcmXbnFf+c17m9iWaY1sgtJ0MCCPzTQvFSlQZhKn3rzAOIlCBjpx+PVrS8zQCb
         W9N5FNqniWQFE9F4M75KtI9efY73JMU335D9Wi7Dg+Ll5gZFUf7LWumxOoubGUZ19xgU
         5Wwn90NWVNICd+A42dVsulFqsoA2TYa7BRDzOw7tR/d4aVVprMauAwtcbhb044TGJMRZ
         9L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=oaQPCTTN7ZFE3bIcdGYuKv7on3KQkQF0UVzj2xCpxhM=;
        b=Oc0P92sznJ9l/qACJJKdLj9TBPVb/8A0Eix+8NN7DGMXDom1pQVQQomFGPUgagYnsX
         yngrbep4IJBtSXhrAw6Hf9mZMvwahlgZ4//g/Kk5lcJTJryCdqFM9c5wqSgnPz/NCvmC
         pm/nw6/1DJnSwnNADPupFXK8aQLl3NFUjtjjGOnPd/iVAoDSP7aI/JrZnwcjn+96tMqD
         eEh9bMkS+2TuZCq4bYHL6JNHVigtpQh2jvT44DawbkngF/Y0OagJ7er5DkAnLQUl86cd
         JW06ioE4vttchGQMQnnxp2sjjHE6jTcMewUsg9o10hYDBWM2M4uRwvmNW0x2RlYJwQ/y
         xC+A==
X-Gm-Message-State: AHQUAuY46ksKvqGonEXtSuqzv9GDiWBMB9snA9Y/BjXjJNZRgD/gPx5/
        FPDZZH/m10dBbOOMQn32Q/NEZYmWuoB1TCJK0TM=
X-Google-Smtp-Source: AHgI3IZ8bguqmSIW7Mm0FlY11mqzXKbrs4TeR50dzhvfEr9kIo7DJkkG5SSP4mo093yRr7cUtl/4bQ/UcDoiKoGt9/o=
X-Received: by 2002:a67:ecc6:: with SMTP id i6mr791990vsp.14.1549969202972;
 Tue, 12 Feb 2019 03:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20190111050151.982-1-wqu@suse.com> <bd51a34e-0d80-0e89-36cd-6256c77067ab@gmx.com>
In-Reply-To: <bd51a34e-0d80-0e89-36cd-6256c77067ab@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 12 Feb 2019 10:59:51 +0000
Message-ID: <CAL3q7H6bm0yWdQ4La0vk2C+n5+++9kPhxe-A3WyaN3j2HFyX4A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 12, 2019 at 5:14 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/1/11 =E4=B8=8B=E5=8D=881:01, Qu Wenruo wrote:
> [snip]
> > +# FS QA Test 179
> > +#
> > +# Test if btrfs will lockup at subvolume deletion when qgroups are ena=
bled.
> > +#
> > +# This bug is going to be fixed by a patch for the kernel titled
> > +# "btrfs: qgroup: Don't trigger backref walk at delayed ref insert tim=
e".
>
> Although the test case is already merged, btrfs community is going to
> use a much better fix than this.
>
> Should I update the patch in this test case after the fix get merged
> upstream?

Yes please. Why shouldn't it be updated? It makes no sense to leave a
stale comment.

>
> Thanks,
> Qu
>
> > +#
> > +seq=3D`basename $0`
> > +seqres=3D$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=3D`pwd`
> > +tmp=3D/tmp/$$
> > +status=3D1     # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +     cd /
> > +     rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +# default sleep interval
> > +sleep_time=3D1
> > +
> > +# stress test runtime
> > +runtime=3D120
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount
> > +
> > +mkdir -p "$SCRATCH_MNT/snapshots"
> > +$BTRFS_UTIL_PROG subvolume create "$SCRATCH_MNT/src" > /dev/null
> > +$BTRFS_UTIL_PROG quota enable "$SCRATCH_MNT" > /dev/null
> > +$BTRFS_UTIL_PROG quota rescan -w "$SCRATCH_MNT" > /dev/null
> > +
> > +fill_workload()
> > +{
> > +     trap "wait; exit" SIGTERM
> > +     local i=3D0
> > +     while true; do
> > +             _pwrite_byte 0xcd 0 8K "$SCRATCH_MNT/src/large_$i" > /dev=
/null
> > +             _pwrite_byte 0xcd 0 2K "$SCRATCH_MNT/src/inline_$i" > /de=
v/null
> > +
> > +             # Randomly remove some files for every 5 loop
> > +             if [ $(( $i % 5 )) -eq 0 ]; then
> > +                     victim=3D$(ls "$SCRATCH_MNT/src" | sort -R | head=
 -n1)
> > +                     rm "$SCRATCH_MNT/src/$victim"
> > +             fi
> > +             i=3D$((i + 1))
> > +     done
> > +}
> > +
> > +snapshot_workload()
> > +{
> > +     trap "wait; exit" SIGTERM
> > +     local i=3D0
> > +     while true; do
> > +             sleep $sleep_time
> > +             $BTRFS_UTIL_PROG subvolume snapshot "$SCRATCH_MNT/src" \
> > +                     "$SCRATCH_MNT/snapshots/$i" > /dev/null
> > +             i=3D$((i + 1))
> > +     done
> > +}
> > +
> > +delete_workload()
> > +{
> > +     trap "wait; exit" SIGTERM
> > +     while true; do
> > +             sleep $((sleep_time * 2))
> > +             victim=3D$(ls "$SCRATCH_MNT/snapshots" | sort -R | head -=
n1)
> > +             $BTRFS_UTIL_PROG subvolume delete \
> > +                     "$SCRATCH_MNT/snapshots/$victim" > /dev/null
> > +     done
> > +}
> > +
> > +fill_workload &
> > +fill_pid=3D$!
> > +
> > +sleep $((sleep_time * 2))
> > +snapshot_workload &
> > +snapshot_pid=3D$!
> > +delete_workload &
> > +delete_pid=3D$!
> > +
> > +sleep $runtime
> > +kill $fill_pid
> > +wait $fill_pid
> > +kill $snapshot_pid
> > +wait $snapshot_pid
> > +kill $delete_pid
> > +wait $delete_pid
> > +
> > +# success, all done
> > +echo "Silence is golden"
> > +
> > +status=3D0
> > +exit
> > diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
> > new file mode 100644
> > index 000000000000..cb9eba3d34b1
> > --- /dev/null
> > +++ b/tests/btrfs/179.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 179
> > +Silence is golden
> > diff --git a/tests/btrfs/group b/tests/btrfs/group
> > index 04c0254aa4bf..46dd3c9523c2 100644
> > --- a/tests/btrfs/group
> > +++ b/tests/btrfs/group
> > @@ -181,3 +181,4 @@
> >  176 auto quick swap volume
> >  177 auto quick swap balance
> >  178 auto quick send
> > +179 auto qgroup dangerous
> >
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
