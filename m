Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:57425 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaHDPTp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 11:19:45 -0400
Received: by mail-oi0-f51.google.com with SMTP id g201so4707083oib.10
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 08:19:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6493655.Zcj5VSyTA2@xev>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<20140804113231.GD31950@carfax.org.uk>
	<CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
	<6493655.Zcj5VSyTA2@xev>
Date: Mon, 4 Aug 2014 10:19:41 -0500
Message-ID: <CAKcLGm_hopombtQmzt6BGGNw4nvXO7ufePw6unR9z3zhX32pQw@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: russell@coker.com.au
Cc: Peter Waller <peter@scraperwiki.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 4, 2014 at 9:47 AM, Russell Coker <russell@coker.com.au> wrote:
> If you regularly run a scrub with options such as "-dusage=50 -musage=10" then
> the amount of free space in metadata chunks will tend to be a lot greater than
> that in data chunks.
>

Just to clarify for posterity, I'm pretty sure you meant 'balance'
with "-dusage=50 -musage=10" instead of 'scrub'.
