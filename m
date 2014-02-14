Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57572 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751089AbaBNGaH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 01:30:07 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: errors 400, nbytes wrong, was: Help repairing corrupt btrfs -- btrfsck --repair doesn't change anything
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <9C96B28C-A997-4CBD-8113-A8DAC8ED192B@colorremedies.com>
Date: Thu, 13 Feb 2014 23:30:05 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <111F61D6-90BD-4343-BB0A-A5AFB0F9F744@colorremedies.com>
References: <CAKCAbMjTHxCQ_rHa2+jV6eEGAGLhYeTWf-9a9y9gp6knzw-xcg@mail.gmail.com> <0CB1F05D-28F2-4497-A5F9-F9F84FA4712B@colorremedies.com> <9C96B28C-A997-4CBD-8113-A8DAC8ED192B@colorremedies.com>
To: Zack Weinberg <zackw@panix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 13, 2014, at 10:10 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Feb 13, 2014, at 9:48 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>> 
>> In any case, I'm confused also if there's a real problem or not. I guess confusion about the state of a file system itself isn't good. But I figure it's probably not a serious error or there'd be mount error messages, and would maybe only mount ro.
> 
> Hmm, another case on a fairly new file system. The commonality with my case and this one, is the file system is created with kernel 3.11 and btrfs-progs-0.20.rc1.20131114git9f0c53f-1.fc20 - but the problem materializes at some later point, inconsistently.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1037963

Aha, I think this was fairly thoroughly explained here:
https://bugzilla.kernel.org/show_bug.cgi?id=68411


Chris Murphy