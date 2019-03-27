Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE3DC10F00
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4554A205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 18:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="aBdw9hs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390321AbfC0Sw3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:52:29 -0400
Received: from mail-lj1-f180.google.com ([209.85.208.180]:40910 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbfC0Sw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 14:52:28 -0400
Received: by mail-lj1-f180.google.com with SMTP id q66so15402730ljq.7
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 11:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b42tIjBoDy2wy2HvGpYTw31uSZmME6eWFtfz+Hb9Ubc=;
        b=aBdw9hs3q8xk21Bdj+K2QkjOZfj3OYXHF4elfFWLR0C3sXCjmM03Jd4aZzqfjowSrP
         8t84gsn0huq8zT2exAl966E/zIercs0BUsHUcXe1wXBZ8oi5dPG68rkFo94XGi5LLcc3
         yqJO1rInYLcHOdlXytmcp6qRnHTi5+1Bgn7mgqkJiNSyiyZ1Ccd4q8jKdVaaubIHpuxS
         sNuQtk6RywIx8UBlovZOposnODuYC2D4VfF52gxUbAD7HiKjdDoBhF81yc4r+J6nKTbB
         xb3xUZtPQQjkbKWtf/zOhWmxmye5z79UpGxAv+GEGjHauAQSsrAQo61vsBYFsOE+phRx
         +jBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b42tIjBoDy2wy2HvGpYTw31uSZmME6eWFtfz+Hb9Ubc=;
        b=SGVK2i7jTmhrcoV5oRbxf671tDlqV0eHXT6yZb12G0axkBDGF8f3Ee+JWx9hnGAqbk
         EfF1Nt4L8Pl4pAss69aI77pjLPzyLTDhRBLSet5X530WAuGrt+aT5U1ch+X/uYX+TMfW
         WmABZxIylbhCyrEP0dsdFA8fZfzVDtJoo0m46JPH9Rwxsabz4EbtUxfMUZxOXoyFZEKe
         9rp+yasN5Xg5ZxM9MeOPASgsnc+mY/fwdZZf98B+ZJJDfSDkaaf04hE9Ads9cN9Y6nPD
         lIHHq1dsVSRI3ELcq/sbIuq6fIkZ2QAJtnVxBX0gCxnPo4mmGi1M/ea6Zaw9mwrMLmUx
         CLTA==
X-Gm-Message-State: APjAAAWgGJxITiBp6wI04kJqN151bDdJyoPkn9S23CLeI3jiY134J+If
        ciO+ulbatY/01yWlbpTMCpnHHbhtWXt4xvPShFNq3A==
X-Google-Smtp-Source: APXvYqzwh2hqny2XWJOTl1r+4gncunupAbNmjKs9IkVGSi3HLG3kzWBKod/KbZx4q4trioHv8uQtmeBQU+60qcdWcBQ=
X-Received: by 2002:a2e:8582:: with SMTP id b2mr6262657lji.24.1553712746510;
 Wed, 27 Mar 2019 11:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com> <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
 <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com> <DCcsgRDYyXTQg-tb_c9lhjSkEpt42ZH7R--Ln36pZpkNgAiQr54J8xLiGURKXVYv5fuQrAZA8xSD65ykmwyjCmPJYwAnAQFCU1uQWlZo6H4=@protonmail.com>
In-Reply-To: <DCcsgRDYyXTQg-tb_c9lhjSkEpt42ZH7R--Ln36pZpkNgAiQr54J8xLiGURKXVYv5fuQrAZA8xSD65ykmwyjCmPJYwAnAQFCU1uQWlZo6H4=@protonmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 27 Mar 2019 12:52:15 -0600
Message-ID: <CAJCQCtREkeL3ANoYnar+viosPxzvKenPNAxSw10ov=R-pJNp3g@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_backup_uuid=5Ftree_generation_not_consistent_acros?=
        =?UTF-8?Q?s_multi_device_=28raid0=29_btrfs_=2D_won=C2=B4t_mount?=
To:     berodual_xyz <berodual_xyz@protonmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 7:03 AM berodual_xyz
<berodual_xyz@protonmail.com> wrote:
> My questions now:
>
> * what is the chance of "btrfs rescue" "chunk-recover" / "super-recover" / "zero-log" having a positive effect on the filesystem.
>
> * what is the chance of "btrfs check --init-extent-tree" fixing the described issues?

You are using btrfs-progs 4.20.2 and it crashes doing a `btrfs check`.
That's a significant bug.

That tool shouldn't crash, so it already means the file system is in
an inconsistent state that btrfs-progs hasn't seen before, and it gets
so confused that it crashes. I have 0% confidence that any repair that
writes changes to the filesystem will succeed, and better than 99%
confidence that it will crash in the middle of a repair and absolutely
make the file system non-recoverable. All of the repair options you
listed above write changes to the file system, also add `btrfs check
--repair` to that list.

So until you get advice from a developer, you're sitting on that file
system. *shrug*

In the meantime, your best bet is a combination of 'btrfs restore' and
mounting with `-o ro,nologreplay,usebackuproot`. Once those fail to
get you anywhere you're basically stuck, as that's the limit of the
repair tools at this point. You could also in the meantime do a scrub
on all of the raid6 arrays, and whatever other diagnostics or repairs
the hardware raid offers. They *should* recover properly on their own,
but...

And then also in the meantime, prepare for having to rebuild this array.

-- 
Chris Murphy
