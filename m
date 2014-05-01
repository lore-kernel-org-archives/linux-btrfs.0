Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57717 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaEALdm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 May 2014 07:33:42 -0400
Received: by mail-ig0-f181.google.com with SMTP id h18so366032igc.8
        for <linux-btrfs@vger.kernel.org>; Thu, 01 May 2014 04:33:42 -0700 (PDT)
Message-ID: <53623119.8070809@gmail.com>
Date: Thu, 01 May 2014 07:33:45 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Felix Homann <linuxaudio@showlabor.de>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs on bcache
References: <CAFz=ag4x7TY5AYpx-Oubi6S-9xR7bXRBYK3zLihMpgpmSVOi3w@mail.gmail.com>
In-Reply-To: <CAFz=ag4x7TY5AYpx-Oubi6S-9xR7bXRBYK3zLihMpgpmSVOi3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-04-30 14:16, Felix Homann wrote:
> Hi,
> a couple of months ago there has been some discussion about issues
> when using btrfs on bcache:
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018
> 
> From looking at the mailing list archives I cannot tell whether or not
> this issue has been resolved in current kernels from either bcache's
> or btrfs' side.
> 
> Can anyone tell me what's the current state of this issue? Should it
> be safe to use btrfs on bcache by now?

In all practicality, I don't think anyone who frequents the list knows.
 I do know that there are a number of people (myself included) who avoid
bcache in general because of having issues with seemingly random kernel
OOPSes when it is linked in (either as a module or compiled in), even
when it isn't being used.  My advice would be to just test it with some
non-essential data (maybe set up a virtual machine?).
