Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3EFC10F05
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 06:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B802070B
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 06:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jasIs20n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731650AbfCZGoH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 02:44:07 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:46191 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbfCZGgU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 02:36:20 -0400
Received: by mail-oi1-f181.google.com with SMTP id x188so9030291oia.13
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 23:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYGFcwfFlb2pEIxRljPTwrupLkPlnFrhc4IuYV07otE=;
        b=jasIs20nPXnFTGe8x9rPiGThYzGYauLaXsr3bwaBCnaKU40Dfpz3s/NtnbEc3iwsKX
         /U7GFqdSRDZobnVKX4dJTaUlSgc7vCfFfVVftVmizkpzI6pEEBZykD7gD2EVS06KQI7K
         374MPlsoQuJy+2Dl6pG3em7hIlq7yqhoVtLpfFwmZbkiGL3x6cWd7q1xVmvykgkG5nEZ
         cAD7Mqx4vHGDFQ/dTN2LepYmMUKAy0a3/2M8j4T4w4PWmb/3ukCUhzA/V2xCAdZd18hf
         gKyr2aKxIMniZSg1e4G0CF3lnUXqT6khgW8S5NXRtNyVwBSWkcOBAOYZosZuh5nqJMIE
         CO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYGFcwfFlb2pEIxRljPTwrupLkPlnFrhc4IuYV07otE=;
        b=ZTsh720Xib/aLG0e6KVTqeb90m2sV64usmxyh7Hh/AqGzFTL+Au2YDJBmAKcdQ3Oe+
         hwN6xHS3osLAKSPMtWx2nEsxUdqziV581ctezzH3xkmZo6XCRkKav5rFSA9WzgZM5MXw
         CScbp0EJ92Pd9cIEnkJODmmfzCejG7LLPE9nQdUTmCPc4Rg4WUtZZhW195ZWVuOt8edD
         E/Oql9VRPCx0ed5TnawzUDfcgEaufzA/pEmfGxFuBYJtAs4VKxauXqUYJiMZIpbldlZb
         AYIRgQrsjeaLS3ZFV0zv/1AGwVaCGMNcuSLVLrMlZjA+5wxQaDpMKpmZEA7h2CJ/b3H5
         NTcg==
X-Gm-Message-State: APjAAAVwSIzLexZIa411RX7VXshoxOp7HMc/c1ztCdg6CbGAGaDpo7b/
        as2Dum8ZJ9kN3V920lIpWt5DcqgZwvLTEoFqGtw=
X-Google-Smtp-Source: APXvYqz7v9/tJMbPlQxRTEM9bPu77k6hsfMz5ZbZiUrCrEVDdJRBHh31EjnBP5mx2Ov8CfIaiYxlvSLiMEbZAJqOaZg=
X-Received: by 2002:aca:a84a:: with SMTP id r71mr14794000oie.56.1553582179971;
 Mon, 25 Mar 2019 23:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <ZYHmunh2bnI4vOU0LDX4lb1DXvOSPtcjyj7EAns2xBKGaQmIH0amXJKJjKuERK8ygPphnq5hOn4DyprjS9VNgd8ediqxsJOi9lLNYVYGnCA=@protonmail.com>
 <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
In-Reply-To: <5b21fff4-0515-5577-0ab6-03f452469ef3@gmx.com>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Date:   Tue, 26 Mar 2019 09:36:08 +0300
Message-ID: <CAA91j0VZkER8SV_TH=V75oHs5mST+D_k8TJ0gOJQsnaZfF4BJQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_backup_uuid=5Ftree_generation_not_consistent_acros?=
        =?UTF-8?Q?s_multi_device_=28raid0=29_btrfs_=2D_won=C2=B4t_mount?=
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     berodual_xyz <berodual_xyz@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 8:19 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> > Kernel 4.20.17
> > btrfs-progs 4.20.2
> >
> > The filesystem consists of 4 (HW raid6) devices, each of them shows different superblock backups but my hope is that backup 2 is "consistent" across all of them.
> >
> > Is there any way to restore a specific superblock backup and attempt to mount the filesystem? Running "btrfs restore" did partially recover the data, but the most important bit is still missing.
>
> You sda and sdb are at gen 60233 while sdd and sde are at gen 60234.
>
> It's possible to allow kernel to manually assemble its device list using
> "device=" mount option.
>
> Since you're using RAID6, it's possible to recover using 2 devices only,
> but in that case you need "degraded" mount option.

He has btrfs raid0 profile on top of hardware RAID6 devices.
