Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A5FC46462
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8345E2098A
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 18:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qK9RiMCA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8345E2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbeJKBwJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:52:09 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46111 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJKBwJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 21:52:09 -0400
Received: by mail-yw1-f66.google.com with SMTP id j202-v6so2551103ywa.13;
        Wed, 10 Oct 2018 11:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+jCY+uUWC/JY/tJakwQ409L5L0ga67J4qj0j9F1M0f4=;
        b=qK9RiMCADlSjpcXotiJRoV5hjWs6D00Vf8XfE98nkH6A9k9OWVWTXh0obvDPOkhOqv
         qATAsTIJi4XdXedT1ToKP7Ox24cQ1YbpQcjGj4pGnTOcwAgdsh7TyjtNfMqmOEzwbG5V
         IMaDN5mAPV/t/haU7a6rXKwGg3OIaGVOJc77yH8VSq/NR1RTuxGqFXiNweKGoSCqvfbN
         xwr4ndcpvBIWJsNQ34qDz7uNzLHn4KFttiYJPQfHYH38UATICcVQbDxQy04xBuCWqzRX
         UVgDO2jaONiddQcOOKPxp3d+CbxUXZ+Vs+sK74JutrVtlw3RoF6USbzJGraKp0wll/bc
         hc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+jCY+uUWC/JY/tJakwQ409L5L0ga67J4qj0j9F1M0f4=;
        b=mcCQPXrT42RoyzxAzrHOjHMKKoUZ1Sr8F1wShQloob4rbJukrkKDfYewOukFhm0vgs
         4JjZbt5mgo7qZzYNU+sgYAgKv51opt8emdhthNv7ZDRb9495dJoKMowS8mGOo4WyXEbC
         2wYUdE9ow/4LAlaB9nhIcdo4148exBqP7thVIG19bDgocUb/8si/0CO8rxKg3khsKvwy
         FsRwVQoMwXUQ5BezB+BhUSsrDERKoSDJQX/mrsqvUO5/y7JK0ghB5mE6u7/5DclO2oDm
         tjW34yZCrgmaaeV1+DA3t2G4dTah6slnENOQ4Na+OlCBvCxEqfiLZNeR8F1d8Zo272AW
         Z19g==
X-Gm-Message-State: ABuFfojEVXtXcEhGv53pjMXjd6mYgGz1uWb0vRdggaA9889CtHt5bwOi
        CV6Is2nzpMRd0k7C7CWgOpLmaSLHwKmLxlHJKpBTMtp3
X-Google-Smtp-Source: ACcGV62ijZVJMWCXX9F3Fr1zq61depYu+YA2mTU9siPS1m2JXbdk3GL8WoyU8FK/CG9dbrd9xqS2+LMl9VLTF/Yf0Io=
X-Received: by 2002:a81:6505:: with SMTP id z5-v6mr2100545ywb.34.1539196127449;
 Wed, 10 Oct 2018 11:28:47 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913040858.32295.9474188640729118153.stgit@magnolia> <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
 <20181010155055.GS28243@magnolia>
In-Reply-To: <20181010155055.GS28243@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 21:28:34 +0300
Message-ID: <CAOQ4uxjsKZHxoYqbnJTxQ1SPGn7o_2QhYseuETHnvZxvgCV5vg@mail.gmail.com>
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
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

On Wed, Oct 10, 2018 at 6:51 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 09:47:00AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Change the remap_file_range functions to take a number of bytes to
> > > operate upon and return the number of bytes they operated on.  This is a
> > > requirement for allowing fs implementations to return short clone/dedupe
> > > results to the user, which will enable us to obey resource limits in a
> > > graceful manner.
> > >
> > > A subsequent patch will enable copy_file_range to signal to the
> > > ->clone_file_range implementation that it can handle a short length,
> > > which will be returned in the function's return value.  Neither clone
> > > ioctl can take advantage of this, alas.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
[...]
> > Commit message wasn't clear enough on the behavior of copy_file_range()
> > before and after the patch IMO. Maybe it would be better to pospone this
> > semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
> > in this patch?
>
> There shouldn't be any behavior change here -- all implementations
> return a negative error code or the length that was passed in.  I'll
> clarify that in the commit message.
>

OK. BTW, you forgot to update Documentation/filesystems/vfs.txt.

Also since this series has a potential to break clone/dedup on
overlayfs, it would be great if you could run some of the clone/dedupe
xfstests with overlay over xfs.

For the simple case of running ./check with a local.config file that is
not multi section, this just means running ./check -overlay after the
first ./check run (-overlay doesn't mkfs the base fs).

If this is a problem, let me know once new devel branch is ready
and I'll pull it for testing. If I need to pull in extra xfstests, please
mention that as well.

Thanks,
Amir.
