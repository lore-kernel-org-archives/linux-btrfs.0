Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:31434 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab2IQKF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 06:05:59 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <loom.20120917T113953-444@post.gmane.org>
Date: Mon, 17 Sep 2012 20:05:50 +1000
Cc: linux-btrfs@vger.kernel.org
Message-Id: <55422103-3EA7-4DE9-9C47-351CBD006871@oracle.com>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120917091543.GC29881@charite.de> <loom.20120917T113953-444@post.gmane.org>
To: Casper Bnag <casper.bang@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 17/09/2012, at 7:55 PM, Casper Bnag <casper.bang@gmail.com> wrote:

> We're using the latest available kernel for our Oracle Unbreakable 
> Linux 6.3 from Aug 28. We have no other option, since the Oracle database
> software needs to run on a certified distro. 

Oracle Database is not certified to run on either btrfs or ZFS on Linux, so if certification is an issue, you can't use either filesystem. Out of interest, have you done a performance benchmark with ASM using ASMlib on the same platform? 

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia






