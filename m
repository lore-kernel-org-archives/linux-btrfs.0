Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34157 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbCZDXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 23:23:22 -0400
Received: by lagg8 with SMTP id g8so35472369lag.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 20:23:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150326021054.GA28470@coach.innovationfirst.com>
References: <CAFzWkZGytSfhvx8zts=pwBseua-Hdpp+ZXmDPNLrpwJqhiaU_A@mail.gmail.com>
 <20150326021054.GA28470@coach.innovationfirst.com>
From: Anand Patil <anand.prabhakar.patil@gmail.com>
Date: Wed, 25 Mar 2015 20:23:00 -0700
Message-ID: <CAFzWkZHuz99Bi=ALFzjVD6fCSAQj9x+jAYSOTs93awJry+C1Xw@mail.gmail.com>
Subject: Re: Metadata about to fill up, how to make it bigger next time?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AWESOME. Thanks so much for getting back to me so quickly.

On Wed, Mar 25, 2015 at 7:10 PM, Sean Greenslade
<sean@seangreenslade.com> wrote:
> On Wed, Mar 25, 2015 at 04:45:09PM -0700, Anand Patil wrote:
>> Hi everyone,
>>
>> When I run btrfs fi df /path/to/fs, I see:
>>
>> Data, single: total=53.01GiB, used=51.79GiB
>> System, DUP: total=32.00MiB, used=16.00KiB
>> Metadata, DUP: total=16.00GiB, used=14.72GiB
>>
>> My most pressing question is, does that metadata line really mean that
>> the filesystem is going to become unusable soon?
>
> No. If you total up your allocations, you will notice that you have
> ~69GiB allocated, far shy of your total 1000GiB available. BTRFS
> allocates in chunks as needed, so once it needs more space for metadata,
> it will allocate some. You only get into trouble if there is no free
> space to allocate from, and you are far from having that issue.
>
> --Sean
