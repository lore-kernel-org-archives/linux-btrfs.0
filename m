Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933486AbaKNQv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 11:51:29 -0500
Date: Fri, 14 Nov 2014 17:51:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Karel Zak <kzak@redhat.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 2/2 v4] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
Message-ID: <20141114165127.GC8614@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-2-git-send-email-anand.jain@oracle.com>
 <20141031090830.GP10134@x2.net.home>
 <54536CDA.4090901@oracle.com>
 <20141111114735.GA24268@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141111114735.GA24268@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 11, 2014 at 12:47:35PM +0100, Karel Zak wrote:
>  What I see critical is missing ./configure, because it's pretty ugly
>  to add hardcoded dependencies (e.g. libudev), there is also no checks
>  for another libs, Makefile does not care about place where libs are
>  installed, header files,  etc. etc.

It does, prefix and libdir are set conditionally, DESTDIR works.

>  Is there any fundamental problem with autoconf? If no, then I'm ready
>  to send patches with some autotools stuff. Comments?

Yeah the build dependencies checks would be nice, there's no problem
with autoconf.

The Makefile has been manualy crafted and supports some macro magic to
build several binaries from one rule, static targets, quiet/verbose
build. I want to preserve all of this so transition to automake may take
time (or may not happen in the end).
