Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7596EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 10:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DBD120832
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 10:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2ifyb7g"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DBD120832
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbeK1Vfo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 16:35:44 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:35493 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbeK1Vfo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 16:35:44 -0500
Received: by mail-ua1-f65.google.com with SMTP id d2so8724648ual.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 02:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=8YK2Bw+3EwEq7+A65rSe+kcaNUbzLac+2a8verRVVk0=;
        b=b2ifyb7g3qn+P12Lw4dWsR7btp/O5Jeby/XGFttdzRWTU9T+Qc7CLfQiX9GNiT499O
         WQKOFPMJkDPbnzg8XmVatiZQKpoMQS1559As/uxV0sBAm2L57LCUwcAJxbN/6GGSTrGJ
         PL4bzYo6sFxosFjUD8JVyLtcd+za9dZWSuO6lX7TGQUeXd9GqKdFcF/SdttfV4ceIYpI
         lYLJJBojSbOTNDDdtmZzSCGxSTGHu0JgpyYab+TC1fWYcVEYmtbvS1gobMQLOeD1T3nb
         dyRERee6JWD6TzVvQzcgBHpuX9UnMcAvu1ltt0SiSVsnUF8kCmlSl00T7wp205mhatt9
         2CVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=8YK2Bw+3EwEq7+A65rSe+kcaNUbzLac+2a8verRVVk0=;
        b=TkWLHlDlsJSI35IVJCET6U0ce0D3ncbEXzyxuy2BUwC8K0Q5gRFE1Ja7sn6zFFwWEo
         aM55PEfXyujSq9XOpgQDEUEeC7VUOGo05vfxhNKlYflOzg9nRE2g8NFYQ1Hr7P7oyens
         HX0dJxUvV587EacrKjrw7E5Pf6EWcHg4yRPExhbouTfTEQKSczatcZZRtwN4+kTzlNuY
         BFdEEdd+YG5i5JPnfczjcv449daAOw8gqh89XWanmdC9l2V3lfPmnwhiO4bQSxeEIPQ2
         EijTh+kyKod/ITjvWZy9hg2wDVQym8aGTZRSsDXIFs8NIDoBScomGQac98poRvYnMbxi
         6p2w==
X-Gm-Message-State: AA+aEWZVKXGSigBf8+P63kOnyFvyvuPcUvVM3KRg1xMCHkkUCsLVSncM
        RmxjorysuZh5gxVAcUrBkvyu9JiNU3Y5j4tC7Jyi/wD0
X-Google-Smtp-Source: AFSGD/UXL4XUwyvAfWZ34Ohd3Wb02PNCdjhOl7nXRPwU+a05NYbzyzrIUuJE8R1SA+e4DOpnjvKfiTayysO+5Goqxto=
X-Received: by 2002:ab0:3259:: with SMTP id r25mr14323853uan.108.1543401272067;
 Wed, 28 Nov 2018 02:34:32 -0800 (PST)
MIME-Version: 1.0
References: <20181128030731.10288-1-lufq.fnst@cn.fujitsu.com>
 <3377ecbb-a46b-bd85-10b3-7163535a4332@suse.com> <20181128074625.GA27028@infradead.org>
 <c47362b2-59e6-56d2-a023-1e101edc161c@suse.com> <20181128092424.GC3002@fnst.localdomain>
In-Reply-To: <20181128092424.GC3002@fnst.localdomain>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 28 Nov 2018 10:34:20 +0000
Message-ID: <CAL3q7H6gci+6TModx8q7pTyXm7VFy1CF7fz=cbF5TxmBve7k1A@mail.gmail.com>
Subject: Re: [RFC PATCH] btrfs: drop file privileges in btrfs_clone_files
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 9:26 AM Lu Fengqi <lufq.fnst@cn.fujitsu.com> wrote:
>
> On Wed, Nov 28, 2018 at 09:48:07AM +0200, Nikolay Borisov wrote:
> >
> >
> >On 28.11.18 =D0=B3. 9:46 =D1=87., Christoph Hellwig wrote:
> >> On Wed, Nov 28, 2018 at 09:44:59AM +0200, Nikolay Borisov wrote:
> >>>
> >>>
> >>> On 28.11.18 =D0=B3. 5:07 =D1=87., Lu Fengqi wrote:
> >>>> The generic/513 tell that cloning into a file did not strip security
> >>>> privileges (suid, capabilities) like a regular write would.
> >>>>
> >>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> >>>> ---
> >>>> The xfs and ocfs2 call generic_remap_file_range_prep to drop file
> >>>> privileges, I'm not sure whether btrfs should do the same thing.
> >>>
> >>> Why do you think btrfs shouldn't do the same thing. Looking at
>
> I'm not sure btrfs doesn't use generic check intentionally for some reaso=
n.
>
> >>> remap_file_range_prep it seems that btrfs is missing a ton of checks
> >>> that are useful i.e immutable files/aligned offsets etc.
>
> It is indeed.
>
> In addition, generic_remap_file_range_prep will invoke inode_dio_wait
> filemap_write_and_wait_range for the source and destination inode/range.
> For the dedupe case, it will call vfs_dedupe_file_range_compare.
>
> I still can't judge whether these operations are welcome by btrfs. I
> will go deep into the code.
>
> >>
> >> Any chance we could move btrfs over to use remap_file_range_prep so th=
at
> >> all file systems share the exact same checks?
>
> In theory we can call generic_remap_file_range_prep in
> btrfs_remap_file_range, which give us the opportunity to clean up the
> duplicate check code in btrfs_extent_same and btrfs_clone_files.
>
> >
> >I'm not very familiar with the, Filipe is more familiar so adding to CC.
> >But IMO we should do that provided there are no blockers.
> >
> >Filipe, what do you think, is it feasible?
>
> I'm all ears for the suggestions.

There's no reason why it shouldn't be possible to have them called in
btrfs as well.
There's quite a few changes in vfs and generic functions introduced in
4.20 due to reflink/dedupe bugs, probably either at the time,
or when cloning/dedupe stopped being btrfs specific, someone forgot to
make btrfs use those generic vfs helpers.
I'll take a look as well.

>
> --
> Thanks,
> Lu
>
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
