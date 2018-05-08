Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:42347 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbeEHTkh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 15:40:37 -0400
Received: by mail-wr0-f174.google.com with SMTP id v5-v6so33459935wrf.9
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 12:40:36 -0700 (PDT)
Date: Tue, 8 May 2018 21:40:34 +0200
From: Nicolas Porcel <nicolasporcel06@gmail.com>
To: Noah Massey <noah.massey@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: send ioctl failed with -2
Message-ID: <20180508194034.GA8537@nicolas-desktop>
References: <20180508174412.GA3058@nicolas-desktop>
 <CADfjVrh5zD5Gu2_gDfDtcVW_PfEnEsCCuoCF-h8Mm+h1N-DWww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CADfjVrh5zD5Gu2_gDfDtcVW_PfEnEsCCuoCF-h8Mm+h1N-DWww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 02:16:06PM -0400, Noah Massey wrote:
> Silly question, but is 'mysnapshot' actually accessible at './mysnapshot' ?
> Because the output from btrfs send should immediately output
> 'At subvol mysnapshot'

Inded. This is not even the right command considering I only kept the
error when writing this email. It takes 5-10 minutes to run for 40GB of
data so I did not want to do it again.

> 
> If 'btrfs send' is actually generating output, 'btrfs receive -vv' may
> help "parse" the send stream enough to figure out where it is
> terminating.

I tried it and I did not find anything related to the error. The output
is basically the list of files received and their chmod but nothing
more. Unless I can find which file is causing problem with that.

> 
> ~ Noah
> 
> ps - I was going to suggest 'btrfs send -v'. According the the
> manpage, that would "enable verbose output, print generated commands
> in a readable form". But it does not seem to be working for me, and
> after a quick glance at the code I'm not seeing how the ioctl call is
> setting up any kind of verbose feedback. So that may be out-of-date
> documentation.

I also tried it with 5 'v' and nothing happened.

-- 
Nicolas
