Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42508 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3BHVhs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 16:37:48 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id D3BD29A0643
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 14:37:47 -0700 (MST)
Date: Fri, 8 Feb 2013 16:37:45 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: Current State of BTRFS
Message-ID: <20130208213745.GC10931@localhost.localdomain>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
 <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 02:30:04PM -0700, Florian Hofmann wrote:
> Hi everybody,
> 
> I am using btrfs as my main fs for some time now, but I am
> experiencing severe performance drawbacks. I can't qualify the
> circumstances, but sometimes during disc access the whole system
> freezes for some time.
> 
> Maybe somebody could suggest some general things I could try to search
> for the problem?

Can I see

btrfs fi df /mnt/point
btrfs fi show

and then when you are having problems

echo w > /proc/sysrq-trigger

and capture dmesg.  Thanks,

Josef
