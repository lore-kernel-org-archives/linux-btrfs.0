Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35935 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbcE2RLE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 13:11:04 -0400
Received: by mail-oi0-f43.google.com with SMTP id j1so240825802oih.3
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 10:11:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2mtxyz=_OfsgFSpGvUsYbdEqhOjOc-Dpvdd=aOwpeQ-Q@mail.gmail.com>
References: <CAEtw4r2aknnz=+FCGq2ysSQT3K3ZHmZqnbPpyvr+C7QD6TyEAQ@mail.gmail.com>
	<CAGGqMYS_SLn9RY8Gtgf5nkwyXnOr57ehtYSH=HugiEeA8D_chw@mail.gmail.com>
	<CAEtw4r2mtxyz=_OfsgFSpGvUsYbdEqhOjOc-Dpvdd=aOwpeQ-Q@mail.gmail.com>
Date: Sun, 29 May 2016 11:11:02 -0600
Message-ID: <CAJCQCtTpnr6OLg=0pcovK8aYUAgPLDAsYv5sam9AzWSfOBzZcA@mail.gmail.com>
Subject: Re: Resize doesnt work as expected
From: Chris Murphy <lists@colorremedies.com>
To: Peter Becker <floyd.net@gmail.com>
Cc: Alexander Fougner <fougner89@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 28, 2016 at 3:42 PM, Peter Becker <floyd.net@gmail.com> wrote:
> Thanks for the clarification. I've probably overlooked this.
>
> But should "resize max" does not do what you expect instead of falling
> back on an "invisible" 1?

How does it know what the user expects?

I think the issue is not with the resize command, but rather the
replace command does not include the resize max operation. Presumably
the user intends the entire block device provided as the target for
replacement to be used.

So I think the mistake is replace assumes the user wants to use the
same amount of space as the former block device. I think if the user
wanted to use the former block device size on the new block device,
they'd partition it and use the partition as the target.


-- 
Chris Murphy
