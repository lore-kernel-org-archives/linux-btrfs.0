Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35929 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231Ab2IXQ70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 12:59:26 -0400
Received: by obbuo13 with SMTP id uo13so4865407obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 09:59:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120920190306.GG2272@localhost.localdomain>
References: <20120920190306.GG2272@localhost.localdomain>
Date: Mon, 24 Sep 2012 11:59:25 -0500
Message-ID: <CAKcLGm_Cbsyv4sEoaOG9KsR5qGkjvmedU4hBX=_EfrsXYz3q7w@mail.gmail.com>
Subject: Re: ENOSPC design issues
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 2:03 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Hello,
>
> I'm going to look at fixing some of the performance issues that crop up because
> of our reservation system.  Before I go and do a whole lot of work I want some
> feedback.

When I was trying to figure out the problem with gzip ENOSPC issues, I
spent some time debugging and following the flow through the
reserve_metadata_bytes() function in extent-tree.c.

My observation was that the accounting around
space_info->bytes_may_use did not appear to be tightly closed.  The
space_info->bytes_may_use value would grow large (often 3 or 4 times
greater than space_info->total), and the flow through
reserve_metadata_bytes() would stay in overcommit.

I was unsuccessfull in figuring out how to rework or close the loop on
the accounting for space_info->bytes_may_use.

I noticed that btrfs seemed to work OK even though the value in
space_info->bytes_may_use appeared inexplicably large, and btrfs was
always in overcommit.

So, since you're asking for possibly 'crazy ideas', I suggest
considering finding a way to ignore space_info->bytes_may_use in
reserve_metadata_bytes().  Either make the overcommit the default
(which I found to approximate my real-life case anyhow), or have a
simple mechanism for quick fail-over to overcommit.

I doubt this will be any kind of comprehensive fix for ENOSPC issues,
but simplifying reserve_metadata_bytes() may make it easier to find
the other issues.
