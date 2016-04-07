Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36169 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbcDGPq1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2016 11:46:27 -0400
Received: by mail-lf0-f45.google.com with SMTP id g184so60165610lfb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Apr 2016 08:46:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADzmB21RH8HOHzAvCrD1ueSy-abT-J=-XAhn6yrQPW6USA1EQg@mail.gmail.com>
References: <CADzmB21iEn03C5rtP=4dGe3mS8Tvd_+VUDLtczUQMotPcDOPNg@mail.gmail.com>
 <570070D4.80404@gmx.com> <CADzmB23BwRsrvCeM7ntPt=0wz4tEVc6Vu5Gm0X7tKoQ20n_WTQ@mail.gmail.com>
 <5705B0C0.6070606@cn.fujitsu.com> <CADzmB21RH8HOHzAvCrD1ueSy-abT-J=-XAhn6yrQPW6USA1EQg@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Thu, 7 Apr 2016 17:46:05 +0200
Message-ID: <CAA7pwKPENs_xaw9M2=BWzPxcVP4TzML225BxwnSHiAPupSzrKQ@mail.gmail.com>
Subject: Re: scrub: Tree block spanning stripes, ignored
To: Ivan P <chrnosphered@gmail.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 April 2016 at 17:33, Ivan P <chrnosphered@gmail.com> wrote:
>
> After running btrfsck --readonly again, the output is:
>
> ===============================
> Checking filesystem on /dev/sdb
> UUID: 013cda95-8aab-4cb2-acdd-2f0f78036e02
> checking extents
> checking free space cache
> block group 632463294464 has wrong amount of free space
> failed to load free space cache for block group 632463294464

Mount once with option "clear_cache" and check again.
