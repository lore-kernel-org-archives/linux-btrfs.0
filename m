Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35154 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaCYA5V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 20:57:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSFg6-0003yF-56
	for linux-btrfs@vger.kernel.org; Tue, 25 Mar 2014 01:57:18 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 01:57:18 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 01:57:18 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Suggestion: Anti-fragmentation safety catch (RFC)
Date: Tue, 25 Mar 2014 00:57:05 +0000
Message-ID: <lgqk8i$j4p$1@ger.gmane.org>
References: <lgq247$lgk$1@ger.gmane.org> <pan$191e5$f5ca4422$3e26f4d9$15d09a73@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$191e5$f5ca4422$3e26f4d9$15d09a73@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24/03/14 20:19, Duncan wrote:
> Martin posted on Mon, 24 Mar 2014 19:47:34 +0000 as excerpted:
> 
>> Possible fix:
>>
>> btrfs checks the ratio of filesize versus number of fragments and for a
>> bad ratio either: [...]
> 
>> 3: Automatically defragments the file.
> 
> See the autodefrag mount option.
> 
> =:^)

Thanks for that!

So...

https://btrfs.wiki.kernel.org/index.php/Mount_options
####
autodefrag (since [kernel] 3.0)

Will detect random writes into existing files and kick off background
defragging. It is well suited to bdb or sqlite databases, but not
virtualization images or big databases (yet). Once the developers make
sure it doesn't defrag files over and over again, they'll move this
toward the default.
####

Looks like I might be a good test case :-)


What's the problem for big images or big databases? What is considered
"big"?

Thanks,
Martin

