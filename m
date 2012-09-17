Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46664 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2IQK60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:58:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <loom.20120917T123219-86@post.gmane.org>
Date: Mon, 17 Sep 2012 20:58:16 +1000
Cc: linux-btrfs@vger.kernel.org
Message-Id: <DB9AC79F-4AD3-48EE-9C08-E1015DBE8BBD@oracle.com>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120917091543.GC29881@charite.de> <loom.20120917T113953-444@post.gmane.org> <55422103-3EA7-4DE9-9C47-351CBD006871@oracle.com> <loom.20120917T123219-86@post.gmane.org>
To: Casper Bnag <casper.bang@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 17/09/2012, at 8:47 PM, Casper Bnag <casper.bang@gmail.com> wrote:

> month, that just makes me wonder why Oracle didn't use these latest bits. 

We used the most stable release of btrfs that was available when the development of the UEK was done. Keep in mind that while it's versioned at 2.6.39, it's actually 3.0.16 under the hood. It's just that some userspace doesn't like having a kernel version that doesn't start with "2.6"

>> Out of interest, have you done a performance benchmark with ASM using ASMlib
>> on the same platform? 
> 
> Sorry, no. Our experience with ASM is limited, we came to the conclusion once
> that we like being able to handle the files in a plain mountable file-system.

Perhaps, but ASM would provide all the functionality you require, including snapshots and rollback, at the highest possible performance. Certainly a lot higher than both ZFS and btrfs. And it's fully certified and supported by Oracle.

As an alternative, why not consider using Oracle VM on the machine and creating database VMs instead? You can then use the snapshot capability of Oracle VM while still running supported and certified filesystems inside each guest.

(We should also probably take this discussion off-list, as it has drifted away from btrfs proper). Feel free to reply to me directly if you want.

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia






