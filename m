Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a.wadns.net ([196.220.39.49]:20318 "EHLO fw7a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEWpM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 17:45:12 -0500
Message-ID: <52C9DE66.8080706@swiftspirit.co.za>
Date: Mon, 06 Jan 2014 00:36:22 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Sulla <Sulla@gmx.at>, Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
References: <52C2AE7C.5020601@gmx.at> <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com> <52C9CBEF.2000309@gmx.at>
In-Reply-To: <52C9CBEF.2000309@gmx.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/01/05 11:17 PM, Sulla wrote:
> Certainly: I have 3 HDDs, all of which WD20EARS.
Maybe/maybe-not off-topic:
Poor hardware performance, though not necessarily the root cause, can be 
a major factor with these errors.

WD Greens (Reds too, for that matter) have poor non-sequential 
performance. An educated guess I'd say there's a 15% chance this is a 
major factor to the problem and, perhaps, a 60% chance it is merely a 
"small contributor" to the problem. Greens are aimed at consumers 
wanting high capacity and a low pricepoint. The result is poor 
performance. See footnote * re my experience.

My general recommendation (use cases vary of course) is to install a 
tiny SSD (60GB, for example) just for the OS. It is typically cheaper 
than the larger drives and will be *much* faster. WD Greens and Reds 
have good *sequential* throughput but comparatively abysmal random 
throughput even in comparison to regular non-SSD consumer drives.

*
I had 8x 1.5TB WD1500EARS drives in an mdRAID5 array. With it I had a 
single 250GB IDE disk for the OS. When the very old IDE disk inevitably 
died, I decided to use a spare 1.5TB drive for the OS. Performance was 
bad enough that I simply bought my first SSD the same week.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

