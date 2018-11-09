Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E526C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB3220883
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 10:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7RhQl/d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EB3220883
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbeKIUCD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727532AbeKIUCD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 15:02:03 -0500
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E369520883
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 10:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541758926;
        bh=JFNKmhY3FELOVRTm4dXtHbhY1xf8BpIwLtP0YMFu5Jo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b7RhQl/dLYHQ4XYDpNrQHPrWdqTXS3eUnB37nJznzF+kp9gBkUjS4stDQNq4Q52Yl
         ymAZixhslCzKjAFlcDeOSuuhpuXd8yx8UNye1sGxe0E4tW2Kj7IHJjoFNE6euJO8jT
         dFcinryXOnP3EQOVaSi7vicEZM6pXrzWhsZbsMZo=
Received: by mail-vs1-f45.google.com with SMTP id p74so741131vsc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 02:22:05 -0800 (PST)
X-Gm-Message-State: AGRZ1gKT1EsnT71tNSIwVcdSCFmhcQBREoO+pKCRpEzJ/it4CWlNGD9i
        6K1rEng8BkS3UiAUW8yQRsZYHC0FlyLDphN3Mms=
X-Google-Smtp-Source: AJdET5eOgkTVhBi4HQqoXmCQiTrw1wYhk7hPZC5ATy/s2q2P6Go2fOn9UvbsdIIRGmj9Mds6jP1gkF1MrXtrhWX/1nU=
X-Received: by 2002:a67:e34e:: with SMTP id s14mr3413652vsm.95.1541758925058;
 Fri, 09 Nov 2018 02:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20181108131750.27833-1-fdmanana@kernel.org> <28ee2da1-4556-3343-5650-917d4c805181@gmx.com>
 <CAL3q7H51FO9mXUKEfd3zn7ZdOnhcOLjNn-nO80XFNP5aRxrriQ@mail.gmail.com>
 <CAL3q7H7E+vVLimR1GbjveN1G8Gi5G9K6_v1wnMrtMLBWLeUCiw@mail.gmail.com> <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
In-Reply-To: <e65de2b0-a331-4965-44f7-d7f2fc4ccc79@gmx.com>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Fri, 9 Nov 2018 10:21:53 +0000
X-Gmail-Original-Message-ID: <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>
Message-ID: <CAL3q7H5qC9xuf224NP2s8pizf2FULQQyVEJR_bUTS45-v7EC9w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not set log for full commit when creating
 non-data block groups
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 9, 2018 at 12:27 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2018/11/8 =E4=B8=8B=E5=8D=8810:48, Filipe Manana wrote:
> > On Thu, Nov 8, 2018 at 2:37 PM Filipe Manana <fdmanana@kernel.org> wrot=
e:
> >>
> >> On Thu, Nov 8, 2018 at 2:35 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrot=
e:
> >>>
> >>>
> >>>
> >>> On 2018/11/8 =E4=B8=8B=E5=8D=889:17, fdmanana@kernel.org wrote:
> >>>> From: Filipe Manana <fdmanana@suse.com>
> >>>>
> >>>> When creating a block group we don't need to set the log for full co=
mmit
> >>>> if the new block group is not used for data. Logged items can only p=
oint
> >>>> to logical addresses of data block groups (through file extent items=
) so
> >>>> there is no need to for the next fsync to fallback to a transaction =
commit
> >>>> if the new block group is for metadata.
> >>>
> >>> Is it possible for the log tree blocks to be allocated in that new bl=
ock
> >>> group?
> >>
> >> Yes.
> >
> > Now I realize what might be your concern, and this would cause trouble.
> > Surprised this didn't trigger any problem and I had this (together
> > with other changes) running tests for some weeks already.
>
> Maybe it's related metadata chunk pre-allocation so it will be super
> hard to hit in normal case, or some extent allocation policy preventing
> us from allocating tree block of newly created bg.

No, I don't think we have such kind of policy, would have noticed it
over the years if we did have one.
Metadata chunk allocation just happens much less frequently for
workloads the tests exercised.

>
> Thanks,
> Qu
>
> >
> >>
> >>>
> >>> Thanks,
> >>> Qu
> >>>
> >>>>
> >>>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >>>> ---
> >>>>  fs/btrfs/extent-tree.c | 3 ++-
> >>>>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> >>>> index 577878324799..588fbd1606fb 100644
> >>>> --- a/fs/btrfs/extent-tree.c
> >>>> +++ b/fs/btrfs/extent-tree.c
> >>>> @@ -10112,7 +10112,8 @@ int btrfs_make_block_group(struct btrfs_tran=
s_handle *trans, u64 bytes_used,
> >>>>       struct btrfs_block_group_cache *cache;
> >>>>       int ret;
> >>>>
> >>>> -     btrfs_set_log_full_commit(fs_info, trans);
> >>>> +     if (type & BTRFS_BLOCK_GROUP_DATA)
> >>>> +             btrfs_set_log_full_commit(fs_info, trans);
> >>>>
> >>>>       cache =3D btrfs_create_block_group_cache(fs_info, chunk_offset=
, size);
> >>>>       if (!cache)
> >>>>
> >>>
>
