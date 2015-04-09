Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33286 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933029AbbDITlU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 15:41:20 -0400
Received: by paboj16 with SMTP id oj16so159578391pab.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2015 12:41:20 -0700 (PDT)
Date: Thu, 9 Apr 2015 12:41:18 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: bug: proc mountinfo, findmnt, and subvol vs subvolid
Message-ID: <20150409194118.GB12447@mew>
References: <CAJCQCtSsv42=dNMsh=F56x12sWbx=nc2Ktej1xGVzGmsysytSw@mail.gmail.com>
 <CAJCQCtRnS_s2MxpvmrPv9_-Rn6-kfJ0wLxhgbDKoO0DtWi9Uig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRnS_s2MxpvmrPv9_-Rn6-kfJ0wLxhgbDKoO0DtWi9Uig@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 01:38:19PM -0600, Chris Murphy wrote:
> Another way to put this is, the only reliable way to mount and get
> subvolume info in findmnt and /proc is by using subvol=.
> 
> When using subvolid=, the subvolume info isn't available unless the
> initial mount is the top level (ID 5).

Working on it :) https://lkml.org/lkml/2015/4/8/16

-- 
Omar
