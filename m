Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58742 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaCAPWl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Mar 2014 10:22:41 -0500
Date: Sat, 1 Mar 2014 07:22:35 -0800
From: Marc MERLIN <marc@merlins.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
Message-ID: <20140301152235.GA26926@merlins.org>
References: <20140227190656.GA28338@merlins.org>
 <530FE3CE.70809@cn.fujitsu.com>
 <20140301050937.GD18300@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140301050937.GD18300@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 28, 2014 at 09:09:37PM -0800, Marc MERLIN wrote:
> On Fri, Feb 28, 2014 at 09:18:06AM +0800, Wang Shilong wrote:
> > Could you run the following command when scrub is blocked, we can know more
> > why scrub is blocked here.
> > 
> > # echo w >  /proc/sysrq-trigger
> > # dmesg
> 
Yes, there you go:

(attached because it's too big for the list)

http://marc.merlins.org/tmp/btrfs_nofreeze.txt

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
