Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:49411 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3HQORR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 10:17:17 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id DF91347A093
	for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 16:01:05 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Sat, 17 Aug 2013 16:00:41 +0200
From: Xavier Bassery <xavier@bartica.org>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Mathijs Kwik <mathijs@bluescreen303.nl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problems with incremental btrfs send (out of order
 =?UTF-8?Q?instructions=3F=29?=
In-Reply-To: <51FA20FE.7020708@giantdisaster.de>
References: <CAKvOHKD+cYp+CO4XLXkktnFZ_5n1tZnbrqS3D+T8nJhVEReWig@mail.gmail.com>
 <51FA20FE.7020708@giantdisaster.de>
Message-ID: <b866582a35e6e829b88bdea3df8a57b0@bartica.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-08-01 10:49, Stefan Behrens wrote:
> On Wed, 31 Jul 2013 23:33:59 +0200, Mathijs Kwik wrote:
>> Hi all,
>>
>> For some time, I've successfully deployed btrfs send/receive as a
>> viable backup solution.
>> It's fast and flexible and nicely scriptable =)
>> However, every once in a while, trouble strikes on the receiving end
>> with a message like:
>>
>> ERROR: rename 
>> nixpkgs/pkgs/applications/version-management/subversion-1.2.x/default.nix
>> -> o2979-81788-0 failed. No such file or directory
>
> I've also seen such an errors. It's an error in the send code.
>
[...]
> If you enter a bug on bugzilla.kernel.org (refer to
> 
> <https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F>),
> you increase the probability that somebody fixes the issue some day 
> :)


This bug has been reported in BZ #60673 [1] and was fixed in Josef's 
btrfs-next commit
titled "Btrfs: check our parent dir when doing a compare send" [2].
This fix hasn't been merged in the stable kernel yet.

Thanks to all.


[1] https://bugzilla.kernel.org/show_bug.cgi?id=60673
[2] 
http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/commit/fs/btrfs/send.c?id=441f6d6f7115a927f3e13f7acc53184a6081dbe0
