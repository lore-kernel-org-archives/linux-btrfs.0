From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: questions about GRUB and BTRFS
Date: Wed, 25 Feb 2009 13:04:42 -0700
Message-ID: <6e246ee64cdb6decfd7153436888efcb@smtp.arbitraryconstant.com>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com> <1235586140.32346.37.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235586140.32346.37.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Cheers for the informative response. :)

> In the ideal implementation, the grub.conf has a list of devices it is
> allowed to scan, and we put the FS uuid directly in there, let grub scan
> them and we'll be able to boot off multiple volumes in that way.

Hm... perhaps it doesn't even need that much. It we're specifying devices,
might it simply pull the UUID out of the initial device it's given, kinda
like how the current mounting process works? Enumeration of the drives
changes as they come and go, but it doesn't really matter what "hd0" is
today as long as it's a member device.

This suggests another question for me... right now you can specify a root=
command line to the kernel, though there's other stuff like nfsroot= where
more parameters are needed. Is it possible to add a btrfsroot= option with
a UUID+subvolume?

With these features exposed to the booting process, it seems like there are
a *lot* of very powerful use cases that become possible with management of
the OS itself.

> But, that is a significant project, so we'll have to do it in stages.

Indeed. It's not my expectation it be done initially or even soon, just my
hope that it "eventually" become as flexible in booting as it is once the
system goes multi-user. :)

-Anthony
