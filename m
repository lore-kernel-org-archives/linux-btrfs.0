Return-Path: <SRS0=LIGD=RL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0F2C43381
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 15:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A12342087C
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Mar 2019 15:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="LaS/pSTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfCHPLe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:11:34 -0500
Received: from newman.cs.utexas.edu ([128.83.139.110]:52569 "EHLO
        newman.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbfCHPLe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2019 10:11:34 -0500
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        (authenticated bits=0)
        by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id x28FBUT0044812
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 8 Mar 2019 09:11:30 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
        s=default; t=1552057891;
        bh=Z6HL52H1bq2wQ4o04OggNHfe9W8I0JCTHffJgFMQrEE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LaS/pSTa30JvL1tesmH1Fyc4N9Qj2lVPCGcXDxTkHC0uZOk0HuWoF3htLmsw5j/pE
         8N77dhQdkjZ0Yxw+Ko7u7aaohn7/m72oSBCLOmA7GQebc9jIcD9Th+2Gsn67t9PP8j
         02nq+4RRzSYvI6Dbzdyz7Ss+L+VLYHL1aJLCrkjU=
Received: by mail-oi1-f181.google.com with SMTP id t206so16084368oib.3
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Mar 2019 07:11:30 -0800 (PST)
X-Gm-Message-State: APjAAAUVFKgqy4YHRxO9Yigsq9NRrto+uFeH33yJ6sZxKf44tJVIrCn3
        irvUWq0DWg81queaQFQjiuqmUlneSJriwyfkvAangg==
X-Google-Smtp-Source: APXvYqx8TezilTGA50XsiijqfujmhjAOEgaz8Ftk7aUWzbQa45xKf5qso4BTyJjM/+ZW/+/9zxLXlPcJ5H4kdWahZig=
X-Received: by 2002:aca:3dd5:: with SMTP id k204mr8660297oia.33.1552057890319;
 Fri, 08 Mar 2019 07:11:30 -0800 (PST)
MIME-Version: 1.0
References: <20190304140622.23997-1-fdmanana@kernel.org> <CAOQ4uxi87QhQHake0L_xVtUYChc3D2kLqho1obq14aG6zCMu6A@mail.gmail.com>
 <20190305005020.GA26298@dastard> <CAOQ4uxgKj8pAKKra9jv+xTb9dOxG-J5fKvJ_6a_iabWR9RbgrQ@mail.gmail.com>
 <20190305223301.GD26298@dastard> <CAOQ4uxggon==2r2hibMvXc4_N4zod+2z0Ycw74eKRn+q1uwYsw@mail.gmail.com>
 <20190306214813.GE26298@dastard> <CAOQ4uxjM0-D8c3KR0ooXYhhUa5+19j_=3XUaXf6vGMbsNhShJw@mail.gmail.com>
 <CA+EzBbCuQJen9hSHf8-JSRGG3VPxo9X4ugscMdKuw_A6isHDUQ@mail.gmail.com> <20190308043503.GJ26298@dastard>
In-Reply-To: <20190308043503.GJ26298@dastard>
From:   Vijay Chidambaram <vijay@cs.utexas.edu>
Date:   Fri, 8 Mar 2019 09:11:19 -0600
X-Gmail-Original-Message-ID: <CAHWVdUWuTXw5=RuJ9eLXZnNGDq_YX0En5EHY1z=-Y6n0MxFFbA@mail.gmail.com>
Message-ID: <CAHWVdUWuTXw5=RuJ9eLXZnNGDq_YX0En5EHY1z=-Y6n0MxFFbA@mail.gmail.com>
Subject: Re: [PATCH] generic: add test for fsync after shrinking truncate and rename
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jayashree Mohan <jayashree2912@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Filipe Manana <fdmanana@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Fri, 08 Mar 2019 09:11:31 -0600 (CST)
X-Virus-Scanned: clamav-milter 0.98.7 at newman
X-Virus-Status: Clean
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Mar 7, 2019 at 10:35 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Mar 07, 2019 at 05:19:51PM -0600, Jayashree Mohan wrote:
> > Hi Amir,
> >
> > > I went back to look at similar fsync tests by Filipe:
> > > generic/{106,107,335,336,341,342,343,348,498,501,502,509,510,512}
> > >
> > > I found some alleged subtle mistakes about SOMC assumptions.
> > >
> > > generic/336 does:
> > > touch $SCRATCH_MNT/a/foo
> > > ln $SCRATCH_MNT/a/foo $SCRATCH_MNT/b/foo_link
> > > touch $SCRATCH_MNT/b/bar
> > > sync
> > > unlink $SCRATCH_MNT/b/foo_link
> > > mv $SCRATCH_MNT/b/bar $SCRATCH_MNT/c/
> > > $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/a/foo
> >
> > This is probably what's happening in this particular test :
> >
> > SOMC requires:
> >           fsync(a/foo) must ensure unlink(b/foo_link)  (because they
> > were linked at some point)
> >
> > But what happens is:
> >            fsync(a/foo)          -->  unlink(b/foo_link)
> >            unlink(b/foo_link)  -->  fsync(b)
> >            fsync(b)                 -->  rename goes through
> >
> > SOMC should only require that the unlink persists.
>
> That's a /fsync/ requirement, not SOMC.
>
> SOMC says:
>
> "If the rename after the fsync()d unlink is present after recovery,
> then every metadata operation completed between the unlink and the
> rename must also be present after recovery."

Isn't this a bit too broad? That sounds more like total ordering of
metadata operations rather than SOMC. Shouldn't SOMC say "all
operations dependent upon the rename should be present after recovery
if rename is present?"
