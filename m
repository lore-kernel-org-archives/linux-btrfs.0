Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34874 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbCaX4X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 19:56:23 -0400
Received: by wgdm6 with SMTP id m6so36045787wgd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 16:56:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
 <CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com> <CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
From: Martin Langhoff <martin.langhoff@gmail.com>
Date: Tue, 31 Mar 2015 19:56:02 -0400
Message-ID: <CACPiFCL6495Kar31POgrP_mp9w=K__-v5BdyeDeA6O2RGS5FsA@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 4:11 PM, Chris Murphy <lists@colorremedies.com> wrote:
> While you're at it, try to mount the Btrfs volume in question normally
> and report kernel messages. If mount fails, try it with -o recovery
> mount option, and also report kernel messages and whether that fails.

Oh, I should have mentioned this -- in the context of the
initramfs/systemd diagnostic shell (which is single-user), it just
hangs. No messages.

I'll get a bootable usb going and try under that.

cheers,



m
-- 
 martin.langhoff@gmail.com
 -  ask interesting questions
 - don't get distracted with shiny stuff  - working code first
 ~ http://docs.moodle.org/en/User:Martin_Langhoff
