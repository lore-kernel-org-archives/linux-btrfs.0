Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60782 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaKUFx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 00:53:56 -0500
References: <546CB84B.8010200@sandeen.net> <20141121044403.GE5834@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20141121044403.GE5834@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <DF18BC32-9618-4102-84E4-12487BC6CA06@sandeen.net>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] fstests: mark replace tests in btrfs/group
Date: Thu, 20 Nov 2014 23:53:52 -0600
To: Eryu Guan <eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Nov 20, 2014, at 10:44 PM, Eryu Guan <eguan@redhat.com> wrote:
> 
>> On Wed, Nov 19, 2014 at 09:33:31AM -0600, Eric Sandeen wrote:
>> A couple tests exercise replace but were not marked as such
>> in the group file.
> 
> Hi Eric,
> 
> I have a patch sitting in my git tree that adds most of btrfs tests in
> one or more groups, I'll send it out for review soon.
> 
Thanks, much more complete than mine.

-Eric

> Thanks,
> Eryu
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>> 
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index 9adf862..1f23979 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -13,7 +13,7 @@
>> 008 auto quick
>> 009 auto quick
>> 010 auto quick
>> -011 auto
>> +011 auto replace
>> 012 auto
>> 013 auto quick
>> 014 auto
>> @@ -22,7 +22,7 @@
>> 017 auto quick
>> 018 auto quick
>> 019 auto quick
>> -020 auto quick
>> +020 auto quick replace
>> 021 auto quick
>> 022 auto
>> 023 auto
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
