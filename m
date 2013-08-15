Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:46343 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3HOR3W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Aug 2013 13:29:22 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so1157549obc.13
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Aug 2013 10:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
References: <CAKcLGm_DXiwJrAMYG66ZiEmXtSKe0z0LUPfxat0Repb0jfDnNA@mail.gmail.com>
	<20130813141542.GF2150@localhost.localdomain>
	<CAKcLGm99PdyuurtmA6_ZW1PQOaH4piQSK-VYQMT-0PJkgDf-Yw@mail.gmail.com>
Date: Thu, 15 Aug 2013 12:29:21 -0500
Message-ID: <CAKcLGm_c=qimNQiByVA5ko-7K4ojL2mf5yoxLyiVCwKgaLcAZA@mail.gmail.com>
Subject: Re: Kernel BUG on Snapshot Deletion (3.11.0-rc5)
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running into a curious problem.

In the process of making my script portable, I am breaking the ability
to replicate the error.

I'm trying to isolate the aspect of my local script that is triggering
the error.  No firm insights yet.


On Tue, Aug 13, 2013 at 11:03 AM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> Let me work on making that script more portable, and hopefully quicker
> to reproduce.
>
> On Tue, Aug 13, 2013 at 9:15 AM, Josef Bacik <jbacik@fusionio.com> wrote:
>> On Mon, Aug 12, 2013 at 11:06:27PM -0500, Mitch Harder wrote:
>>> I'm hitting a btrfs Kernel BUG running a snapshot stress script with
>>> linux-3.11.0-rc5.
>>>
>>
>> I can haz script?  Thanks,
>>
>> Josef
