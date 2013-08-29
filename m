Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:22214 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755730Ab3H2Th7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:37:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130829173519.GN26818@lenny.home.zabbo.net>
Date: Thu, 29 Aug 2013 13:37:51 -0600
Cc: Hugo Mills <hugo@carfax.org.uk>, Nick Lee <email@nickle.es>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com>
References: <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es> <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com> <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com> <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com> <20130826193110.GO3115@carfax.org.uk> <20130829173519.GN26818@lenny.home.zabbo.net>
To: Zach Brown <zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 29, 2013, at 11:35 AM, Zach Brown <zab@redhat.com> wrote:

>>   If those fail, then look in dmesg for errors relating to the log
>> tree -- if that's corrupt and can't be read (or causes a crash), use
>> btrfs-zero-log.
> 
> In a bit of a tangent:
> 
> btrfs-zero-log throws away data that fsync/sync could have previously
> claimed was stable on disk.
> 
> Given how often this is thrown around as a solution to a broken
> partition, should the tool jump up and down and make it clear that it's
> about to roll the file system back?  This seems like relevant
> information.
> 
> Right now, as far as I can tell, it's completely undocumented and
> silent.

Yes, I think it helps remove some burden on the list answering questions about a tool that doesn't have any documentation, to have a warning.

How much longer will btrfs-zero-log be needed? If whatever it's doing isn't obviated by future improvements to btrfsck, and this sort of big hammer approach is still needed in some worse case scenarios, then it probably hurts no one to flag the user with essentially how you described it. I think documentation is a greater burden to create, and less likely to be consulted.

"Proceeding will roll back the file system to a previous state, and may cause the loss of successfully written data. Proceed? (Y/N)"

Alternative language could include a suggestion or reminder of what should be tried before proceeding, if applicable.



Chris Murphy