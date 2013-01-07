Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:61378 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3AGRBV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 12:01:21 -0500
Received: by mail-we0-f179.google.com with SMTP id r6so10013156wey.38
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Jan 2013 09:01:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50EAF092.20907@redhat.com>
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com>
	<CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
	<50EAF092.20907@redhat.com>
Date: Mon, 7 Jan 2013 22:31:19 +0530
Message-ID: <CANT588t+jcOZNv4w1azXkuywEbSh_+F_AtrUo=3=1P4j+Aesjw@mail.gmail.com>
Subject: Re: Open for contribution towards xfstests for btrfs
From: Kiran Patil <kirantpatil@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com,
        xfs-oss <xfs@oss.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 7, 2013 at 9:28 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/7/13 4:18 AM, Kiran Patil wrote:
>> Hello,
>>
>> We have a team of 5 students who would like to contribute to btrfs
>> filesystem testing using xfstests.
>>
>> Is there space for them to contribute?
>>
>> If yes, to whom do they need to keep in touch for guidance.
>
> (cc: xfs list)
>
> Are you thinking of writing new tests, or doing more formal testing
> with the existing testsuite?  Both would be useful.
>
> In particular, any time there's a bugfix, a regression test is helpful.
> Generic new tests of btrfs functionality would be good, too.
>
> I would suggest starting with a couple new tests, and cc: the xfs list
> for review.  In the course of the review you'll get a sense of the various
> conventions used in xfstests, etc.
>
> Simply running xfstests over various btrfs configurations would also
> be useful, to be sure any regressions caught by existing tests don't go
> unnoticed.
>
> thanks,
> -Eric
>
Dear Eric and David,

Thanks a lot for your inputs.

We will work on them and soon we will start our work.

Thank you,

-Kiran
