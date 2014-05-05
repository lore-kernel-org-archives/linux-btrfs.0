Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48692 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756771AbaEEXh4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 19:37:56 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Very high load when reading/writing
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53628953.8030707@friedels.name>
Date: Mon, 5 May 2014 17:37:52 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <D11154A5-3E91-4C36-B6B3-791CAB4BEA2F@colorremedies.com>
References: <53628953.8030707@friedels.name>
To: Hendrik Friedel <hendrik@friedels.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 1, 2014, at 11:50 AM, Hendrik Friedel <hendrik@friedels.name> wrote:

> 
> Here the output:
> Test from /mnt/BTRFS to /tmp

I'm not sure what this is testing, what the file size is or how many files. These days it's increasingly common to see tmpfs mount on /tmp rather than persistent storage; and then at some threshold it uses swap. So I'm unsure this is a reliable testing source or destination.

What results do you get for the same test using /dev/zero to /tmp and /tmp to /dev/null?

trimmed:
> root@homeserver:/mnt/BTRFS/Video# smartctl -a  /dev/sda1
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST3000DM001-9YN166
> 
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED  WHEN_FAILED RAW_VALUE
>  7 Seek_Error_Rate         0x000f   073   054   030    Pre-fail Always       -       34538763506

The raw value is typical for Seagate drives, but the value and worst compared to threshold would concern me. The value should be at 100, ideally, for a completely normally functioning drive. It's OK if it dips below this and there are no other problems. But worst value 54 is pretty close to threshold 30, it's just not low enough to trigger a prefail warning. It's worth sending the data to Seagate and seeing what they have to say about it if it's still in warranty.



Chris Murphy

