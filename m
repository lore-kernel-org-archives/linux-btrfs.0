Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbaKKLrn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 06:47:43 -0500
Date: Tue, 11 Nov 2014 12:47:35 +0100
From: Karel Zak <kzak@redhat.com>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2 v4] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
Message-ID: <20141111114735.GA24268@x2.net.home>
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-2-git-send-email-anand.jain@oracle.com>
 <20141031090830.GP10134@x2.net.home>
 <54536CDA.4090901@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54536CDA.4090901@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2014 at 07:04:58PM +0800, Anand Jain wrote:
> 
> 
> 
> 
> On 31/10/2014 17:08, Karel Zak wrote:
> >On Fri, Oct 31, 2014 at 12:11:20PM +0800, Anand Jain wrote:
> >>btrfs_scan_lblikd() is called by most the device related command functions.
> >>And btrfs_scan_lblkid() is most expensive function and it becomes more expensive
> >>as number of devices in the system increase. Further some threads call this
> >
> >wouldn't be possible to ask udev rather than scan all devices? I
> >understand than in some cases it's necessary to have robust and
> >independent solution, but for usual use-cases it would be less
> >expensive to read the info from udev where we already keep track about
> >all block devices and where we call libblkid.
> >
> >It would be possible to implement it as optional feature (#ifdev HAVE_LIBUDEV),
> >the library API is very easy to use.
> >
> >(For example lsblk uses libblkid as fallback, the default is udev).
> >
> >     Karel
> >
> >
> 
> I might be missing something, correct me if wrong. Is there any udev API
> which gives me a list of devices which hold btrfs ? I just browsed
> through there isn't any.

 See  udev_enumerate_* API, nice example:
 http://www.signal11.us/oss/udev/

 Anyway, I have sent patches that implement this feature to btrfs-progs. 

 What I see critical is missing ./configure, because it's pretty ugly
 to add hardcoded dependencies (e.g. libudev), there is also no checks
 for another libs, Makefile does not care about place where libs are
 installed, header files,  etc. etc.

 Is there any fundamental problem with autoconf? If no, then I'm ready
 to send patches with some autotools stuff. Comments?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
