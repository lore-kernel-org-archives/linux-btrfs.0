Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37061 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018AbbDITx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:53:27 -0400
Received: by igblo3 with SMTP id lo3so1107717igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150409194118.GB12447@mew>
References: <CAJCQCtSsv42=dNMsh=F56x12sWbx=nc2Ktej1xGVzGmsysytSw@mail.gmail.com>
	<CAJCQCtRnS_s2MxpvmrPv9_-Rn6-kfJ0wLxhgbDKoO0DtWi9Uig@mail.gmail.com>
	<20150409194118.GB12447@mew>
Date: Thu, 9 Apr 2015 13:53:26 -0600
Message-ID: <CAJCQCtSi5K4DDftOkpK=6ynO-Dy_-DTk0ZfS3shdaYyYtPoGOw@mail.gmail.com>
Subject: Re: bug: proc mountinfo, findmnt, and subvol vs subvolid
From: Chris Murphy <lists@colorremedies.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 9, 2015 at 1:41 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Thu, Apr 09, 2015 at 01:38:19PM -0600, Chris Murphy wrote:
>> Another way to put this is, the only reliable way to mount and get
>> subvolume info in findmnt and /proc is by using subvol=.
>>
>> When using subvolid=, the subvolume info isn't available unless the
>> initial mount is the top level (ID 5).
>
> Working on it :) https://lkml.org/lkml/2015/4/8/16

OK great. Seems like it could also (passively) relate to the
"mlocate/updatedb and btrfs subvolume mounts" thread.


-- 
Chris Murphy
