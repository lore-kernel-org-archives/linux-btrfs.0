Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.24]:58853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaCDGmf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Mar 2014 01:42:35 -0500
Message-ID: <531575C8.70801@friedels.name>
Date: Tue, 04 Mar 2014 07:42:16 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfsck does not fix
References: <52C7127F.3060902@friedels.name>	<0FFB7595-0A34-424C-BFC5-CCF6098A7801@colorremedies.com>	<52D317CF.2070007@friedels.name> <6210673.6TYUkLGl6b@merkaba>	<52DED1C2.60103@friedels.name> <52F6A955.5020808@friedels.name>	<A0A6914C-DDA5-4904-83FA-B59AA420C9C6@colorremedies.com>	<52F73E2B.9080103@friedels.name>	<837FAEE6-9A8E-4A88-AEDF-B9B2B3C3B618@colorremedies.com>	<82A12D91-416E-4B2F-80ED-23ACFD466633@colorremedies.com>	<53010EF9.60805@friedels.name>	<21AD6EBC-FDDA-4BDE-B0B4-D6A8BBAD58F0@colorremedies.com> <pan$475be$cb0c1165$a3d91acc$c206709@cox.net> <5303D6C8.80103@friedels.name> <9583F3D2-78BB-40C3-A1CD-E2D8DE4CA89E@colorremedies.com> <53137AD1.50504@friedels.name> <0548C4C7-1664-48F9-9DA3-DB1CC35DB9E6@colorremedies.com>
In-Reply-To: <0548C4C7-1664-48F9-9DA3-DB1CC35DB9E6@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,


> It might be worth finding large files to defragment. See the ENOSPC errors during raid1 rebalance thread. It sounds like it might be possible for some fragmented files to be stuck across multiple chunks, preventing conversion.

I moved 400Gb from my other (but full) disc to the btrfs disc. This 
freed up 400Gb on the full disc, so that I could move the other 400Gb to 
the non-btrfs disc. Essentially, I think this also defragmented all 
files, as they were freshly written (and as "single", so that in fact a 
balance probably was not neccessarry anymore).

After this balance and device-delete worked, also the device-delete!

Nevertheless: I find it concerning, that this problem occured (remember, 
it was a raid with no SMART errors) and could not be fixed. My 
understanding was, that this should not happen to btrfs even in its 
current state.

Thanks!

Greetings,
Hendrik
