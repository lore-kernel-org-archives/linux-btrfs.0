Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35668 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbbDNPWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 11:22:11 -0400
Received: by obbfy7 with SMTP id fy7so4191996obb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 08:22:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150413144743.GL25622@twin.jikos.cz>
References: <CAD+ocbzxMXNGYKOmUNnVfj297brVsyjQ=vPGs7hJ_9aHNOhdVA@mail.gmail.com>
 <20150413144743.GL25622@twin.jikos.cz>
From: harshad shirwadkar <harshadshirwadkar@gmail.com>
Date: Tue, 14 Apr 2015 11:21:49 -0400
Message-ID: <CAD+ocbwDR+be-Lf6LmZGrUhVA5D5Ds2q9LV=6xXgdPZ3tfQs4A@mail.gmail.com>
Subject: Re: [GSoC 2015] Btrfs content based storage
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks David and that's true: there will be a large overlap with dedup
work from Liu Bo. In fact, a few days after I sent the first mail, I
got in touch with Liu and he agreed upon mentoring. So, I am all set
now and will start working on the project in May end..

Best,
Harshad.

On Mon, Apr 13, 2015 at 10:47 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Mar 27, 2015 at 10:58:42AM -0400, harshad shirwadkar wrote:
>> I am a CS graduate student from Carnegie Mellon University. I am
>> hoping to build the feature - "Content based storage mode" under
>> Google Summer of Code 2015. This project has also been listed as an
>> idea on BTRFS ideas page. However, I have not found a mentor yet, and
>> without a mentor I can not participate in the program. Please let me
>> know if anybody is interested in mentoring this project. Here is a
>> link to my proposal:
>>
>> http://harshadjs.github.io/2015/03/27/Fedora-BTRFS-Content-Storage-Mode/
>
> This probably has a significant overlap with the in-band dedup work from
> Liu bo [1]. Your proposal expects an interface to look up the data by
> hash which hasn't been implemented afaik.
>
> [1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/34097 (v10)
