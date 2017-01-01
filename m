Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36530 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbdAAAGT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Dec 2016 19:06:19 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so62517555oie.3
        for <linux-btrfs@vger.kernel.org>; Sat, 31 Dec 2016 16:06:19 -0800 (PST)
Date: Sat, 31 Dec 2016 18:06:14 -0600
From: Glenn Washburn <development@efficientek.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs send does not preserve reflinked files within subvolumes.
Message-ID: <20161231180614.3c78537b@crass-Ideapad-Z570>
In-Reply-To: <a9f1fb46-5311-2279-68a0-66cf9979ebac@cn.fujitsu.com>
References: <20161228204430.348cb61f@crass-Ideapad-Z570>
        <c4956c5f-b9e2-fe28-0c0d-4e6a03da9a7c@cn.fujitsu.com>
        <20161229042055.17e4774e@crass-Ideapad-Z570>
        <a9f1fb46-5311-2279-68a0-66cf9979ebac@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Qu,

On Fri, 30 Dec 2016 08:47:07 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Hi Glenn,
> 
> Confirmed it's kernel bug.
> Send stream doesn't contain the clone operation.
> 
> So it's kernel send to blame.
> 
> >
> > As I was using btrgs-progs v4.4, I've compiled v4.9 to get the nice
> > --dump option for receive (which you seem to have added, kudos!).
> > The output of the dump option is in the *.recv-dump.log files.
> > However, I see no clone command in the output.
> >
> > Keep in mind that I'm running Ubuntu kernel 4.4.0-53-generic, which
> > I believe to be mostly v4.4.30 with a few patches.  Any ideas when
> > send started using "clone" in the kernel?  
> 
> Not pretty sure about from which exact kernel version send can detect 
> reflink.
> 
> AFAIC I sent an RFC patch to disable reflink detection in send in
> July 2016, and it just got rejected.
> 
> So I assume at least v4.6 kernel works.

I've tested with Ubuntu's 4.8 kernel and still no luck.  What kernel
version are you using? And what version of btrfs-progs?

If I understand you correctly, you're trying to submit a patch that
disables reflink detection, which would prevent what I'm trying to do?
Why is this desired and is it able to be switched off?

Thanks,
Glenn
