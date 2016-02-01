Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35439 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcBAU1u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 15:27:50 -0500
Received: by mail-ig0-f181.google.com with SMTP id t15so44539419igr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 12:27:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AFB598.2020307@gmail.com>
References: <56AFB598.2020307@gmail.com>
Date: Mon, 1 Feb 2016 13:27:50 -0700
Message-ID: <CAJCQCtQKPY537mZS0UVNzFQjCCVi6ik643wjssDnxGKiojcNzg@mail.gmail.com>
Subject: Re: Question about a specific error.
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 1, 2016 at 12:44 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> In the process of trying to debug issues I'm having on one of my
> systems with a new kernel version, I decided to do a dry run check on
> the root filesystem.  'btrfs check' returned a bunch of lines like:
>
> root 257 inode XXXXXX errors 2000, link count wrong
>         unresolved ref dir YYYYY index 53 namelen 3 name LOG filetype 0 errors 3, no dir item, no dir index
>
> I got about 20 messages like this with varying values for everything
> except the filetype and error counts.  Based on what I can tell, these
> look like orphaned inodex, but I'm not certain.
> Is it safe to tell BTRFS to try and fix these errors?

Is it consistent between boots? I have a system with SSD where if I
boot with rd.break=pre-mount, and run btrfs check, I sometimes get a
long string of similar messages. But upon reboot they don't happen
anymore.


-- 
Chris Murphy
