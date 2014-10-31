Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:62997 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaCl3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 22:41:29 -0400
Received: by mail-qg0-f44.google.com with SMTP id q107so4971580qgd.17
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 19:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
References: <CAGwxe4hoJa6h3=qmsa6k+AzienjwZ2eifakKzhanXZVCru9koA@mail.gmail.com>
	<CAGwxe4inBLYrbq2t1T004dGR_vfE-GwgU=fho=SCDBa6LOkWow@mail.gmail.com>
Date: Thu, 30 Oct 2014 22:41:28 -0400
Message-ID: <CAGfcS_=f2TRGbeWpE186xE89jnXmPb=qiN6mPgjQGJRRX3UJ1g@mail.gmail.com>
Subject: Re: filesystem corruption
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Tobias Holst <tobby@tobby.eu>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 30, 2014 at 9:02 PM, Tobias Holst <tobby@tobby.eu> wrote:
> Addition:
> I found some posts here about a general file system corruption in 3.17
> and 3.17.1 - is this the cause?
> Additionally I am using ro-snapshots - maybe this is the cause, too?
>
> Anyway: Can I fix that or do I have to reinstall? Haven't touched the
> filesystem, just did a scrub (found 0 errors).
>

Yup - ro-snapshots is a big problem in 3.17.  You can probably recover now by:
1.  Update your kernel to 3.17.2 - that takes care of all the big
known 3.16/17 issues in general.
2.  Run btrfs check using btrfs-tools 3.17.  That can clean up the
broken snapshots in your filesystem.

That is fairly likely to get your filesystem working normally again.
It worked for me.  I was getting some balance issues when trying to
add another device and I'm not sure if 3.17.2 totally fixed that - I
ended up cancelling the balance and it will be a while before I have
to balance this particular filesystem again, so I'll just hold off and
hope things stabilize.

--
Rich
