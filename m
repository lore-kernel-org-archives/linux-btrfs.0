Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:35444
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbbHKTmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 15:42:12 -0400
Subject: Re: Missing dedupe/locking patch in integration-4.2 tree?
To: Mark Fasheh <mfasheh@suse.de>
References: <55C46842.2000301@googlemail.com>
 <20150811185842.GN7507@wotan.suse.de>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55CA5012.7070709@googlemail.com>
Date: Tue, 11 Aug 2015 21:42:10 +0200
MIME-Version: 1.0
In-Reply-To: <20150811185842.GN7507@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/11/15 20:58, Mark Fasheh wrote:
> On Fri, Aug 07, 2015 at 10:11:46AM +0200, Holger Hoffstätte wrote:
>>
>> Mark's patch titled
>>
>>   "[PATCH 3/5] btrfs: fix clone / extent-same deadlocks" [1]
>>
>> from his "btrfs: dedupe fixes, features" series is missing from the integration-4.2 tree and 4.2-rc5, where it still applies cleanly (as of 5 mins ago).
>>
>> Any particular reason why this was silently dropped?
> 
> Same question here, I noticed this shortly after everything went upstream
> and was planning a resend but it would be great if you could tell us whether
> something was wrong with the patch or if it just got lost in the shuffle (no
> big deal).
> 	--Mark

I saw this morning that it went into integration-4.3:

https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.3&id=293a8489f300536dc6d996c35a6ebb89aa03bab2

So probably just an oversight.

-h

