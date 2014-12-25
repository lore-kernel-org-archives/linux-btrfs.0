Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52859 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751637AbaLYDJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 22:09:56 -0500
Date: Wed, 24 Dec 2014 21:14:13 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141225031413.GA5864@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com>
 <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com>
 <20141221225315.GA19479@pyropus.ca> <54976811.2060507@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54976811.2060507@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White <rwhite@pobox.com> wrote:
> 
> You have very little free memory.

I think you're mistaken.  Every diagnostic I've looked at says the opposite.
>From 30 seconds ago on the same machine, after unmounting the big btrfs
filesystem (and with a larger xfs one mounted), /proc/meminfo says almost the
entirety of the machine's 16GB is free:

  MemTotal:       16469880 kB
  MemFree:        16005392 kB
  MemAvailable:   15974244 kB
  Buffers:              84 kB
  [...]

> This is called "demand paging",

Yes, I'm aware of how this works.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
