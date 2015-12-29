Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33124 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbL2C3R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 21:29:17 -0500
Received: by mail-io0-f175.google.com with SMTP id q21so34631204iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 18:29:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$18231$95fbaba1$d74d6453$6c085a71@cox.net>
References: <CAJCQCtTKWdAknD9Cbr0kfVNsZ5GW0jH+ZE8ZsNmJ14223aVo2A@mail.gmail.com>
	<pan$18231$95fbaba1$d74d6453$6c085a71@cox.net>
Date: Mon, 28 Dec 2015 19:29:17 -0700
Message-ID: <CAJCQCtQW0gwbniCNPkVeiThRtF-suJFeFBBTxnsn0Q+VgmnYiQ@mail.gmail.com>
Subject: Re: [bug] btrfs fi usage reports bogus 16EiB free space
From: Chris Murphy <lists@colorremedies.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 28, 2015 at 7:22 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Mon, 28 Dec 2015 17:12:13 -0700 as excerpted:
>
>> Filed a bug:
>> https://bugzilla.kernel.org/show_bug.cgi?id=110111
>>
>> The gist is that with a full USB stick, 'btrfs fi usage' reports:
>>
>>     Free (estimated):  16.00EiB (min: 16.00EiB)
>>
>> Which is clearly wrong, but very exciting to imagine what such a thing
>> would look like!
>
> [After double-checking the bug report to ensure it was as I suspected, as
> the critical line wasn't included above.]
>
> ENOTIMPLEMENTED.  See that "WARNING: MIXED blockgroups not handled" line
> at the top? =:^)

Unrelated. When the mkfs is new and nothing is on the fs, I get this:

    Free (estimated):           7.44GiB    (min: 7.44GiB)

I'm not certain at what point the fs starts to report 16.00EiB but
it's not immediate.




-- 
Chris Murphy
