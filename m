Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34207 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbGINAH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 09:00:07 -0400
Received: by iebmu5 with SMTP id mu5so175557785ieb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 06:00:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKhV5s5CzWNZUh8PXacc_QTkA4WXxb1sVFFSOL7iZT0CXRE84Q@mail.gmail.com>
References: <CAKhV5s4=WR6t35Vo0JWekMKiv2ZOJF-py4sVSB4THZNd7cOe_Q@mail.gmail.com>
 <CAKhV5s4M4fKgm+ZkCZHQL8QK20Oq19Nkj9CKOncjvFQbweY-Eg@mail.gmail.com>
 <20150707155014.GF10539@carfax.org.uk> <CAKhV5s5CzWNZUh8PXacc_QTkA4WXxb1sVFFSOL7iZT0CXRE84Q@mail.gmail.com>
From: David Wilhelm <thefeshy@gmail.com>
Date: Thu, 9 Jul 2015 08:59:37 -0400
Message-ID: <CAKhV5s5Cpryj9ivjTkpGJmrJry9hJ_cUy_MH1tJbgYb3BmLV2w@mail.gmail.com>
Subject: Re: kernel crash on btrfs device delete missing
To: David Wilhelm <thefeshy@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was finally able to remove the missing device.  I updated the bug
report, but in case anyone else has this problem I wanted to update
here as well.

I deleted all snapshot subvolumes on the pool (between 20 and 30), and
was able to delete the missing device then without issue.  This took
two tries, because the first time I did not wait for btrfs-cleanup to
finish actually deleting the subvolumes (as it does this in the
background.)  The second time I deleted the subvolumes then waited
until all disk activity (reported by iotop) had ceased, and re-mounted
the pool to be sure.  After that the rebalance/delete worked without
issue.

I am not certain if this is because of a bug with rebalancing
snapshots or because the some bad data that was causing the segfault
just happened to be in the snapshots.

On Tue, Jul 7, 2015 at 12:45 PM, David Wilhelm <thefeshy@gmail.com> wrote:
> Thanks.  I've submitted it as issue 101141
>
> https://bugzilla.kernel.org/show_bug.cgi?id=101141
>
>
>>    That looks like the kind of thing you need a developer for. You've
>> already reported it here, but sticking a copy of what you've
>> discovered so far into bugzilla.kernel.org may help it not to get
>> lost.
>>
>>    Hugo.
>>
>> --
>> Hugo Mills             | "I don't like the look of it, I tell you."
>> hugo@... carfax.org.uk | "Well, stop looking at it, then."
>> http://carfax.org.uk/  |
>> PGP: E2AB1DE4          |                                             The Goons
