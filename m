Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33373 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbcAPSHd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jan 2016 13:07:33 -0500
Received: by mail-io0-f170.google.com with SMTP id q21so515872354iod.0
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 10:07:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
	<pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
Date: Sat, 16 Jan 2016 13:07:32 -0500
Message-ID: <CAGfcS_mepN3bcgSo6qgjVAyROoRpX3G05dAm=-g-eOhSkv+GZA@mail.gmail.com>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 16, 2016 at 9:10 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
>
>> Is there any urgency for dedup? What's wrong with storing the hash on
>> disk with the block and having a separate process dedup the written data
>> over time;
>
> There's actually uses for both inline and out-of-line[1] aka delayed
> dedup.  Btrfs already has a number of independent products doing various
> forms of out-of-line dedup, so what's missing and being developed now is
> the inline dedup option, which being directly in the write processing,
> must be handled by btrfs itself -- it can't be primarily done by third
> parties with just a few kernel calls, like out-of-line dedup can.

Does the out-of-line dedup option actually utilize stored hashes, or
is it forced to re-read all the data to compute hashes?  If it is
collecting checksums/etc is this done efficiently?

I think he is actually suggesting a hybrid approach where a bit of
effort is done during operations to greatly streamline out-of-line
deduplication.  I'm not sure how close we are to that already, or if
any room for improvement remains.

--
Rich
