Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E020C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06EB1214DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 17:32:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CBkmDnN3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06EB1214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbeJKAzR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 20:55:17 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:41719 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbeJKAzR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 20:55:17 -0400
Received: by mail-yb1-f195.google.com with SMTP id e16-v6so2526060ybk.8;
        Wed, 10 Oct 2018 10:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DDwFxRqQDYmuMHDA/+z19FzPLGfpk29SXRpkR0rxopQ=;
        b=CBkmDnN3++rb7qsSkyAJcFbemr+6ksxX0NFxqdIXRRZpTprS1i/bmvGZ+ZtjYQCUBx
         q8iB/j84WQhFdrelt4GV6WBo7cNwDM4dvO7HSpUagEcuhepdgvsfm62oX7zZ1DGSCWNd
         wcrWEtcWCouS8P4O/9M6khDC6vgBbIPnxSyAIMMWkdycjxqH0FavoMQt9xRxeJZR7Th6
         DIWlPpnc7esAu+SqIrwCUrHZtEkMpsutWUzJoitq0xHchum3wKcF4TFRz7jWvE7MyP+Q
         AwlsDjPfZUNAW3sMmssKy1YTdtGeC6H6MKsbksPVXkoXCFxOCnDHG58CW2wYix0lMZKD
         LoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DDwFxRqQDYmuMHDA/+z19FzPLGfpk29SXRpkR0rxopQ=;
        b=JqNo5+23lSDWLFBdhvaveVDSH1YWKhS5xQeMidaeyH45bxQbVXjkiGZNibfYIBtJVS
         1ohp9UclHS/iOUGKS2YIkbrXWWsUjgBts1EK5WZpaUJnokRUobAqcFSN3Y9dc8w45A8D
         +sKMlc1M5TWQysVw+q3k70Cn1t5fz+QfdHdg0Xh0P19y1RQ7jXFhZio9vKpVSRz62YPO
         jneye7OOSAFAgC1myfl7zBS3daP/eq5moxXEMhaG4YTqyJ0jc+vc6fqWl805kwr0cjbB
         1148vvKVi/oOZueqUWWkHMKv+Xb209g6Brd+2MnxItwqQehaOKB8DseKtMEhY0sSc+/6
         yijg==
X-Gm-Message-State: ABuFfoj/WCgzbV9ajpSVuneVxh9mMUf8KMMcio8JM/CnS3jSluKKflGb
        BSlRp5iQIVpluv5NwAO9witwjcOvcKqS3lAvfnj5DtkUEtQ=
X-Google-Smtp-Source: ACcGV63cnPl02puylrk5YPhSViJ3732JLB8xyhHQPgX9qgcVYV7rDTvFYHQ98uaLeg8Y0D9EiFeksi3E+znL9z9RMgA=
X-Received: by 2002:a25:5a45:: with SMTP id o66-v6mr20194853ybb.397.1539192727206;
 Wed, 10 Oct 2018 10:32:07 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913043746.32295.17463515265798256890.stgit@magnolia> <CAOQ4uxivwLR5assf0VwHdp5p06Er4w7urB637Z3wiQ1eZoT9tQ@mail.gmail.com>
 <20181010162948.GT28243@magnolia>
In-Reply-To: <20181010162948.GT28243@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 20:31:55 +0300
Message-ID: <CAOQ4uxhZaWMhEF2UXybHba-XDkUY6pGxhcqhJ1x7jNN2pnKGVw@mail.gmail.com>
Subject: Re: [PATCH 17/25] vfs: make remapping to source file eof more explicit
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

On Wed, Oct 10, 2018 at 7:29 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 03:29:06PM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Create a RFR_TO_SRC_EOF flag to explicitly declare that the caller wants
> > > the remap implementation to remap to the end of the source file, once
> > > the files are locked.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
[...]

> > > + * RFR_TO_SRC_EOF: remap to the end of the source file
> > >   */
> > >  #define RFR_IDENTICAL_DATA     (1 << 0)
> > > +#define RFR_TO_SRC_EOF         (1 << 1)
> > >
> >
> > So what is the best way to make sure that all filesystems can
> > properly handle this flag? and the RFR_CAN_SHORTEN flag?
> >
> > The way that your patches took is to not check for invalid flags
> > at all in filesystems, but I don't think that is a viable option.
>
> The RFR flags are internal APIs, so we don't need to be quite as strict
> as fiemap does...
>

That's true.

> > Another way would be to individually add those flags to invalid
> > flags check in all relevant filesystems.
> >
> > Another way would be to follow a pattern similar to
> > fiemap_check_flags(), except in case filesystem does not declare
> > to support the RFR_ "advisory" flags, it will not fail the operation
> >
> > Comparing to FIEMAP_ flags, no filesystem would have needed to declare
> > support for FIEMAP_FLAG_SYNC, because vfs dealt with it anyway
> > before calling into the filesystem. So de-facto, any filesystem supports
> > FIEMAP_FLAG_SYNC without doing anything, but it is still worth passing
> > the flag into filesystem in case it matter (it does for overlayfs).
>
> ...but I think you have a good point that we could help filesystem
> writers distinguish between advisory flags that are taken care of by the
> VFS but passed to the fs for full disclosure; and mandatory flags that
> the fs for which the fs must advertise support.
>
> IOWs,
>
> int remap_check_flags(unsigned int remap_flags, unsigned int supported_flags)
> {
>         /* VFS already took care of these */
>         remap_flags &= ~(RFR_TO_EOF | RFR_CAN_SHORTEN);
>
>         if (remap_flags & ~supported_flags) {
>                 WARN_ONCE(1, "Internal API misuse at %pS", __return_address);
>                 return -EINVAL;
>         }
>
>         return 0;
> }
>

With that in place, you can add:
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

on the vfs patches.

Thanks,
Amir.
