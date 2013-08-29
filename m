Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:5310 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755861Ab3H2To7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 15:44:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130829194049.GR3115@carfax.org.uk>
Date: Thu, 29 Aug 2013 13:44:54 -0600
Cc: Zach Brown <zab@redhat.com>, Nick Lee <email@nickle.es>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <0E1979CF-25EC-47B2-B74E-9870F3D9C626@colorremedies.com>
References: <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es> <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com> <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com> <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com> <20130826193110.GO3115@carfax.org.uk> <20130829173519.GN26818@lenny.home.zabbo.net> <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com> <20130829194049.GR3115@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 29, 2013, at 1:40 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Aug 29, 2013 at 01:37:51PM -0600, Chris Murphy wrote:
>> 
>> "Proceeding will roll back the file system to a previous state, and may cause the loss of successfully written data. Proceed? (Y/N)"
> 
>   "... the loss of up to the last 30 seconds of successfully written data."
> 
>   Give the user enough information to make a sensible decision.

Certainly, if known for sure it won't be more than 30 seconds?



Chris Murphy