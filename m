Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36309 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756648AbcGZRZQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 13:25:16 -0400
Received: by mail-io0-f196.google.com with SMTP id y34so2625331ioi.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 10:25:15 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: dsterba@suse.cz, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <29743bb5-3b69-4d13-5737-cea6dd8f6a46@jp.fujitsu.com>
 <20160726170739.GM30795@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5a84933a-1990-f1f8-ede1-5af9e54a0d88@gmail.com>
Date: Tue, 26 Jul 2016 13:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <20160726170739.GM30795@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-26 13:07, David Sterba wrote:
> On Mon, Jul 11, 2016 at 10:44:30AM +0900, Satoru Takeuchi wrote:
>>> +					chdir("/");
>>
>> You should check the return value of chdir(). Otherwise
>> we get the following warning message at the build time.
>
> Can we actually fail to change directory to '/' ? Otherwise I think the
> warning should be silenced so the build is clean.
It is theoretically possible, but in practice it means you either have 
failing hardware or your kernel is broken somehow, both of which should 
be causing all kinds of other issues, and thus we don't really gain 
anything from trying to catch the error.

