Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:43894 "EHLO
	smtp-36.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862AbaLESP5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 13:15:57 -0500
Message-ID: <5481F657.8090307@inwind.it>
Date: Fri, 05 Dec 2014 19:15:51 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, Dimitri John Ledkov <xnox@debian.org>,
        Chris Mason <clm@fb.com>, cwillu <cwillu@cwillu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
References: <547B5724.1060507@libero.it> <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com> <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com> <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com> <1417793566.21214.11@mail.thefacebook.com> <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com> <20141205164144.GK9754@suse.cz>
In-Reply-To: <20141205164144.GK9754@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/2014 05:41 PM, David Sterba wrote:
> We're looking
> for good reasons to justify the existence of the helper, but this is
> still not enough IMHO. I can see the convenience to do it automatically,
> but this assumes no udev available which is probably rare these days.

I have the following reasons to support a mount.btrfs helper:
1) it is in a good point to check that everything is ok (see the thread
related LVM snapshot, due to a dev.uuid conflicts), 
2) it is in a good point to issue a good error explanation (missing 
device....)
3) it may handle case like "degraded" mode, where the filesystem is not
fully functional but even as degraded have "some" functionals..


On 12/05/2014 04:32 PM, Chris Mason wrote:
> I definitely agree that assembling the filesystem from userland is
> somewhat awkward, and people that don't want initrds end up needing
> to jump through hoops to get things done.
> 
> But, the tools we have to avoid the hoops are initrds and udev, and
> I'd much rather spend time fixing filesystem bugs than recreating
> those tools.  If people are having trouble with udev, or having
> trouble with tools in the initrd, lets contribute fixes to those
> projects instead.

Chris, I am bit confused by your answer: mount.btrfs helper is not 
a solution for the initrd-less system (whom I am not a fan 
anymore [*]). And I don't think that the awkward-ness of btrfs is due to
udev deficiencies.
Btrfs is new because acts both as filesystem and as dm/md layer. We 
know that there are very good reasons to do that. But also it
highlights new problems whom the old tools may be not a right solution.

See this from another point of view: md/dm have specific tools to
assemble the disks. So why btrfs wouldn't need a specific tool?

BR
G.Baroncelli


[*] I hope to not start another flame-war. I am not against to the 
initrd-less system; but if you want a multidevice filesystem (with 
or without md/dm) simply you cannot rely to the kernel only (IMHO).

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
