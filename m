Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60456 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbcCCUzj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 15:55:39 -0500
Date: Thu, 3 Mar 2016 15:55:35 -0500
From: Chris Mason <clm@fb.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Stray 4k extents with slow buffered writes
Message-ID: <20160303205535.wse72fe4ofdwtggw@floor.thefacebook.com>
References: <56D82DED.5030107@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <56D82DED.5030107@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2016 at 01:28:29PM +0100, Holger Hoffstätte wrote:
> 
> Here's an observation that is not a bug (as in data corruption), just
> somewhat odd and unnecessary behaviour. It could be considered  a
> performance or scalability bug.
> 
> I've noticed that slow slow buffered writes create a huge number of
> unnecessary 4k sized extents. At first I wrote it off as odd buffering
> behaviour of the application (a download manager), but it can be easily
> reproduced. For example:

We saw this here with slowly appending log files.  The basic problem is
the VM triggers dirty writeback on the tail end of the file and either
starts on the last page or our clustering code pulls in the last page.

It leads to latencies because we start writing the last page in the file
to disk and the application has to wait for the IO to finish before it
can append to the file again.

I'll get our patches in for the next merge window, it's basically just:
don't write the last incomplete page in the file if we're O_APPEND and
it isn't a data integrity writeback.  We may want to rework it to drop
the O_APPEND check.

-chris
