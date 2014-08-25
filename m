Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:58676 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933543AbaHYWnu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 18:43:50 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: typo in btrfs-progs master/v3.16.x
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140825223216.GL29981@suse.cz>
Date: Mon, 25 Aug 2014 16:43:49 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <7B639701-531C-4C1B-898A-31BF9CEB84B9@colorremedies.com>
References: <AD5C5B4A-E27D-4206-8552-5483EDB1BE98@colorremedies.com> <20140825223216.GL29981@suse.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 25, 2014, at 4:32 PM, David Sterba <dsterba@suse.cz> wrote:

> On Mon, Aug 25, 2014 at 04:09:16PM -0600, Chris Murphy wrote:
>> static const char * const cmd_scrub_start_usage[] = {
>>        "btrfs scrub start [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>",
>> -       "Start a new scrub. If a scrub is already running, the new one fails.",
>> +       "Start a new scrub",
>>        "",
>>        "-B     do not background",
>>        "-d     stats per device (-B only)",
>>        "-q     be quiet",
>>        "-r     read only mode",
>> -       "-R     raw print mode, print full data instead of summary",
>> +       "-R     raw print mode, print full data instead of summary"
>> 
>> 
>> Looks like a missing , at the end of this line. All other lines end in ,
> 
> Thanks for checking, the v3.16.x version is correct.

Right. I had the diffs reversed from what I thought they were, so I came to the wrong conclusion.

Chris Murphy