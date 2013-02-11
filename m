Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:57175 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BKQF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 11:05:27 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DFED49A041E
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 09:05:26 -0700 (MST)
Date: Mon, 11 Feb 2013 11:05:24 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
CC: cwillu <cwillu@cwillu.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: Current State of BTRFS
Message-ID: <20130211160524.GA2611@localhost.localdomain>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
 <CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
 <20130208213745.GC10931@localhost.localdomain>
 <CAM-0MpWoAXaCqcGLgXGE8s-zSn0fz7n4QUommSgqH0ayi=tJNA@mail.gmail.com>
 <CAM-0MpV83W7VeV07FLFVj-qTWXDBUROBwPHVFha38RftLOwoJQ@mail.gmail.com>
 <CAE5mzvjh8jF5U4gWbYOw0_x1pYQ6p2MDU_W4kcp4oeP9T4wu5Q@mail.gmail.com>
 <CAM-0MpUD-9j4zS58xCp5qu6e1SLMR9jHbQM95k9hhKbxK3FifA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAM-0MpUD-9j4zS58xCp5qu6e1SLMR9jHbQM95k9hhKbxK3FifA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 04:12:17PM -0700, Florian Hofmann wrote:
> I ran it as root. The first times there was no output whatsoever. This
> time triggering gave the SysRq : Show Blocked State line. Strange
>

Well that's weird, it looks like you don't have any blocked tasks, so either
sysrq+w is screwing up or you are getting stuck in something CPU intensive.  Try
doing sysrq+w next time it happens again and also run top and see if something
is using up 100% of the CPU.  If it's something chewing up CPU then I'll tell
you how to figure out what's going on.  Thanks,

Josef 
