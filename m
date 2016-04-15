Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35565 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbcDOG50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 02:57:26 -0400
Received: by mail-io0-f169.google.com with SMTP id g185so126620732ioa.2
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Apr 2016 23:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57108F74.3050802@jp.fujitsu.com>
References: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
	<57108F74.3050802@jp.fujitsu.com>
Date: Fri, 15 Apr 2016 00:57:25 -0600
Message-ID: <CAJCQCtTBfrgs4mX6ikwj48W362bvV1BrCetUcBtUwZcfFyYxxA@mail.gmail.com>
Subject: Re: RFE: btrfs subvolume list -t, include marker for snapshots, and
 whether they are ro
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 12:51 AM, Satoru Takeuchi
<takeuchi_satoru@jp.fujitsu.com> wrote:

> sample output:
> ================================================================
> # ./sub-list-with-ro.rb /
> ID      gen     top level       path    ro
> --      ---     ---------       ----    --
> 257     48672   5               root    false
> 259     48623   257             var/lib/machines        false
> 452     36540   257             root/snaps/root-2016-03-18      true
> 457     45676   257             root/snaps/root-2016-04-08      true
> ================================================================


Yeah it's a good start. I'm not sure what the UI should be exactly.
Maybe it could be an ro column that's blank for rw and ro if it's ro.
Something that's easy to parse visually? Also have it line up in a
straight column, probably before the path column?

-- 
Chris Murphy
