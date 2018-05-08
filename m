Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36928 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932318AbeEHSQr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 14:16:47 -0400
Received: by mail-io0-f174.google.com with SMTP id e20-v6so39625099iof.4
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 11:16:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180508174412.GA3058@nicolas-desktop>
References: <20180508174412.GA3058@nicolas-desktop>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 8 May 2018 14:16:06 -0400
Message-ID: <CADfjVrh5zD5Gu2_gDfDtcVW_PfEnEsCCuoCF-h8Mm+h1N-DWww@mail.gmail.com>
Subject: Re: send ioctl failed with -2
To: Nicolas Porcel <nicolasporcel06@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 8, 2018 at 1:44 PM, Nicolas Porcel
<nicolasporcel06@gmail.com> wrote:
> Hello,
>
> When I do a btrfs send, I get the following error code:
>
>     # btrfs send mysnapshot > /dev/null
>     ERROR: send ioctl failed with -2: No such file or directory
>

Silly question, but is 'mysnapshot' actually accessible at './mysnapshot' ?
Because the output from btrfs send should immediately output
'At subvol mysnapshot'

> I get it after 70-100% of the bytes are sent.
>

If 'btrfs send' is actually generating output, 'btrfs receive -vv' may
help "parse" the send stream enough to figure out where it is
terminating.

~ Noah

ps - I was going to suggest 'btrfs send -v'. According the the
manpage, that would "enable verbose output, print generated commands
in a readable form". But it does not seem to be working for me, and
after a quick glance at the code I'm not seeing how the ioctl call is
setting up any kind of verbose feedback. So that may be out-of-date
documentation.
