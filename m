Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55978 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbbLCGom (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Dec 2015 01:44:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a4Nd6-0007tc-DI
	for linux-btrfs@vger.kernel.org; Thu, 03 Dec 2015 07:44:36 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 07:44:36 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Dec 2015 07:44:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug/regression: Read-only mount not read-only
Date: Thu, 3 Dec 2015 06:44:26 +0000 (UTC)
Message-ID: <pan$15841$bf660fb2$998b376$ea417760@cox.net>
References: <20151128134634.GF24333@carfax.org.uk>
	<20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
	<201512021725.32750.russell@coker.com.au>
	<565EB480.4010509@cn.fujitsu.com> <565EB878.9090501@cn.fujitsu.com>
	<565F2260.1080004@redhat.com> <565F2EF7.5000109@gmail.com>
	<565F753B.5020000@redhat.com> <565F8158.4090304@gmx.com>
	<20151202235155.GM8775@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Wed, 02 Dec 2015 23:51:55 +0000 as excerpted:

> On Thu, Dec 03, 2015 at 07:40:08AM +0800, Qu Wenruo wrote:
>> 
>> Not remountable is very good to implement it.
>> Makes things super easy to do.
>> 
>> Or we will need to add log replay for remount time.
>> 
>> I'd like to implement it first for non-remountable case as a try. And
>> for the option name, I prefer something like "notreereplay", but I
>> don't consider it the best one yet....
> 
>    Thinking out loud...
> 
> no-log-replay, no-log, hard-ro, ro-log,
> really-read-only-i-mean-it-this-time-honest-guvnor
> 
> Delete hyphens at your pleasure.

I want the bikeshed green with black polkadots! =:^)

More seriously, ro-noreplay ?

As Hugo says, norecovery clashes with the recovery option we already 
have, so unless we _really_ want to maintain cross-filesystem mount 
option compatibility, that's not going to work.

I'm not sure we want to encourage thinking of it as a log, since it's not 
a log in the journalling-filesystem sense but much more limited.

And I think ro needs to be in there for clarity.

hard-ro strikes my fancy as well, but ro-noreplay seems clearer to me.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

