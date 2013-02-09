Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43976 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab3BINfT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Feb 2013 08:35:19 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so3569011lbb.41
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Feb 2013 05:35:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130209103039.GA11520@merlins.org>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
	<CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
	<20130209103039.GA11520@merlins.org>
Date: Sat, 9 Feb 2013 14:35:17 +0100
Message-ID: <CAM-0MpXZ-+7-DoK7O3SyZG1ApzASJYcQ1d0fUjGrKM1-LhNZtQ@mail.gmail.com>
Subject: Re: Fwd: Current State of BTRFS
From: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Sadly) No SSD.

I just upgraded from kernel version 3.7.5 to 3.7.6 (running Arch
Linux) with no change in behavior.

2013/2/9 Marc MERLIN <marc@merlins.org>:
> On Fri, Feb 08, 2013 at 10:30:04PM +0100, Florian Hofmann wrote:
>> Hi everybody,
>>
>> I am using btrfs as my main fs for some time now, but I am
>> experiencing severe performance drawbacks. I can't qualify the
>> circumstances, but sometimes during disc access the whole system
>> freezes for some time.
>>
>> Maybe somebody could suggest some general things I could try to search
>> for the problem?
>
> Are you running on an SSD?
>
> If so, that is likely your problem.
>
> Depending on your SSD:
> - it's going bad
> - it's running out of blocks to reallocate, or being very slow
> - other firmware issue
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/


2013/2/9 Marc MERLIN <marc@merlins.org>:
> On Fri, Feb 08, 2013 at 10:30:04PM +0100, Florian Hofmann wrote:
>> Hi everybody,
>>
>> I am using btrfs as my main fs for some time now, but I am
>> experiencing severe performance drawbacks. I can't qualify the
>> circumstances, but sometimes during disc access the whole system
>> freezes for some time.
>>
>> Maybe somebody could suggest some general things I could try to search
>> for the problem?
>
> Are you running on an SSD?
>
> If so, that is likely your problem.
>
> Depending on your SSD:
> - it's going bad
> - it's running out of blocks to reallocate, or being very slow
> - other firmware issue
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
