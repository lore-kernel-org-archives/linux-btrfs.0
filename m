Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B943C4321B
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC62F20895
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 13:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vMgb/fQ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfDYNZc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 09:25:32 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:33560 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfDYNZb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 09:25:31 -0400
Received: by mail-yw1-f67.google.com with SMTP id q11so4143545ywb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 06:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=dzZpdtSr5wZ68AK3WG7yE5hD8w70GoNxue56vDxfOmE=;
        b=vMgb/fQ4/pNEu8zPr80DPR7hhh+8OMubOmEv3GFOeEPlXSwwIdaonzxlXagObvRIfI
         tM0rA0YlfOPKusVe2qAkx3+nn8Jo2Ngb31dGAv/vcJr/GswfeFdcIRu3odAT40y1A+xY
         gd7lckPC1wyA2WZDDS0weyvjhKKFc2pEfFfAIVZJGYWadTZjD6kAwcGe2mIAQOyQu+J3
         Iu20S9OrvZNESRfPThRIItfDAdVfSrB/t0X2bv7ixETcOEyF8SgvcHCiUhd5J6U1f4dj
         aYrHtwxRTd6Iu9cVsl5acwstmADlMtC/hXhVy5NltBLGHbtLCxQkciGEB/JCQ9WGFu9a
         STyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=dzZpdtSr5wZ68AK3WG7yE5hD8w70GoNxue56vDxfOmE=;
        b=A9Fd3evPv5fWLhs2TYzZ+UVOBJy3S2VLp17VWiz7sNYaJuyXYxB47f53AjG9bXEL89
         wrsdev/eHuXdcnBGIDpE++DwxqAsrCgywrFIzuobXOfsKaOT4L5zktXEh1zRJNnJI3YJ
         bxYELWV9+rW8jByeOcMLjX0jQURoCYaSTjuq6bYk5KkB+F0V03P+VmbalXiWyFavQ/Lr
         54s3p2vL4R3ra90zJY5D5S7246YGCm6Guv76Xg1aYoQfIM3FTnpgwv7WIGSnW4AR9TCR
         jTx5mXAs6kVrq1IHKzMJOcHQ7XWB+AbK3oKfjWauUaAciD2Sc+5P/nAiIh5k8FtH7Uwb
         0AWg==
X-Gm-Message-State: APjAAAUO0b3Q+ZvxnMrM9zRS43at+JbXIYz9l/HpVevr5uIKbCTjA+Pi
        rBoBl3CSMutvZYYwi5f3biBiZg==
X-Google-Smtp-Source: APXvYqxVtX9JDS38ElN7cAy8LYtwi7LCjiTwbDEWc9csDfExi+A0eCRuHHDzw2EaJyILZUf97McF2Q==
X-Received: by 2002:a0d:c5c3:: with SMTP id h186mr18573194ywd.494.1556198729995;
        Thu, 25 Apr 2019 06:25:29 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::46ed])
        by smtp.gmail.com with ESMTPSA id h204sm24273367ywh.110.2019.04.25.06.25.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 06:25:29 -0700 (PDT)
Date:   Thu, 25 Apr 2019 09:25:27 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Jakob Unterwurzacher <jakobunt@gmail.com>,
        linux-btrfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: fallocate does not prevent ENOSPC on write
Message-ID: <20190425132526.wjtcipkpm7fmbzyc@macbook-pro-91.dhcp.thefacebook.com>
References: <CAPv9Zmk46As_P9Gyf_icET53xRda63h7iC1meES9xbdDEt9qow@mail.gmail.com>
 <f64c6b65-5f21-48eb-6e1e-db30cbe57545@gmx.com>
 <20190423113302.GS20156@twin.jikos.cz>
 <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e742762e-41fa-a231-991c-ac635f74f764@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 25, 2019 at 01:49:23PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/4/23 下午7:33, David Sterba wrote:
