Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60536 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726819AbeIMUyo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 16:54:44 -0400
Subject: Re: btrfs send hangs after partial transfer and blocks all IO
To: Chris Murphy <lists@colorremedies.com>
Cc: =?UTF-8?Q?J=c3=bcrgen_Herrmann?= <t-5@t-5.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
 <63ab2fb7-15a8-f807-4a2f-04ce53f3f168@suse.com>
 <bb7c2fdd78c731bdf9b5044f4dfc4223@t-5.eu>
 <cb7403dd-0e76-8e8c-2389-30283b9e319d@suse.com>
 <165d2939520.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <7956cebe-3227-f153-6f0e-be272abe2c61@suse.com>
 <165d2c48478.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <91b2f76b-5b1c-6df3-ac8c-058696f27788@suse.com>
 <165d2e8e110.27fe.1e2eed663022c8efc8eff86f8ee324b8@t-5.eu>
 <322267c4-5671-73f3-acca-797dd6fe3572@suse.com>
 <CAJCQCtQFfGzNrCSVsZXutfx+O5BdNEELieVuHbJ0mLBqATc-cw@mail.gmail.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5c0b3895-05c8-63b1-195a-316d3eaca072@suse.com>
Date: Thu, 13 Sep 2018 18:44:35 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQFfGzNrCSVsZXutfx+O5BdNEELieVuHbJ0mLBqATc-cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 13.09.2018 18:30, Chris Murphy wrote:
> This is the 2nd or 3rd thread containing hanging btrfs send, with
> kernel 4.18.x. The subject of one is "btrfs send hung in pipe_wait"
> and the other I can't find at the moment. In that case though the hang
> is reproducible in 4.14.x and weirdly it only happens when a snapshot
> contains (perhaps many) reflinks. Scrub and check lowmem find nothing
> wrong.
> 
> I have snapshots with a few reflinks (cp --reflink and also
> deduplication), and I see maybe 15-30 second hangs where nothing is
> apparently happening (in top or iotop), but I'm also not seeing any
> blocked tasks or high CPU usage. Perhaps in my case it's just
> recovering quickly.
> 
> Are there any kernel config options in "# Debug Lockups and Hangs"
> that might hint at what's going on? Some of these are enabled in
> Fedora debug kernels, which are built practically daily, e.g. right
> now the latest in the build system is 4.19.0-0.rc3.git2.1 - which
> translates to git 54eda9df17f3.

If it's a lock-related problem then you need Lock Debugging => Lock
debugging: prove locking correctness

> 
> 
> Chris Murphy
> 
