Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57417 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbaFSPNx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Jun 2014 11:13:53 -0400
Date: Thu, 19 Jun 2014 08:13:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: frustrations with handling of crash reports
Message-ID: <20140619151351.GJ19071@merlins.org>
References: <20140519134915.GA27432@merlins.org> <539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org> <20140617182745.GO19071@merlins.org> <53A192B8.2040601@gmail.com> <pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$d2b51$8d2a30e2$29b90599$a8fc24d9@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 18, 2014 at 09:22:50PM +0000, Duncan wrote:
> Tho at least in Marc's case, he's running kernels a couple back in some 
> cases and they may still have BUGONs already replaced in the most current 
> kernel.
 
The machine I originally has that one last bug on (balance crash) was an
ubuntu kernel (oldish 3.13), but I reproduced with 3.15.1 where it got worse
(it seemed like WARN on 3.13 and BUG_ON in 3.15 since with 3.13 I got syslog
output and the system kept running and with 3.15.1 it just crashed and I had
to have netconsole ready to catch the output).

Marc 
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
