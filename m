Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw5a-delaine.wadns.net ([196.220.39.203]:63795 "EHLO
	fw5a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754473AbaEEG4K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 May 2014 02:56:10 -0400
Message-ID: <536735FB.6020205@swiftspirit.co.za>
Date: Mon, 05 May 2014 08:55:55 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
References: <20140504004732.GE9061@merlins.org>	<5365E74B.6020805@swiftspirit.co.za>	<20140505005644.GB10159@merlins.org>	<53670FEA.8050806@swiftspirit.co.za> <20140505103617.0e66f5a9@natsu>
In-Reply-To: <20140505103617.0e66f5a9@natsu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/05/14 06:36, Roman Mamedov wrote:
> On Mon, 05 May 2014 06:13:30 +0200
> Brendan Hide <brendan@swiftspirit.co.za> wrote:
>
>>>> 1) There will be a *very* small performance penalty (negligible, really)
>>> Oh, really, it's slower to mount the device directly? Not that I really
>>> care, but that's unexpected.
>> Um ... the penalty is if you're mounting indirectly. ;)
> I feel that's on about the same scale as giving your files shorter filenames,
> "so that they open faster". Or have you looked at the actual kernel code with
> regard to how it's handled, or maybe even have any benchmarks, other than a
> general thought of "it's indirect, so it probably must be slower"?
>
My apologies - not everyone here is a native English-speaker.

You are 100% right, though. The scale is very small. By negligible, the 
"penalty" is at most a few CPU cycles. When compared to the wait time on 
a spindle, it really doesn't matter much.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

