Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52178 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbaHFBSV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 21:18:21 -0400
Received: by mail-vc0-f180.google.com with SMTP id ij19so2981668vcb.11
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Aug 2014 18:18:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN05THQQLTUMctn0ejwhjpW4kfViqNnSoRyzHUUV7iDBx4aLZg@mail.gmail.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
	<1875052.8GFlAMfPzL@quad>
	<pan$dbb9d$e1133995$a123d619$8316b9ab@cox.net>
	<5484676.xyTNESz9qN@xev>
	<CAN05THQQLTUMctn0ejwhjpW4kfViqNnSoRyzHUUV7iDBx4aLZg@mail.gmail.com>
Date: Tue, 5 Aug 2014 21:18:20 -0400
Message-ID: <CAPDOMVie1hUMv3dYyZ_MADoSzTwGZTi55Y=qWorjnQ917WKNpQ@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
From: Nick Krause <xerofoify@gmail.com>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Russell Coker <russell@coker.com.au>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 5, 2014 at 8:38 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> On Tue, Aug 5, 2014 at 5:20 AM, Russell Coker <russell@coker.com.au> wrote:
>
>>
>> Based on what I've read on this list it seems that BTRFS is less stable in
>> 3.15 than in 3.14.  Even 3.14 isn't something I'd recommend to random people
>> who want something to just work.
>>
>> The Debian installer has BTRFS in a list of filesystems to choose with no
>> special notice about it.  I'm thinking of filing a Debian bug requesting that
>> they put a warning against it.
>>
>> What do people here think?
>
> +1 for a warning.
>
> btrfs is still a young filesystem and not as stable as say ext4.
> I think it would be very prudent to have a small warning.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
I agree here and feel this is very important. +1
Nick
