Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98182C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 17:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69932206DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 17:51:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="fwGcHLWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732201AbfCZRvP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 13:51:15 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37155 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731571AbfCZRvP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:51:15 -0400
Received: by mail-lj1-f193.google.com with SMTP id v13so11956768ljk.4
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2019 10:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UQfwYNkaDNqCUESNk4EIWOxugQuCg4NzcmDq1UmZom4=;
        b=fwGcHLWPCSSeIKAJH94BYKOzbNBkU89LBwaakfLOi8y2nr3hoCbPIY1uTK0M2h1upC
         jew5YXxS69Xk8jCvuVUbEo2SgPwny8a3h53lzfJ09Zzc73F78yZHICB7e44X8jkecR03
         oCkTxWy5dWdjIYdNr9NuSXWS+FJ3PpxlagqQIksvjV/w4PBT8XAa7Lc6Zz+vSrcfQMap
         kj/zo2r41opjIJhvNncX9Q2PCcDLzEmOpJGe2zNgU1CAtJMWtjtr8ZlGyVR5rPWV4z6B
         V/sDcQLuGvOmcN+rajgTB5gUM5SvWheHFkzGDO+TqBxMM9qpy5tWur7xpeGjqWcy7wxu
         N7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UQfwYNkaDNqCUESNk4EIWOxugQuCg4NzcmDq1UmZom4=;
        b=M4XKKJFG4z/T02lFnf211QzaqBsQhz0FAj+kqW3mDmRVkqj2PwcXHdQuZx2s4f17QF
         rbWx535yYCUq62QKKvjrWqtgkwXvP5LOQWIcxKhUj/YSQVhO9p7ROMSmah7Hcu0Vf9YI
         1rNBILwoFHja+0ifKR4VrGhjyZ/lUYC57JgcEuOWtY8WB0njs1+6wfcyJ6j0KPPQu6nW
         VoSV7VZe61ySOuB/IJ+/CPdkP/xoVWKoEDn+tZeeslZ/h683jaTfpo0Tc+9KT2KVkX3b
         WbG/C9uVe+sDkOnwjndWivLIwPU6cFy63J3apLXO/D62YGT6o3YAoduVh2sybG3iuOdl
         Knpw==
X-Gm-Message-State: APjAAAV6CLJoLrd94mq+k+bbNoNgl7fwYrl3qKD7sj7a43Zt+e8p/97W
        0kAZ0oSnCM5l3n0cDb6bqpQezjJeeW+oXG5EjmYlCsKpi28=
X-Google-Smtp-Source: APXvYqzEu3lE1y9s1TvakSGtfN/DzMGbgmUbDRgwPaMFMqbXjFzQluroLU7AbEU87oQ8nXCu/ECLmTzye94RM1rbKj0=
X-Received: by 2002:a2e:8582:: with SMTP id b2mr2925948lji.24.1553622673293;
 Tue, 26 Mar 2019 10:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com> <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
 <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
In-Reply-To: <CAJCQCtTqnqxvFJ3xwHiYFfWThqAL2apxqT=q0PJMv37UPCHGew@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 26 Mar 2019 11:51:02 -0600
Message-ID: <CAJCQCtTZ1iP6dxL+E0Q7Ssa_zEikqWVkZsqHO7H429E0yV67PA@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_backup_uuid=5Ftree_generation_not_consistent_acros?=
        =?UTF-8?Q?s_multi_device_=28raid0=29_btrfs_=2D_won=C2=B4t_mount?=
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 11:38 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> On Tue, Mar 26, 2019 at 12:44 AM Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> >
> >
> > He has btrfs raid0 profile on top of hardware RAID6 devices.
>
> sys_chunk_array[2048]:
>         item 0 key (FIRST_CHUNK_TREE CHUNK_ITEM 1048576)
>                 length 4194304 owner 2 stripe_len 65536 type SYSTEM
>                 io_align 4096 io_width 4096 sector_size 4096
>                 num_stripes 1
>
> Pretty sure the metadata profiles is "single". From the super, I can't
> tell what profile the data block groups use.

system chunk is on two devices:
                num_stripes 1 sub_stripes 0
                num_stripes 1 sub_stripes 1

Maybe it is raid0, but I thought dump super explicitly shows the
profile if it's not single. e.g. SYSTEM|DUP or SYSTEM|RAID1

Only my single profile file systems lack a profile designation in the
super. But I admit I have no raid0 file systems.

-- 
Chris Murphy
