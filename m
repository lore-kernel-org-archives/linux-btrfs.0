Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:64296 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab3AGR1P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 12:27:15 -0500
Received: by mail-la0-f51.google.com with SMTP id fj20so16668898lab.38
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 09:27:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121218013111.GB22912@shiny>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
	<CAB9VWqCjoFGdZVx0Uup2zmvuqS2PHiQO=h2EKawH-dZiGqvfDQ@mail.gmail.com>
	<20121218013111.GB22912@shiny>
Date: Mon, 7 Jan 2013 18:27:13 +0100
Message-ID: <CAMiUzp9m5kFZmNdc793VhSodAM73NupCE8Ggyg2VZ63p-GTgaA@mail.gmail.com>
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
From: =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>,
        Alexander Block <ablock84@gmail.com>,
        =?UTF-8?B?TWFydGluIEvFmcOtxb5law==?= <martin.krizek@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "lczerner@redhat.com" <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 2:31 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Mon, Dec 17, 2012 at 06:33:24AM -0700, Alexander Block wrote:
>> I did some research on deduplication in the past and there are some
>> problems that you will face. I'll try to list some of them (for sure
>> not all).
>
> Thanks Alexander for writing all of this up.  There are a lot of great
> points here, but I'll summarize with:
>
> [ many challenges to online dedup ]
>
> [ offline dedup is the best way ]
>
> So, the big problem with offline dedup is you're suddenly read bound.  I
> don't disagree that offline makes a lot of the dedup problems easier,
> and Alexander describes a very interesting system here.
>
> I've tried to avoid features that rely on scanning though, just because
> idle disk time may not really exist.  But with scrub, we have the scan
> as a feature, and it may make a lot of sense to leverage that.
>
> online dedup has a different set of tradeoffs, but as Alexander says the
> hard part really is the data structure to index the hashes.  I think
> there are a few different options here, including changing the file
> extent pointers to point to a sha instead of a logical disk offset.
>

I am not sure if I am following the approach with replacing the
pointers, could you please explain?

I agree that the data structure is the key part in designing the feature.

> So, part of my answer really depends on where you want to go with your
> thesis.  I expect the data structure work for efficient hash lookup is
> going to be closer to what your course work requires?

No, I don't think it is really necessary that the data structure
should be close to my course work. What is your opinion on the most
suitable data structure to index the hashes?

Thanks!
Martin