> > On Tue, Apr 23, 2019 at 10:16:32AM +0800, Qu Wenruo wrote:
> >> On 2019/4/23 上午5:09, Jakob Unterwurzacher wrote:
> >>> I have a user who is reporting ENOSPC errors when running gocryptfs on
> >>> top of btrfs (ticket: https://github.com/rfjakob/gocryptfs/issues/395 ).
> >>>
> >>> What is interesting is that the error gets thrown at write time. This
> >>> is not supposed to happen, because gocryptfs does
> >>>
> >>>     fallocate(..., FALLOC_FL_KEEP_SIZE, ...)
> >>>
> >>> before writing.
> >>>
> >>> I wrote a minimal reproducer in C: https://github.com/rfjakob/fallocate_write
> >>> This is what it looks like on ext4:
> >>>
> >>>     $ ../fallocate_write/fallocate_write
> >>>     reading from /dev/urandom
> >>>     writing to ./blob.379Q8P
> >>>     writing blocks of 132096 bytes each
> >>>     [...]
> >>>     fallocate failed: No space left on device
> >>>
> >>> On btrfs, it will instead look like this:
> >>>
> >>>     [...]
> >>>     pwrite failed: No space left on device
> >>>
> >>> Is this a bug in btrfs' fallocate implementation or am I reading the
> >>> guarantees that fallocate gives me wrong?
> >>
> >> Since v4.7, this commit changed the how btrfs do NodataCOW check:
> >> c6887cd11149 ("Btrfs: don't do nocow check unless we have to").
> >>
> >> Before that commit, btrfs always check if they need to reserve space for
> >> COW, while after that patch, btrfs never checks unless we have no space.
> >>
> >> However this screws up other nodatacow space check.
> >> And due to its age and deep changeset, it's pretty hard to fix it.
> >> I have tried several times, but it will only cause more problems.
> > 
> > What if the commit is reverted, if the problem is otherwise hard to fix?
> > This seems to break the semantics of fallocate so the performance should
> > not the main concern here.
> 

Are we sure the ENOSPC is coming from the data reservation?  That change makes
us fall back on the old behavior, which means we should still succeed at making
the data reservation.

However it fallocate() _does not_ guarantee you won't fail the metadata
reservation, I suspect that may be what you are running into.

> My blur memory of the underflow case is something like below: (failed to
> locate the old thread)
> 
> - fallocate
> - pwrite in to the reallocated range
>   At this timing, we can do nocow, thus no data space is reserved.
> 
> - Something happened to make that preallocated extent shared, without
>   writing back dirty pages.
>   Some possible causes are snapshot and reflink.
>   However nowadays, snapshots will write all dirty inodes, and reflink
>   will write the source range to disk.
> 
>   Maybe it's a small window inside create_snapshot() between
>   btrfs_start_delalloc_snapshot() and btrfs_commit_transaction() calls?
> 
> - dirty pages get written back
>   We created ordered extent, but at this timing, we can't do nocow any
>   more, we need to fallback to cow.
>   However at the buffered write timing, we didn't reserved data space.
>   Now we will underflow data space reservation.
> 
> However nowadays there are some new mechanism to handle this case more
> gracefully, like btrfs_root::will_be_snapshotted.
> 
> I'll double check if reverting that patch in latest kernel still cause
> problem.
> But any idea on the possible problem is welcomed.
> 

Reading the code there's two scenarios that happen.  All of our down stream
stuff assumes that we've updated ->bytes_may_use for our data write.  So if we
fail our reservation and do the nocow thing of skipping our reservation we can
overflow if we

1) Need to allocate an extent anyway because of reflink/snapshot.
btrfs_add_reserved_space() expects that space_info->bytes_may_use has our region
in it, so in this case it doesn't and we underflow here.  I think you are right
in that we do all dirty writeback nowadays so this is less of an issue, buuuut

2) In run_delalloc_nocow we do EXTENT_CLEAR_DATA_RESV unconditionally if we did
manage to do a nocow.  If we fell back on the no reserve case then this would
underflow our ->bytes_may_use counter here.

Off the top of my head I say we just add our write_bytes to ->bytes_may_use if
we use the nocow path.  If we're already failing to reserve data space as it is
then there's no harm in making it appear like we have less space by inflating
->bytes_may_use.  This is the straightforward fix for the underflow, and we
could come up with something more crafty later, like setting the range with
EXTENT_NO_DATA_RESERVE and doing magic later with ->bytes_may_use.  Thanks,

Josef
