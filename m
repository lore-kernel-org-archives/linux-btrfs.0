Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34332 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbcHaVof (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 17:44:35 -0400
Received: by mail-oi0-f65.google.com with SMTP id t127so5964531oie.1
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 14:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472676550.8145.1.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 31 Aug 2016 15:44:33 -0600
Message-ID: <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 2:49 PM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> Hi guys!
>
> And the problem happened again. This time, I was only using Mozilla
> Firefox. I could get the very first message after the error. I hope it
> brings more information:
>
> [28039.672199] ------------[ cut here ]------------
> [28039.672253] WARNING: CPU: 3 PID: 31800 at ../fs/btrfs/qgroup.c:2667
> btrfs_qgroup_free_meta+0x88/0x90 [btrfs]


Does this file system have quota enabled?

I'm testing this right now and can't even figure out how to determine
when quota is enabled on a Btrfs file system. There's enable, disable,
and rescan. If it's enabled or disabled, I get the same message if I
rescan. If I mount the file system with quota previously enabled,
there is no mount time notification that quota is enabled.

I sincerely hope opensuse isn't enabled quota by default.



-- 
Chris Murphy
