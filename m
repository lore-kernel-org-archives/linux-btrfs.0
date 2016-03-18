Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36799 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcCRInp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 04:43:45 -0400
Received: by mail-lb0-f178.google.com with SMTP id qe11so29533644lbc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 01:43:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2aR2AjBhdTE6jK6joceJEv_5XY-8tE1xrn=AeG9773fg@mail.gmail.com>
References: <201603121301.u2CD1HCC022214@phoenix.vfire>
	<CAEtw4r2aR2AjBhdTE6jK6joceJEv_5XY-8tE1xrn=AeG9773fg@mail.gmail.com>
Date: Fri, 18 Mar 2016 09:43:43 +0100
Message-ID: <CAEtw4r0q9s2qk6A4Ymp=htTnWpzeUmi_o2D14+JiGVcEMbMaBw@mail.gmail.com>
Subject: Fwd: Snapshots slowing system
From: Peter Becker <floyd.net@gmail.com>
To: linux-btrfs@vger.kernel.org, pete@petezilla.co.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Not sure if there is much else to do about fragmentation apart from running a
> balance which would probally make thje machine v sluggish for a day or so.

I think a full balance-run makes in this point of view no sense.
A weekly freeing of unused and summarize of underused blocks make more sense.
I prefer the https://github.com/liubogithub/btrfsmaintenance/
balance-script or weekly do the following:

    # remove empty data/meta block groups for fast free space
    btrfs balance start -v -dusage=0 /mountPoint
    btrfs balance start -v -musage=0 /mountPoint

    # quickly clean up the less used block groups
    # < 1%
    btrfs balance start -v -dusage=1 /mountPoint
    btrfs balance start -v -musage=1 /mountPoint

    # < 5%
    btrfs balance start -v -dusage=5 /mountPoint
    btrfs balance start -v -musage=5 /mountPoint

    # < 15%
    btrfs balance start -v -dusage=15 /mountPoint
    btrfs balance start -v -musage=15 /mountPoint

    # < 30%
    btrfs balance start -v -dusage=30 /mountPoint
    btrfs balance start -v -musage=30 /mountPoint

    # < 50%
    btrfs balance start -v -dusage=50 /mountPoint

On my 13 TB-Raid 1 Array with 150 Snapshots this will finished in less
then a hour (normaly i takes a half hour).
But the first run will take muth more time of you have many
data-blocks with <50% usage. so feel free to reduce the dusage-value
if you need.
