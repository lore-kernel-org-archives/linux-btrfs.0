Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36694 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754297Ab3H2U2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 16:28:43 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2D27D640-86E0-4E49-8874-81249DF9919A@colorremedies.com>
Date: Thu, 29 Aug 2013 14:28:40 -0600
Cc: Zach Brown <zab@redhat.com>, Nick Lee <email@nickle.es>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <D4E3996A-96B3-439E-B54F-BFA20F999E75@colorremedies.com>
References: <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es> <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com> <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com> <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com> <20130826193110.GO3115@carfax.org.uk> <20130829173519.GN26818@lenny.home.zabbo.net> <528DF163-08F5-412D-8351-ACC853AC418D@colorremedies.com> <20130829194049.GR3115@carfax.org.uk> <0E1979CF-25EC-47B2-B74E-9870F3D9C626@colorremedies.com> <20130829195322.GS3115@carfax.org.uk> <2D27D640-86E0-4E49-8874-81249DF9919A@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 29, 2013, at 2:19 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Aug 29, 2013, at 1:53 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>> On Thu, Aug 29, 2013 at 01:44:54PM -0600, Chris Murphy wrote:
>>> 
>>> Certainly, if known for sure it won't be more than 30 seconds?
>> 
>>  Mmm... it'll depend on the setting of the commit period, which up
>> until a couple of weeks ago was always 30s, but someone posted a patch
>> to give it a config knob…
> 
> 
> 
> "Proceeding will roll back the file system to a previous state, and may cause the loss of successfully written data since the last commit period (30 seconds by default). Proceed? (Y/N)"

And an important side question is whether "may" is the correct word, or if it should be "will" cause loss of…


Chris Murphy