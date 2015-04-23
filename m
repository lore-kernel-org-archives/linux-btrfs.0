Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35657 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbDWJbw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 05:31:52 -0400
Received: by iejt8 with SMTP id t8so56565210iej.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2015 02:31:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150422165347.GG4996@twin.jikos.cz>
References: <5535E4A8.8040600@gmail.com>
	<20150422165347.GG4996@twin.jikos.cz>
Date: Thu, 23 Apr 2015 05:31:51 -0400
Message-ID: <CAPL5yKfL_OkrS327FBmReejNxaswfEPyEwASBhd=WeJd1DfL+Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] btrfs-progs: optionally restore metadata
From: Dan Merillat <dan.merillat@gmail.com>
To: David Sterba <dsterba@suse.cz>, Dan Merillat <dan.merillat@gmail.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 22, 2015 at 12:53 PM, David Sterba <dsterba@suse.cz> wrote:
> Applied, thanks.
>
> In future patches, please stick to the coding style used in progs ([1]),
> I've fixed spacing around "=", comments and moved declarations before
> the statements.
>
> [1] https://www.kernel.org/doc/Documentation/CodingStyle

I'll try to clean it up more next time around.

>> @@ -1168,10 +1275,12 @@ int cmd_restore(int argc, char **argv)
>>               static const struct option long_options[] = {
>>                       { "path-regex", 1, NULL, 256},
>>                       { "dry-run", 0, NULL, 'D'},
>> +                     { "metadata", 0, NULL, 'm'},
>> +                     { "debug-regex", 0, NULL, 257},
>
> This was unused and I've removed it.

That's cruft and I thought I removed it from the patch, sorry.

Got your symlink code, I'll look at that today.
