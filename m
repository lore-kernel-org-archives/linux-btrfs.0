Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:58933 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725Ab3BKQOq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 11:14:46 -0500
Received: by mail-la0-f44.google.com with SMTP id eb20so6014504lab.17
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 08:14:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130211160524.GA2611@localhost.localdomain>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
	<CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
	<20130208213745.GC10931@localhost.localdomain>
	<CAM-0MpWoAXaCqcGLgXGE8s-zSn0fz7n4QUommSgqH0ayi=tJNA@mail.gmail.com>
	<CAM-0MpV83W7VeV07FLFVj-qTWXDBUROBwPHVFha38RftLOwoJQ@mail.gmail.com>
	<CAE5mzvjh8jF5U4gWbYOw0_x1pYQ6p2MDU_W4kcp4oeP9T4wu5Q@mail.gmail.com>
	<CAM-0MpUD-9j4zS58xCp5qu6e1SLMR9jHbQM95k9hhKbxK3FifA@mail.gmail.com>
	<20130211160524.GA2611@localhost.localdomain>
Date: Mon, 11 Feb 2013 16:14:44 +0000
Message-ID: <CAAeznToauNWzvwxR5giHhEpDo_ADNywEBw_wSQD4gViad3rb4g@mail.gmail.com>
Subject: Re: Fwd: Current State of BTRFS
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>,
        cwillu <cwillu@cwillu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 11, 2013 at 4:05 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Fri, Feb 08, 2013 at 04:12:17PM -0700, Florian Hofmann wrote:
>> I ran it as root. The first times there was no output whatsoever. This
>> time triggering gave the SysRq : Show Blocked State line. Strange
>>
>
> Well that's weird, it looks like you don't have any blocked tasks, so either
> sysrq+w is screwing up or you are getting stuck in something CPU intensive.  Try
> doing sysrq+w next time it happens again and also run top and see if something
> is using up 100% of the CPU.  If it's something chewing up CPU then I'll tell
> you how to figure out what's going on.  Thanks,
>
I noticed you have the FS mounted with compress flag (compress=lzo).
Could it be that your CPU is bottle-necking the process?

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Caution: breathing may be hazardous to your health.

#include <stdio.h>
int main(){printf("%s","\x4c\x65\x6f\x6e\x69\x64\x61\x73");}
