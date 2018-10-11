Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1357C46463
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 08:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F3A821476
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 08:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8eVA7T8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F3A821476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbeJKQAY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:00:24 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44035 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbeJKQAY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 12:00:24 -0400
Received: by mail-yb1-f194.google.com with SMTP id x5-v6so3284907ybl.11;
        Thu, 11 Oct 2018 01:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pe5C3jF+rcUHLGOE9Jt8yexc7ImFSTmHCIuaEB1p1vw=;
        b=W8eVA7T8ND4AfSkrSnnpHXM8zRbwz95GpJFaAm1W9W2JyLF8GfwVBb+0p/qmEgO/zD
         EVB/4azj/Ald5QEnjGNeyT3GlPcSMcx3Dv9HFpWKHv85Px4wuo+XZv6vTp7J2vgA1cz6
         eIg+JVJnBpsNk8xw5Lihlpl5rp1VSbBpkqDSC7SfjnTxsfSk7M6R7KNVyG+i5owZ8PzY
         6Mfb8t837qo6GV9xRWv7r7b+vwwAtAR8fEcraZfbkDdJft5EXhgX91k26AbPS+bV1+fR
         QSyrRC9I7TRO8xoBlhiZl7XxY1muQzxE3Nwvw6MgBHQuU0MJop1pjDsyg9XLgFkRxUhQ
         4S1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pe5C3jF+rcUHLGOE9Jt8yexc7ImFSTmHCIuaEB1p1vw=;
        b=WRpjWDyZEfmR4Fw080grKgO4SHqPC0yzor7UCnfaXkiOkQZWjxXghNuWnNlpX/cFbc
         kXsampmVyPDdk1MwcBI2TYI8pwRMN1sehcyP3LRJGgZ7DC9JQESgfCWaQQnvKCVEXU2u
         GA0iqf8TA6pPcNVLF6rjfhULWd0BX6L1afAsFIiWp3HJa9N53RBAXvROfSlJABrTr+bL
         D4RdTa+gR0Hv23n6CoxxtP4aOStqJGUvzwMGI+RzvIHeiQgqdZ4CjT0twM+7tErzGaCC
         OZ9pIf2uByApJ16+CIY24XIvwUC4XZ3HNshl0voCXEoS611hIzwg3mJZ63JCfAMBmKfL
         89uA==
X-Gm-Message-State: ABuFfoia9BV7q6K46SqZN/vuUn0IIE4dtMaIuj4DZAdNEY3/mvN4wRNv
        q8N4GFLbpPaH92qiq0uDgkoOG81FbU0Jh7h5js56p82zcD0=
X-Google-Smtp-Source: ACcGV62AXOhovezbzjoJ4X6dYOBWHXDKoACX9hE8fmalNB4u/cqj9TQWM2PHXBmG9XUct3Iu+WB26HQ9A0YPZlBs0+s=
X-Received: by 2002:a5b:f03:: with SMTP id x3-v6mr264241ybr.462.1539246849010;
 Thu, 11 Oct 2018 01:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 11 Oct 2018 11:33:57 +0300
Message-ID: <CAOQ4uxgOvOOnKL5TsC9jpjBsepAgtQ56Hhjh7WDeXM7m0=dz7g@mail.gmail.com>
Subject: Re: [PATCH v3 00/25] fs: fixes for serious clone/dedupe problems
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 7:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> Hi all,
>
> Dave, Eric, and I have been chasing a stale data exposure bug in the XFS
> reflink implementation, and tracked it down to reflink forgetting to do
> some of the file-extending activities that must happen for regular
> writes.
>
> We then started auditing the clone, dedupe, and copyfile code and
> realized that from a file contents perspective, clonerange isn't any
> different from a regular file write.  Unfortunately, we also noticed
> that *unlike* a regular write, clonerange skips a ton of overflow
> checks, such as validating the ranges against s_maxbytes, MAX_NON_LFS,
> and RLIMIT_FSIZE.  We also observed that cloning into a file did not
> strip security privileges (suid, capabilities) like a regular write
> would.  I also noticed that xfs and ocfs2 need to dump the page cache
> before remapping blocks, not after.
>
> In fixing the range checking problems I also realized that both dedupe
> and copyfile tell userspace how much of the requested operation was
> acted upon.  Since the range validation can shorten a clone request (or
> we can ENOSPC midway through), we might as well plumb the short
> operation reporting back through the VFS indirection code to userspace.
>
> So, here's the whole giant pile of patches[1] that fix all the problems.
> This branch is against 4.19-rc7 with Dave Chinner's XFS for-next branch.
> The patch "generic: test reflink side effects" recently sent to fstests
> exercises the fixes in this series.  Tests are in [2].
>
> --D
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel

I tested your branch with overlayfs over xfs.
I did not observe any failures with -g clone except for test generic/937
which also failed on xfs in my test.

I though that you forgot to mention I needed to grab xfsprogs from djwong-devel
for commit e84a9e93 ("xfs_io: dedupe command should only complain
if we don't dedupe anything"), but even with this change the test still fails:

generic/937     - output mismatch (see
/old/home/amir/src/fstests/xfstests-dev/results//generic/937.out.bad)
    --- tests/generic/937.out   2018-10-11 08:23:00.630938364 +0300
    +++ /old/home/amir/src/fstests/xfstests-dev/results//generic/937.out.bad
   2018-10-11 10:54:40.448134832 +0300
    @@ -4,8 +4,7 @@
     39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
     Files 1-2 do not match (intentional)
     (partial) dedupe the middle blocks together
    -deduped XXXX/XXXX bytes at offset XXXX
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    +XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
     Compare sections

One thing that *is* different with overlayfs test is that filefrag crashes
on this same test:

    QA output created by 937
    Create the original files
    35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-937/file1
    39578c21e2cb9f6049b1cf7fc7be12a6  TEST_DIR/test-937/file2
    Files 1-2 do not match (intentional)
    (partial) dedupe the middle blocks together
    XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
    ./tests/generic/937: line 59: 19242 Floating point exception(core
dumped) ${FILEFRAG_PROG} -v $testdir/file1 >> $seqres.full
    ./tests/generic/937: line 60: 19244 Floating point exception(core
dumped) ${FILEFRAG_PROG} -v $testdir/file2 >> $seqres.full

It looks like an overlayfs v4.19-rc1 regression - FIGETBSZ returns zero.
I never noticed this regression before, because none of the generic tests
are using filefrag.

Thanks,
Amir.
