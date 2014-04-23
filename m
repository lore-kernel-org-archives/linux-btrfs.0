Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:40345 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaDWVMj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 17:12:39 -0400
Date: Wed, 23 Apr 2014 14:12:38 -0700
From: Marc MERLIN <marc@merlins.org>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: hung task timer + btrfs_convert or btrfs balance = OOPS
Message-ID: <20140423211238.GI26949@merlins.org>
References: <53582625.3030800@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53582625.3030800@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 23, 2014 at 01:44:21PM -0700, Robert White wrote:
> As it is, the two options are not happy together. Be sure to
> 
> echo 0 > /proc/sys/kernel/hung_task_timeout_secs
> 
> to disable the timer before doing a mount or balance after a 

But this only removes the messages from syslog, it doesn't actually
fix/remove any hangs, unless I'm missing something.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
