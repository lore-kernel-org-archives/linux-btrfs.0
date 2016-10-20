Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:36196 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965260AbcJTP0l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 11:26:41 -0400
Date: Thu, 20 Oct 2016 20:26:35 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it possible to speed up unlink()?
Message-ID: <20161020202635.57c8a72b@natsu>
In-Reply-To: <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
References: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
        <00101fd7-39e0-903c-5151-f2458259fd62@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 20 Oct 2016 08:09:14 -0400
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> > So, it's possible to return unlink() early? or this a bad idea(and why)?
> I may be completely off about this, but I could have sworn that unlink() 
> returns when enough info is on the disk that both:
> 1. The file isn't actually visible in the directory.
> 2. If the system crashes, the filesystem will know to finish the cleanup.

As I understand it there is no fundamental reason why rm of a heavily
fragmented file couldn't be exactly as fast as deleting a subvolume with
only that single file in it. Remove the directory reference and instantly
return success to userspace, continuing to clean up extents in the background.

However for many uses that could be counter-productive, as scripts might
expect the disk space to be freed up completely after the rm command returns
(as they might need to start filling up the partition with new data). 

In snapshot deletion there are various commit modes built in for that purpose,
but I'm not sure if you can easily extend POSIX file deletion to implement
synchronous and non-synchronous deletion modes.

* Try the 'unlink' program instead of 'rm'; if "just remove the dir entry for
  now" was implemented anywhere, I'd expect it to be via that.
* Try doing 'eatmydata rm', but that's more of a crazy idea than anything else,
  as eatmydata only affects fsyncs, and I don't think rm is necessarily
  invoking those.

-- 
With respect,
Roman
