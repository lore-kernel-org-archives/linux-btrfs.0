Return-Path: <SRS0=ObWa=RI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A30C43381
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 01:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAAE3206B6
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Mar 2019 01:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="nbs4e/Xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfCEBLw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Mar 2019 20:11:52 -0500
Received: from newman.cs.utexas.edu ([128.83.139.110]:40769 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfCEBLw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2019 20:11:52 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2019 20:11:51 EST
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id x2518GGY008507
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2019 19:08:17 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1551748097;
        bh=Bcc2bZuCKLQOcQPsctJx/i2WfZRdII4KCMvNgFLcIoM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nbs4e/XnwMGG+gG5BjheWsVBDh0MBzOJjM3D5L1uWSApyhoird0wB6PV+q6w2mwr7
         b40b/7TzPIXkq0bkm1sr7ZNPsI1yHIFJQaZpIxMEDscFKvgZujMfzfRKdqk876M84x
         nrhdDtPc8KX4vLN73wHXfEW37j87uXYQEXO8p2+s=
Received: by mail-ot1-f41.google.com with SMTP id z19so6002872otm.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2019 17:08:17 -0800 (PST)
X-Gm-Message-State: APjAAAUiS8jhiWtAqFhQIxcWDm70asmc/OzgQUIOxhp+KrvY2xywyBFf
        QWVON5SF3C9gjJG3r51I/Zg57RHRhPzxqD7SnXo+Hw==
X-Google-Smtp-Source: APXvYqypWYW9PMsSpLDQpuQOUtwZ7nDT4j3n3Wp4toa8HgkSM6O4Gf9ItaFuBcFVaMR6ztWYic+NESE8lI4sN/hqe8U=
X-Received: by 2002:a9d:7a87:: with SMTP id l7mr13775572otn.98.1551748096637;
 Mon, 04 Mar 2019 17:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard> <20190305010031.GB26298@dastard>
In-Reply-To: <20190305010031.GB26298@dastard>
From:   Vijay Chidambaram <vijay@cs.utexas.edu>
Date:   Mon, 4 Mar 2019 19:08:05 -0600
X-Gmail-Original-Message-ID: <CAHWVdUXMXtvncVQSqO8vdowct+GYE1nENePNvFJFjvoWzSHMcw@mail.gmail.com>
Message-ID: <CAHWVdUXMXtvncVQSqO8vdowct+GYE1nENePNvFJFjvoWzSHMcw@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Mon, 04 Mar 2019 19:08:17 -0600 (CST)
X-Virus-Scanned: clamav-milter 0.98.7 at newman
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 4, 2019 at 7:00 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Mar 05, 2019 at 11:50:20AM +1100, Dave Chinner wrote:
> > On Mon, Mar 04, 2019 at 05:04:23PM +0200, Amir Goldstein wrote:
> > > On Mon, Mar 4, 2019 at 4:44 PM <fdmanana@kernel.org> wrote:
> > > >
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > Test that if we truncate a file to reduce its size, rename it and then
> > > > fsync it, after a power failure the file has a correct size and name.
> > > >
> > >
> > > I am not sure that ext4/xfs semantics guaranty anything about
> > > persisting file name after fsync of file?...
> >
> > They do.  It's that pesky "strictly ordered metadata" thing I keep
> > having to explain to people...
>
> https://marc.info/?l=fstests&m=155010885626284&w=2

With reference to that previous conversation, Jayashree and I are
planning to submit a patch adding something like
Documentation/filesystems/crash-recovery.txt to document crash
guarantees and strictly ordered metadata semantics soon! So hopefully
there will be in-kernel documentation we can point folks to soon.
