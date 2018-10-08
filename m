Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B58C00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5D9820878
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZeLCBmgm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D9820878
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbeJHSK4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 14:10:56 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40746 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbeJHSK4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 14:10:56 -0400
Received: by mail-vs1-f67.google.com with SMTP id z130-v6so11116402vsc.7
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2018 03:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=HtWglysCC1yjv30rCVQSnFPP0JuDmduywfuZ8w/HAYY=;
        b=ZeLCBmgm3RtvHKgUdxhKlzYuI2SBshpWQHFxHMb9/VwNCBdir1RuWmxknSI8DuILCx
         gvALLwbpkNI091pDUj/2l1fV5BcDX6a0kNyhL1nR2NIJHwSWV42ed8irjl6CCIJN/r9d
         5AW6FcnNZTJo25G2VYD25RnNxTVOKzyMQibCVl5IUuxKNCtQaJaDSfsIiP+sWKPjqPSd
         xl8OptUeyOH0EPD8CyrLKvzIT7srRnhC0vhj4t5h3OF24qEuLruP5i+gkaKXf7/3JEtb
         CnVzxPY6dgJLiJAu/++xOBRjSwQ9v+FsGkO3yQJ1s6yLN7XY4LopHGTMhITqTVdG3pmg
         828w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=HtWglysCC1yjv30rCVQSnFPP0JuDmduywfuZ8w/HAYY=;
        b=n42wbO2+f7Be1Ia15sfyTDel2WPZu81wS1i3UWWbko4i/pmGSP1Y+QXXLAx7UtfqAG
         dZMjRh263z+KtV2tlOY5i9NuaHtyCbbbCi2OClnerV5f4ywtRqIi8yyH7XztiXkC0Tc6
         2bUEMKMU8s8xDAMGJswsuB2MCEX4IEtXdkXPIf0xUlHQk6Zp9y15sJQ8h43hy69Sm9pm
         hLISv3ocozV1yCESwzHdwc4/lE8O1pwkBJoaIagewiOx7W3HFQirmVoELxH26qYASIXw
         mTh4Xqj9+Rd6kssDYp2koVTuCH4Y1DjSeg6hEa7nsgtq20llorO16/cBeR/VNJGQOyjM
         ediw==
X-Gm-Message-State: ABuFfojcDQnGQld557a8YSlhMe+kLdkNjIE7WPkk9GokrEJJACoBHpb4
        PZ9cBYSYUaw5XD0Klw654Lm3RrdsblSWXEowVJE=
X-Google-Smtp-Source: ACcGV62BScLLyWwNhEVmADFafAeY8QKxCBG2TcpPL8Bu3UuxfiucLsVox2sdpyt/+ezIy64b78hMbi14HQG4AimNfVA=
X-Received: by 2002:a67:e303:: with SMTP id j3mr2799826vsf.95.1538996386198;
 Mon, 08 Oct 2018 03:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <20180928111821.24376-1-josef@toxicpanda.com> <20180928111821.24376-38-josef@toxicpanda.com>
In-Reply-To: <20180928111821.24376-38-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Mon, 8 Oct 2018 11:59:35 +0100
Message-ID: <CAL3q7H7ZKHa2=ntDzvEQ7VdmLE63k7C+QJ6YoPp3cQ8zGE5OzQ@mail.gmail.com>
Subject: Re: [PATCH 37/42] btrfs: wakeup cleaner thread when adding delayed iput
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 12:21 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> The cleaner thread usually takes care of delayed iputs, with the
> exception of the btrfs_end_transaction_throttle path.  The cleaner
> thread only gets woken up every 30 seconds, so instead wake it up to do
> it's work so that we can free up that space as quickly as possible.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2b257d14bd3d..0a1671fb03bf 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3323,6 +3323,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
>         ASSERT(list_empty(&binode->delayed_iput));
>         list_add_tail(&binode->delayed_iput, &fs_info->delayed_iputs);
>         spin_unlock(&fs_info->delayed_iput_lock);
> +       wake_up_process(fs_info->cleaner_kthread);
>  }
>
>  void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
