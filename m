Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f46.google.com ([209.85.167.46]:45154 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbeIMUkj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 16:40:39 -0400
Received: by mail-lf1-f46.google.com with SMTP id r4-v6so5163555lff.12
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 08:30:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <322267c4-5671-73f3-acca-797dd6fe3572@suse.com>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu> <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu> <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com> <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com> <165d2e8e110.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <322267c4-5671-73f3-acca-797dd6fe3572@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 13 Sep 2018 09:30:35 -0600
Message-ID: <CAJCQCtQFfGzNrCSVsZXutfx+O5BdNEELieVuHbJ0mLBqATc-cw@mail.gmail.com>
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
To: Nikolay Borisov <nborisov@suse.com>
Cc: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the 2nd or 3rd thread containing hanging btrfs send, with
kernel 4.18.x. The subject of one is "btrfs send hung in pipe_wait"
and the other I can't find at the moment. In that case though the hang
is reproducible in 4.14.x and weirdly it only happens when a snapshot
contains (perhaps many) reflinks. Scrub and check lowmem find nothing
wrong.

I have snapshots with a few reflinks (cp --reflink and also
deduplication), and I see maybe 15-30 second hangs where nothing is
apparently happening (in top or iotop), but I'm also not seeing any
blocked tasks or high CPU usage. Perhaps in my case it's just
recovering quickly.

Are there any kernel config options in "# Debug Lockups and Hangs"
that might hint at what's going on? Some of these are enabled in
Fedora debug kernels, which are built practically daily, e.g. right
now the latest in the build system is 4.19.0-0.rc3.git2.1 - which
translates to git 54eda9df17f3.


Chris Murphy
