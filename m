Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33077 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751717Ab3HZRgL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 13:36:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
Date: Mon, 26 Aug 2013 11:36:08 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
To: Nicholas Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 11:26 AM, Nicholas Lee <email@nickle.es> wrote:

> Good news everyone! I got this to mount again using btrfs chunk-recover on the partition! It took around a day for it to run the initial chunk recovery scan (iotop showed that I was limited by disk throughput) and another three hours for the actual chunk recovery (iops limited).

Interesting. I also found this:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/26748

I wonder, what in dmesg indicates that the chunk tree is broken, and thus chunk-recover should be used? Or would a btrfsck without repair indicate it? 


Chris Murphy