Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:56532 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab3HQPOn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 11:14:43 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so1494463eae.38
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 08:14:41 -0700 (PDT)
From: Mathijs Kwik <mathijs@bluescreen303.nl>
To: Xavier Bassery <xavier@bartica.org>
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problems with incremental btrfs send (out of order instructions?)
References: <CAKvOHKD+cYp+CO4XLXkktnFZ_5n1tZnbrqS3D+T8nJhVEReWig@mail.gmail.com>
	<51FA20FE.7020708@giantdisaster.de>
	<b866582a35e6e829b88bdea3df8a57b0@bartica.org>
Date: Sat, 17 Aug 2013 17:14:36 +0200
In-Reply-To: <b866582a35e6e829b88bdea3df8a57b0@bartica.org> (Xavier Bassery's
	message of "Sat, 17 Aug 2013 16:00:41 +0200")
Message-ID: <87zjsg8i3n.fsf@bluescreen303.nl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Xavier Bassery <xavier@bartica.org> writes:

> On 2013-08-01 10:49, Stefan Behrens wrote:
>> On Wed, 31 Jul 2013 23:33:59 +0200, Mathijs Kwik wrote:
>>> Hi all,
>>>
>>> For some time, I've successfully deployed btrfs send/receive as a
>>> viable backup solution.
>>> It's fast and flexible and nicely scriptable =)
>>> However, every once in a while, trouble strikes on the receiving end
>>> with a message like:
>>>
>>> ERROR: rename
>>> nixpkgs/pkgs/applications/version-management/subversion-1.2.x/default.nix
>>> -> o2979-81788-0 failed. No such file or directory
>>
>> I've also seen such an errors. It's an error in the send code.
>>
> [...]
>> If you enter a bug on bugzilla.kernel.org (refer to
>>
>> <https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F>),
>> you increase the probability that somebody fixes the issue some day
>> :)
>
>
> This bug has been reported in BZ #60673 [1] and was fixed in Josef's
> btrfs-next commit
> titled "Btrfs: check our parent dir when doing a compare send" [2].
> This fix hasn't been merged in the stable kernel yet.
>
> Thanks to all.

I have been using the patch for 10 days now, and it's a huge
improvement, but we're not out of the woods yet it seems :(

https://bugzilla.kernel.org/show_bug.cgi?id=60673

>
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=60673
> [2]
> http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/fs/btrfs/send.c?id=441f6d6f7115a927f3e13f7acc53184a6081dbe0
