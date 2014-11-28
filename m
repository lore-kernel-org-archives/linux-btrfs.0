Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaK1Jdk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 04:33:40 -0500
Date: Fri, 28 Nov 2014 10:33:27 +0100
From: Karel Zak <kzak@redhat.com>
To: dsterba@suse.cz, Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v4] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
Message-ID: <20141128093327.GA1994@x2.net.home>
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-2-git-send-email-anand.jain@oracle.com>
 <20141031090830.GP10134@x2.net.home>
 <54536CDA.4090901@oracle.com>
 <20141111114735.GA24268@x2.net.home>
 <20141114165127.GC8614@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141114165127.GC8614@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 14, 2014 at 05:51:27PM +0100, David Sterba wrote:
> On Tue, Nov 11, 2014 at 12:47:35PM +0100, Karel Zak wrote:
> >  What I see critical is missing ./configure, because it's pretty ugly
> >  to add hardcoded dependencies (e.g. libudev), there is also no checks
> >  for another libs, Makefile does not care about place where libs are
> >  installed, header files,  etc. etc.
> 
> It does, prefix and libdir are set conditionally, DESTDIR works.
> 
> >  Is there any fundamental problem with autoconf? If no, then I'm ready
> >  to send patches with some autotools stuff. Comments?
> 
> Yeah the build dependencies checks would be nice, there's no problem
> with autoconf.

 OK, I'll try to prepare something next week.

> The Makefile has been manualy crafted and supports some macro magic to
> build several binaries from one rule, static targets, quiet/verbose
> build. I want to preserve all of this so transition to automake may take
> time (or may not happen in the end).

 Just note, it's fine to expect (require) some build-system features,
 but IMHO it's bad idea to think about build system as about stable
 and always backwardly compatible interface (./configure options,
 Makefile vars, etc).

 For example for util-linux we have changed many many things in last
 (~7) years without negative feedback from downstream maintainers or
 users. IMHO more important is to follow usual conventions than assume
 that my "make FOO=bar" will work forever.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
