Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-meaghan.wadns.net ([41.185.62.72]:31438 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750828AbaKZNjJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:39:09 -0500
Message-ID: <5475D7F3.4040408@swiftspirit.co.za>
Date: Wed, 26 Nov 2014 15:38:59 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141125164717.GK26471@twin.jikos.cz>
In-Reply-To: <20141125164717.GK26471@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/25 18:47, David Sterba wrote:
> We could provide an interface for external applications that would make
> use of the strong checksums. Eg. external dedup, integrity db. The
> benefit here is that the checksum is always up to date, so there's no
> need to compute the checksums again. At the obvious cost.

I can imagine some use-cases where you might even want more than one 
algorithm to be used and stored. Not sure if that makes me a madman, 
though. ;)

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

