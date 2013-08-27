Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49594 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752090Ab3H0Djt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 23:39:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130826193110.GO3115@carfax.org.uk>
Date: Mon, 26 Aug 2013 21:39:46 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <F46B46C9-705F-4645-A14F-83C0DDC24461@colorremedies.com>
References: <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com> <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com> <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es> <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es> <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com> <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com> <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com> <20130826193110.GO3115@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 26, 2013, at 1:31 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>   Let's assume that you don't have a physical device failure (which
> is a different set of tools -- mount -odegraded, btrfs dev del
> missing).
> 
>   First thing to do is to take a btrfs-image -c9 -t4 of the
> filesystem, and keep a copy of the output to show josef. :)
> 
>   Then start with -orecovery and -oro,recovery for pretty much
> anything.
> 
>   If those fail, then look in dmesg for errors relating to the log
> tree -- if that's corrupt and can't be read (or causes a crash), use
> btrfs-zero-log.
> 
>   If there's problems with the chunk tree -- the only one I've seen
> recently was reporting something like "can't map address" -- then
> chunk-recover may be of use.
> 
>   After that, btrfsck is probably the next thing to try. If options
> -s1, -s2, -s3 have any success, then btrfs-select-super will help by
> replacing the superblock with one that works. If that's not going to
> be useful, fall back to btrfsck --repair.
> 
>   Finally, btrfsck --repair --init-extent-tree may be necessary if
> there's a damaged extent tree. Finally, if you've got corruption in
> the checksums, there's --init-csum-tree.

This is helpful. Thanks.

Chris Murphy
