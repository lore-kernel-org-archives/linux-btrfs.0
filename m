Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48178 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169Ab3JDSyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Oct 2013 14:54:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSAW5-0003n9-M3
	for linux-btrfs@vger.kernel.org; Fri, 04 Oct 2013 20:54:21 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 20:54:21 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Oct 2013 20:54:21 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs recovery: What do the commands actually do?
Date: Fri, 04 Oct 2013 19:54:11 +0100
Message-ID: <l2n2sa$6rf$1@ger.gmane.org>
References: <l2mntu$416$1@ger.gmane.org> <pan$605b6$d8682eff$c911a507$660aae64@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <pan$605b6$d8682eff$c911a507$660aae64@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/13 19:32, Duncan wrote:
> Martin posted on Fri, 04 Oct 2013 16:47:19 +0100 as "condensed":
> 
>> There's ad-hoc comment for various commands to recover from filesystem
>> errors.
>>
>> But what do they actually do and when should what command be used?
>> What do they do exactly and what are the indicators to try using them?
>> Or when should you 'give up' on a filsystem and just retrieve whatever
>> data can be read and start again?
>>
>> All that lot sounds good for a wiki page ;-)
> 
> I recognize your name so you're a regular poster and may well have seen

Hail fellow Gentoo-er ;-)


This is a prod from the thread:

http://article.gmane.org/gmane.comp.file-systems.btrfs/28775


> this recover steps/order post from Hugo Mills, but you didn't mention it, 
> so...
> 
> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27999
> 
> As you suggest, that should really go in the wiki (maybe it's there 
> already since that post, I haven't actually checked recently, but your 
> post reads as if you looked and couldn't find a recovery list of this 
> nature), but I've not gotten around to creating an account for myself 
> there yet and committing it, and if no one else has either...
> 
> But I do have it bookmarked for posting here, and for the day I do create 
> myself that wiki account, if no one else has gotten to it by then...
> 
> And while that answers what and what order, it doesn't cover what the 
> commands actually do or why you'd /use/ that order, and that'd be very 
> good to add as well.

Yep.

I'm using this as a bit of a test case as to how best to recover from
whatever inevitable hiccups.

All the more important to gain a good understanding before doing similar
things to 16TB arrays...


Comment/advice welcomed (please).

Thanks,
Martin



