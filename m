Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44737 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab3C0PUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 11:20:48 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EF5569A068E
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 09:20:47 -0600 (MDT)
Date: Wed, 27 Mar 2013 11:20:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Clemens Eisserer <linuxhippy@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: "No space left on device" although df reports only 55% in use
Message-ID: <20130327152045.GJ28030@localhost.localdomain>
References: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFvQSYS4o8iGTKYahX8zL3ng4Qre=uYDT7iOB0NTP+inUijQJQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 05:28:23PM -0600, Clemens Eisserer wrote:
> Hi,
> 
> I am using a btrfs loopback mounted file with lzo-compression on
> Linux-3.7.9, and I ran into "No space left on device" messages,
> although df reports only 55% of space is used:
> 
> # touch testfile
> touch: cannot touch `testfile': No space left on device
> 
> # df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/loop0      32768000  17383924  14649172  55% /home/ce/anditest
> 
> # btrfs filesystem df .
> Data: total=28.22GB, used=14.25GB
> System, DUP: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.50GB, used=1.16GB
> Metadata: total=8.00MB, used=0.00
> 
> Any ideas what is going wrong here?
> 

Can I see btrfs fi show and try using btrfs-next and see if the problem is
already fixed.  Thanks,

Josef
