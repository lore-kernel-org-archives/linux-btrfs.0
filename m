Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34493 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2I1ARA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 20:17:00 -0400
Received: by padhz1 with SMTP id hz1so1778017pad.19
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2012 17:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKZ=RP8V7J=vYerLGzavq5GBFmNtmyRYeautEoAyWqOud9b3Pw@mail.gmail.com>
References: <CAKZ=RP8V7J=vYerLGzavq5GBFmNtmyRYeautEoAyWqOud9b3Pw@mail.gmail.com>
Date: Thu, 27 Sep 2012 18:17:00 -0600
Message-ID: <CAE5mzvj-rOzVfuhUsNjd5=GyZrN4W-gGJ-yqdSJFemAyC=8e=w@mail.gmail.com>
Subject: Re: [PATCH] btrfs-convert: show progress
From: cwillu <cwillu@cwillu.com>
To: Alfredo Esteban <aedelatorre@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 27, 2012 at 6:02 PM, Alfredo Esteban <aedelatorre@gmail.com> wrote:
> Hello,
>
> I'm sending a patch to show progress of btrfs-convert command. I put a
> progress bar in the only heavy process: the btrfs metadata creation
> (due to CRC calculation):

Please include patches inline in the email, not as an attachment.

>> ./btrfs-convert /dev/loop1
> Creating btrfs metadata [================================================] 100%
> Creating ext2fs image file... [DONE]
> Cleaning up system chunk... [DONE]
> Conversion complete.
>
> I just used "\r". I think it is a simple but effective approach
> without ncurses either other dependencies.

There should probably be some way to disable the progress bar (ideally
defaulting to a istty check) so that log files don't capture hundreds
if not thousands of lines of "[========          ]".
