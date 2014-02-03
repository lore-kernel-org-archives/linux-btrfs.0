Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33423 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752760AbaBCT0s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 14:26:48 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Receive on same subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52EFDDA6.2060907@matthewlai.ca>
Date: Mon, 3 Feb 2014 12:26:46 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8BD36B4A-F9AF-40C6-81B8-85FD14CD5EA1@colorremedies.com>
References: <52E9721D.6000908@matthewlai.ca> <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com> <52EFDDA6.2060907@matthewlai.ca>
To: Matthew Lai <m@matthewlai.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 3, 2014, at 11:19 AM, Matthew Lai <m@matthewlai.ca> wrote:

> Thanks. I should clarify what I'm trying to do.
> 
> I'm trying to use btrfs send for backup, without having another btrfs volume.
> 
> So the initial backup is a complete send, piped to Amazon Glacier (so my machine never has the whole file, and doesn't have space for one).

OK so you've use btrfs send piped to Glacier which creates a *file*, I'll call it "initial", not a navigable directory of files? Right?

> 
> At the same time I'm keeping a snapshot of the current volume.
> 
> On the next incremental backup, I would use the first snapshot as the parent, and send the differences to Glacier again (without having the entire file on the system at any time).

That's fine as long as the stdout from btrfs send ends up as a self contained file on Glacier. I'll call this "increment1"

> 
> It looks like the problem now is the sent file can't be applied to the original volume (for restore).

I'm counting two sent files: initial, increment1. I'm not sure which one you're applying. If you have the exact same read-only snapshot that the btrfs send file "initial" is based on, then you'd apply the increment1 to that read-only snapshot which will cause a new read-only snapshot to be created with the incremental data applied to it. The error you're getting sounds like the parent read-only snapshot isn't available?

Have you tried -vv flag to get more verbose error information when using btrfs receive?

Chris Murphy