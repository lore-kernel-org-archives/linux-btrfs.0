Return-Path: <SRS0=OwOL=RT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CB7C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 23:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ED7721871
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Mar 2019 23:15:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="qjNh6D0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfCPXPx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Mar 2019 19:15:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44388 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfCPXPx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Mar 2019 19:15:53 -0400
Received: by mail-lj1-f195.google.com with SMTP id n18so8975139ljg.11
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2019 16:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bDPYSMTga44SB9DxStkQkrV2BVzgzzcXPbuLfu/5EV8=;
        b=qjNh6D0fkwRvPoDNYnRbl78ICiyEDSEQ6uuU9cUXzrCSlIhf44S34LsL/EoXmdouwv
         KXUoclbfsqgs7Lp2VUL+4AIL77lpaI9mD7M3NcmCoAehlee/+iB2CGKotz1Y5DQbF7aM
         O0W80upAWbvAYY6d8p/zH8S7CwAs9m1g89L+aftgvCyQ8NMzVe8O0RuV3rvLDHj3XTCM
         5WT0Nv3xhTuvGrfDmNizVgJVwZ0I0qDeRxhHGH+noe4Yb4swCcGBgginFkL5DkxW1PM3
         4qzgi9J1gAZesZKfgULqLfNnz1/r19h6IrsjVu+6+/jCBwkvR1mwKFnmExB7uUaxx897
         M82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bDPYSMTga44SB9DxStkQkrV2BVzgzzcXPbuLfu/5EV8=;
        b=KBg+qAZxD1FHYoXsyGzdRjyJGYZc9KPxBZqhEikyCcTYWe/7gp2pLpS5aWiMaiVhNf
         swfG1QMOo8LcSkSqTywfnzANpsKJTwybjpCxnbWwHfzOK4gaEtTBRaAYAwJqavGP0Bum
         US4Q5mX8t68DUnaEWd5348yT3W3XYLIK1TGlI2dKM4Q2t5bHzMBVDbmPW/2yOeaTCQ2g
         mhmj3+6MENg5Z/XO7NXY3vbUYomaOTD5nDbap4/QfyRy+JU7GWJkO/6yxBh7J0MPkZ1w
         H2KSLPD5T6NNHhcPsMN0aMnABtc/T4ZUhFvbq30SrvWxfzJrnp+i3qO9uVIfWr5EsNV5
         cirw==
X-Gm-Message-State: APjAAAXvSjY6i1lc/F8SAU7pB8hOd8wjjOcklwRgqEv+yM6+K3RY8wf5
        Pce44XV5bXgiJQ7JA7g9sUUxah3fDsn/GXMz5GyiLQ==
X-Google-Smtp-Source: APXvYqxn2n8EFLqV6u108cTX3CMGY6dFKczn6RrCtqX/jAMDJzFUMGJ/1DlxRZDo+wuxJqwbL19mx2HGc7V13Lh7vzo=
X-Received: by 2002:a2e:2419:: with SMTP id k25mr6157342ljk.38.1552778151364;
 Sat, 16 Mar 2019 16:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <CANWDRg9zN2KXzx7zLJFV5jixp7pmqqr5raVB-mFNObtzvxSh0Q@mail.gmail.com>
In-Reply-To: <CANWDRg9zN2KXzx7zLJFV5jixp7pmqqr5raVB-mFNObtzvxSh0Q@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 16 Mar 2019 17:15:40 -0600
Message-ID: <CAJCQCtSNUCaV+1f2Y9AHZh3JSzJzUVcKmwp-4zcUFak0rk5b=w@mail.gmail.com>
Subject: Re: BTRFS partition over a SSD got totally broken on Ubuntu 18.10 ->
 errno=-17 Object already exists (Failed to recover log tree)
To:     =?UTF-8?Q?Luis_Panadero_Guarde=C3=B1o?= <luis.panadero@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 16, 2019 at 3:35 AM Luis Panadero Guarde=C3=B1o
<luis.panadero@gmail.com> wrote:
>
> > [ 3490.976048] BTRFS: error (device sdc2) in btrfs_run_delayed_refs:308=
3: errno=3D-17 Object already exists
> > [ 3490.976062] BTRFS: error (device sdc2) in btrfs_replay_log:2308: err=
no=3D-17 Object already exists (Failed to recover log tree)

It's a problem with log replay. That you're stuck here means it's a
bug, but I can't tell you where. It might have started days or weeks
earlier and cumulatively ended up here where the kernel can't deal
with it; or maybe it's an SSD firmware bug; or maybe some of both.
Also, when Btrfs goes read only it's trying to avoid causing more
corruption, but it might have already been too late. Anyway, you can
see if it will mount with a newer kernel, try the newest you can from
4.19 or 4.20 series.

Another possibility that will come with some data loss is `btrfs
rescue zero-log /dev/` which will zero the log tree, and whatever
writes were happening at the time the log tree was being written to
will be lost - up to 30 seconds worth from before going read-only. So
if you can live with that you can try it.

The big problem with 4.16 series is it's not long term so it's EOL and
not getting any bug fixes. Ideally run the newest stable kernel.

Also, the crash with btrfs check is a bug in btrfs-progs 4.15. I'm
pretty sure it's fixed, but you can update btrfs-progs to 4.20.2 to
find out. I don't know any distro doing backports, so it's reasonable
to just use the latest upstream version once it's a couple weeks old.
For the purpose of zeroing the log, I don't think you need to update
btrfs-progs.


--=20
Chris Murphy
