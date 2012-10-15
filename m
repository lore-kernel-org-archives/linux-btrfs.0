Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25107 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2JOI7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 04:59:47 -0400
Message-ID: <507BD155.7000609@oracle.com>
Date: Mon, 15 Oct 2012 17:03:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] Add show sub command to btrfs subvolume
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com> <5079CADA.4050604@gmail.com>
In-Reply-To: <5079CADA.4050604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Thanks for working on that; do you think that is it feasible to merge
> the works on "btrfs sub list" and "btrfs sub show" ?
> To date the output of "btrfs sub list" is quite cryptic: a lot of
> information on only on row, which is difficult to read. However it has
> the capability to traverse the filesystem to list the subvolumes, to
> sort the output, to filter it...
> Instead your work has not the capability to traverse/filter/sort but has
> a very nice output.
>
> The ideal is to extend the actual command (btrfs sub list) to have your
> output (as default) and the current one (as option) when used in script...


  Thanks for the comments.

  (just for note: this patch is on top the latest subvol
  list framework).
  generally multi-line output isn't suitable for the list
  kind of output, right? since it makes scripting difficult.
  So here the plan is to have both list and show. List is
  to see all the items and show is know more about an item.

  Show will be more exciting when we could add size info for
  each subvol/snapshot.

-Anand
