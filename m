Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1282EC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 17:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C44762070D
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 17:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="178gkOdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729800AbfCZRjG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:39:06 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35009 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfCZRjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:39:06 -0400
Received: by mail-lj1-f196.google.com with SMTP id t13so11859252lji.2
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 10:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cesxg5Q8ka5nJnKvEEhOgZOfPXgwKAbI7eTkUr48Y8E=;
        b=178gkOdp9Fz2msAcX0Ce9QkIybE82t7v/wqmO82TA+zWVelRZtiR0LsSTsxheDbVfX
         S7eXuEL30eEW+HKo85Mlb5rWgcsJV4VwfYhXHcLSujRhViDlXcbdSSlHxeoQ90oqj8Ex
         2pFUhN1mUYAdO1bsxydpQ6l5xBdpQe0St0WGfWuXqOqnTdu7WyIiZRWZzs5f6qW/cxiq
         Zft2rkE4kFm2a8xV95ntoU3WtMHqUaD/+zOycyWlxfGOTzGwTdpiKG4HmvnuNA4O+97e
         JUkFw1u6da+1rs4/x07HuDI9+aDiPlActtohGIFV8QI2eCSSSyKUuBG+68aCpFHqtF2K
         jBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cesxg5Q8ka5nJnKvEEhOgZOfPXgwKAbI7eTkUr48Y8E=;
        b=KUAoa+XCRakzMcwveXtqBw1rwGvXNC2JB5I/okORvHXMySyD4DKk6qmOKvVPjnzrcZ
         yIkDcc1gwAvEezURy+NQV2g4LnsU0psmuVFDA9LF1QKNEjTGHjo0yZKLU12eenF4kEiW
         twiTneZ6+UyF5AeUOVzLgPQd8Xn0V0ijRnuFjx4yiedLJ7MI3xv5jWfmZ35MT2Jn6AZi
         zWsiouLxUW7QTJnRA3pnYJLwVEjTBSeu7EXzAIIIJi0iBKCKKhvyK1qKe37Y2/BOUdcL
         wacayoS9LwOTxtQVC6Mea8fDOlsoc/gv8uoxgwxr1R52d/02MXPRUOq93wkKhLGghZo+
         zlDA==
X-Gm-Message-State: APjAAAWt9cTahb8WXoussKbMu0DTic74r1Nkhb1sL31oBBIxfy8L3M8Z
        qut9g2XuuCXFABOEO+xURdrbLyPmAV4eBv/oDhhTJ5MI5Io=
X-Google-Smtp-Source: APXvYqw72kKOVDX1Ujr6SgJ3VQOaiPf5F+ZYP+O3xgR27scoKxFxv9uWj5+jxCwdMVlPfq0OG7sjjD7NICJ695aJ9DI=
X-Received: by 2002:a2e:9585:: with SMTP id w5mr542974ljh.132.1553621944403;
 Tue, 26 Mar 2019 10:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com> <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
In-Reply-To: <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 26 Mar 2019 11:38:53 -0600
Message-ID: <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_backup_uuid=5Ftree_generation_not_consistent_acros?=
        =?UTF-8?Q?s_multi_device_=28raid0=29_btrfs_=2D_won=C2=B4t_mount?=
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 12:44 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>
>
> He has btrfs raid0 profile on top of hardware RAID6 devices.

sys_chunk_array[2048]:
        item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
                length 4194304 owner 2 stripe_len 65536 type SYSTEM
                io_align 4096 io_width 4096 sector_size 4096
                num_stripes 1

Pretty sure the metadata profiles is "single". From the super, I can't
tell what profile the data block groups use.

-- 
Chris Murphy
