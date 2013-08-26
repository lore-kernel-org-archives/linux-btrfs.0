Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33299 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669Ab3HZTK5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 15:10:57 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
Date: Mon, 26 Aug 2013 13:10:54 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es> <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com> <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
To: Nick Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 11:41 AM, Nick Lee <email@nickle.es> wrote:

> There was a discussion on IRC a few days ago that the problem with the tree root's bloco was likely the result of either an issue with the disk itself, or the chunk tree/logical mappings. I ran the chunk recover, looked over the errors it found, and hit write. (If it failed, I was going to run something photorec, loss of organization as a side effect.)
> 
> I can write something more clear after my flight lands tomorrow if you want.

I'm just curious about when to use various techniques: -o recovery, btrfsck, chunk-recover, zero log.


Chris Murphy