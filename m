Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60931 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbANPqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 10:46:35 -0500
Date: Wed, 14 Jan 2015 16:46:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
Message-ID: <20150114154633.GU3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
> make btrfs qgroups show human readable sizes
> using --human-readable option, example:

That's too long to type and the idea was to add all the long options
that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
--si and --iec. We can possibly make the human readable the default
because that's what I'd expect to see to have a quick overview and can
use the other options otherwise.

The geopt parser accepts short options if they're unique, so --kb or
even --k works as a very convenient shorcut for frequent commandline
use.

> qgroupid rfer         excl         max_rfer     max_excl     parent  child
> -------- ----         ----         --------     --------     ------  -----
> 0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
> 0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
> 0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
> 1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265

The values should be also aligned to the right.
