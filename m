Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:59695 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbBBGG7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Feb 2015 01:06:59 -0500
Received: by mail-yh0-f45.google.com with SMTP id f73so15113852yha.4
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 22:06:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMnnoUKpF+WxAwcbLLCaj04rt4970QcAGvhW2iKd9614wnbgiA@mail.gmail.com>
References: <CAMnnoUKpF+WxAwcbLLCaj04rt4970QcAGvhW2iKd9614wnbgiA@mail.gmail.com>
Date: Sun, 1 Feb 2015 23:06:58 -0700
Message-ID: <CAJCQCtThr6WTYWrAE+tsUEqk7qB9cxovwWrUcTKpcZL8BDASJg@mail.gmail.com>
Subject: Re: Unclean shutdown, BTRFS will not mount after - what things to try
 in what order?
From: Chris Murphy <lists@colorremedies.com>
To: Victor Hooi <victorhooi@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 1, 2015 at 10:50 PM, Victor Hooi <victorhooi@gmail.com> wrote:
> We have a Ubuntu 14.10 server that has a BTRFS root filesystem.

So you're getting dropped to a dracut prompt? i.e. you're in the
initramfs and root fs is not mounted at /sysroot, so if you ls
/sysroot there's nothing there, right? If so you can try:

mount -o recovery /dev/ /sysroot

If you get no major errors then

mount

to see if it's mounted at /sysroot and if so

exit

will resume boot.

If the -o recovery mount fails, then it's a bit trickier. It's
probably easiest to take a cell phone photo of the error message if
it's not super short to copy out. And then

btrfs check <dev>

Again cell phone is easier, it's a lot to write out. But the problems
are important as is the btrfs-progs baked into the initramfs. Someone
might know if that version of btrfs-progs is safe to try a repair
given the problem output from check. If no one replies soon enough for
you, I probably wouldn't use --repair unless I had v.3.18, in which
case you probably need live media and update its btrfs-progs after
booting from it.

-- 
Chris Murphy
