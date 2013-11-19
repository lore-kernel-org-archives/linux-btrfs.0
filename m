Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:65015 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3KSWwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 17:52:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
 <528A90B7.5010905@zytor.com> <CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
 <528AA1EB.3010909@zytor.com> <528B3A6F.2010304@hesbynett.no> <CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
From: Drew <drew.kay@gmail.com>
Date: Tue, 19 Nov 2013 14:51:47 -0800
Message-ID: <CACJz6QtP9TXKX9ZB2J5nfLCCn0yfNExwZ-VYm-xiN53aA9vfLw@mail.gmail.com>
Subject: Re: Triple parity and beyond
To: Andrea Mazzoleni <amadvance@gmail.com>
Cc: David Brown <david.brown@hesbynett.no>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not going to claim any expert status on this discussion (the
theory makes my head spin) but I will say I agree with Andrea as far
as prefering his implementation for triple parity and beyond.

PSHUFB has been around the intel platform since the Core2 introduced
it as part of SSSE3 back in Q1 2006. The generation of Intel based
servers that ran pre-Core Xeons are long in the tooth and this is a
value judgement but if your data is big enough you need triple parity,
you probably shouldn't be running it from an ten year old platform.

But that's just me. :-)


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
