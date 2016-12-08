Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34212 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbcLHRyU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Dec 2016 12:54:20 -0500
Received: by mail-io0-f193.google.com with SMTP id y124so1560809iof.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Dec 2016 09:54:19 -0800 (PST)
Subject: Re: [RESEND][PATCH v2] btrfs-progs: add dev stats returncode option
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20161205183520.67039-1-ahferroin7@gmail.com>
 <20161208172030.GJ12522@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6eedaa73-2bb5-62aa-7570-4b836d589854@gmail.com>
Date: Thu, 8 Dec 2016 12:54:14 -0500
MIME-Version: 1.0
In-Reply-To: <20161208172030.GJ12522@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-08 12:20, David Sterba wrote:
> On Mon, Dec 05, 2016 at 01:35:20PM -0500, Austin S. Hemmelgarn wrote:
>> Currently, `btrfs device stats` returns non-zero only when there was an
>> error getting the counter values.  This is fine for when it gets run by a
>> user directly, but is a serious pain when trying to use it in a script or
>> for monitoring since you need to parse the (not at all machine friendly)
>> output to check the counter values.
>>
>> This patch adds an option ('-s') which causes `btrfs device stats`
>> to set bit 6 in the return code if any of the counters are non-zero.
>> This greatly simplifies checking from a script or monitoring software if
>> any errors have been recorded.  In the event that this switch is passed
>> and an error occurs reading the stats, the return code will have bit
>> 0 set (so if there are errors reading counters, and the counters which
>> were read were non-zero, the return value will be 65).
>
> So a typical check in a script would look for either 64 or 65 returned
> from the command, I don't think we can do it simpler. The option naming
> is a bit confusing to me, as it duplicates the 'stats' from the command
> itself. I'd suggest to use '--check' instead, does it sound OK to you?
>
> I'll apply the patch as-is for now (and maybe do some cleanups in the
> surrounding code).
>
Yeah, --check is fine.  Like I said, I'm not too picky about the name as 
long as it works.
