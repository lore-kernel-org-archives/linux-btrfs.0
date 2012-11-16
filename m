Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from loup.kjorling.se ([87.237.208.114]:46851 "EHLO loup.kjorling.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2KPIjw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Nov 2012 03:39:52 -0500
Date: Fri, 16 Nov 2012 08:39:27 +0000
From: Michael =?utf-8?B?S2rDtnJsaW5n?= <michael@kjorling.se>
To: nemesis@icequake.net
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Several unhappy btrfs's after RAID meltdown
Message-ID: <20121116083927.GD10624@yeono.kjorling.se>
References: <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
 <20120207154225.GD5639@localhost.localdomain>
 <20120207174645.GE5639@localhost.localdomain>
 <20120207174907.GF5639@localhost.localdomain>
 <20120212163134.GA15216@localhost.localdomain>
 <20120601143857.GB25227@localhost.localdomain>
 <20121115160003.GA32396@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20121115160003.GA32396@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15 Nov 2012 10:00 -0600, from nemesis-lists@icequake.net (Ryan C. Underwood):
> There is still a lot of data missing though.  If I am reading this
> correctly there was about 300GB of data which compressed to 254GB
> on-disk.
> 
> Label: 'vicep-library'  uuid: 89b14d35-b31a-4fbe-a2d9-cb83cbcd3851
>         Total devices 1 FS bytes used 254.35GB
>         devid    1 size 1.00TB used 299.04GB path /dev/dm-27

Isn't that the other way around? The file system has allocated a total
of 299 GB across devid 1 (to system, metadata and data), and of those,
254 GB are in actual use currently. Remember btrfs "overallocates" so
it doesn't have to constantly allocate more space for each separate
kind of usage as data is added to the file system.

That does not radically alter your conclusion, though. 36 GB is still
only a small fraction of the total amount of data stored, assuming
that the btrfs tool output you showed can be trusted.

-- 
Michael Kjörling • http://michael.kjorling.se • michael@kjorling.se
                “People who think they know everything really annoy
                those of us who know we don’t.” (Bjarne Stroustrup)
