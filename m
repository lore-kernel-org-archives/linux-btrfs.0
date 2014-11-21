Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:61543 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbaKUCUX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 21:20:23 -0500
Received: by mail-yh0-f47.google.com with SMTP id f73so1947276yha.6
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 18:20:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
Date: Thu, 20 Nov 2014 19:20:22 -0700
Message-ID: <CAJCQCtQb-hyYVHvhJkS01EKpr_ekSSsuUPY5hSmd03SoGqiPXA@mail.gmail.com>
Subject: Re: Changing label few times killed filesystem?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 20, 2014 at 6:27 PM, Boris Chernov <aqs1024@hotmail.com> wrote:

>     Since it failed after "checking extents" I decided to try
> --init-extent-tree:

There might be hope yet if you didn't use --repair which is said on
the wiki and many times on this list is kindof a last resort. But at
the very least before going with the hammer approach you should
upgrade your btrfs-progs which is kind old. Current is 3.17.2. I
suggest upgrading and just posting the results from 'btrfs check
<device>' without any options and see what you get. This check and
--repair code are mostly in btrfs-progs, whereas the mount time fixing
code is in the kernel. So upgrading btrfs-progs may be sufficient for
your case, but ultimately it might be necessary to go to a newer
kernel also.

> Btrfs v3.14.1


-- 
Chris Murphy
