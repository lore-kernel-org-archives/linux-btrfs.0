Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s24.hotmail.com ([65.55.116.35]:64423 "EHLO
	BLU004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbbJ0NAu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 09:00:50 -0400
Message-ID: <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <562F638B.1040701@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
	<562E37F4.9080602@oracle.com>
	<CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
	<CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
	<CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
	<CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
	<CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
	<562F638B.1040701@gmail.com>
Date: Tue, 27 Oct 2015 14:00:45 +0100
Subject: Re: Bad fs performance, IO freezes
From: Henk Slager <hslager@hotmail.com>
To: "cheater00 ." <cheater00@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't have a lot experience with autodefrag, but as indicated by
Austin, expect a lot of full rewrites of files that are relatively
slowly filled up by a torrent client, starting with a sparse file. So
1st advice would be to remove this option and run it as crontask at
particular times.

What SATA-USB bridge is between the harddisk and the PC motherboard ?
Also what USB host chipset is on the PC motherboard ?
Why don't you run 64-bit Ubuntu on this core i7 ?


On Tue, Oct 27, 2015 at 12:44 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-26 22:00, cheater00 . wrote:
>>
>> Hello,
>> currently my computer freezes every several seconds for half a second
>> or so. Using it feels like I'm playing musical chairs with the kernel.
>> I have just one download happening on utorrent right now - this is
>> what the graph looks like:
>> http://i.imgur.com/LqhMtrJ.png
>> and every time a new spike happens, a freeze happens just before
>> that... that's the only time those freezes happen, too.
>>
> Do you have the 'autodefrag' mount option enabled?  If it is turned on, then
> that may be the problem.  Most bittorrent clients pre-allocate the space for
> a download, then write each block directly into the location it's supposed
> to be in the resultant download, which means depending on how it's
> pre-allocating the space, that you end up with a large number of randomly
> ordered writes into a single file, which in turn will trigger the autodefrag
> code, which can cause latency spikes when you're also hitting the disk at
> the same time.
>
