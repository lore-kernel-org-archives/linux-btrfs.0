Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34819 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcARMYZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 07:24:25 -0500
Received: by mail-io0-f180.google.com with SMTP id 77so516199181ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jan 2016 04:24:24 -0800 (PST)
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain
 like I'm five pls.
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>,
        Duncan <1i5t5.duncan@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
 <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
 <CAGfcS_mepN3bcgSo6qgjVAyROoRpX3G05dAm=-g-eOhSkv+GZA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <569CD935.4030708@gmail.com>
Date: Mon, 18 Jan 2016 07:23:17 -0500
MIME-Version: 1.0
In-Reply-To: <CAGfcS_mepN3bcgSo6qgjVAyROoRpX3G05dAm=-g-eOhSkv+GZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-16 13:07, Rich Freeman wrote:
> On Sat, Jan 16, 2016 at 9:10 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:
>>
>>> Is there any urgency for dedup? What's wrong with storing the hash on
>>> disk with the block and having a separate process dedup the written data
>>> over time;
>>
>> There's actually uses for both inline and out-of-line[1] aka delayed
>> dedup.  Btrfs already has a number of independent products doing various
>> forms of out-of-line dedup, so what's missing and being developed now is
>> the inline dedup option, which being directly in the write processing,
>> must be handled by btrfs itself -- it can't be primarily done by third
>> parties with just a few kernel calls, like out-of-line dedup can.
>
> Does the out-of-line dedup option actually utilize stored hashes, or
> is it forced to re-read all the data to compute hashes?  If it is
> collecting checksums/etc is this done efficiently?
AFAIK, duperemove has the option to store block hashes in a database to 
save them between runs (I'm pretty sure that it invalidates hashes if 
the file containing the block changed, but I'm not certain).
>
> I think he is actually suggesting a hybrid approach where a bit of
> effort is done during operations to greatly streamline out-of-line
> deduplication.  I'm not sure how close we are to that already, or if
> any room for improvement remains.
There isn't any implementation I know of that does this.  In theory, it 
would be pretty easy if we could somehow get block checksums  from BTRFS 
in userspace.

