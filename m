Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44218 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab2LIJE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 04:04:56 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so5322395ieb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Dec 2012 01:04:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMRmmp+qQZg2_vkZ9bfLFg-AC20SGkmEo4cdCOQEs+4i1JUeDQ@mail.gmail.com>
References: <CAMRmmp+qQZg2_vkZ9bfLFg-AC20SGkmEo4cdCOQEs+4i1JUeDQ@mail.gmail.com>
Date: Sun, 9 Dec 2012 11:04:56 +0200
Message-ID: <CAOcd+r38EaSD1UPCYi8JHCv7kBmLjmvVi0mBrX=d+Ncd6K=dYA@mail.gmail.com>
Subject: Re: send/receive questions
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Ins <insfocus@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>     4. support this scene,
>         When doing the receive process, if it suddently be stopped,
> how to continue the receive process.

I sent a proposal and a patch to implement this in
http://www.spinics.net/lists/linux-btrfs/msg19387.html. However, it is
not easy to make this patch accepted. Also, I found a bug in this
patch so please don't try it out.

Alex.
