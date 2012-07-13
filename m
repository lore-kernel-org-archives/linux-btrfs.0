Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:52963 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2GMMYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jul 2012 08:24:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can't mount, power failure - recoverable?
Date: Fri, 13 Jul 2012 14:23:53 +0200
Cc: Skylar Burtenshaw <daninfuchs@gmail.com>
References: <loom.20120317T051243-551@post.gmane.org> <CAG1y0sdg18Dv2YA_WDRSYp3eGTHO-V2xx99OXxDJQx=O4qqgHA@mail.gmail.com> <loom.20120326T104619-458@post.gmane.org> (sfid-20120326_145651_375630_46F88BE9)
In-Reply-To: <loom.20120326T104619-458@post.gmane.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207131423.54019.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 26. März 2012 schrieb Skylar Burtenshaw:
> Fajar A. Nugraha <list <at> fajar.net> writes:
> > Didn't Chris' last response basically say "use kernel 3.2 or newer,
> > mount the fs (possibly with -o ro), and copy the data elsewhere"?
> 
> Why yes, yes it did actually. I appreciate your spotlighting it, just
> in case I somehow managed to miss it, though.
> 
> > Have you done that?
> 
> I have. In fact, in my first message, I stated that in all kernels up
> to present 3.2 kernels, I get several minutes of disk churning, then a
> stack trace. Also present in my messages is the fact that the
> filesystem will not mount, as well as data output from the recovery
> program etc which fail to recognize things in the filesystem that they
> require in order to fix it. Did you have something you wished to
> suggest, in order to help me? If so, I'd gladly listen to any proposed
> ideas.

Since I didn´t found any explicit mention on it:

Did you try btrfs-zero-log on the partition prior to mounting it?

All of my BTRFS will not mount after sudden write interruption cases have 
been solved by it. Except one with a BTRFS RAID 0 with lots of 2 TB drives 
at a time where I didn´t know about btrfs-zero-log. Maybe it would have 
helped there, too.

Of course I could be completely off track and this could be a completely 
different issue.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
