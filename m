Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbcESMBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 08:01:01 -0400
Date: Thu, 19 May 2016 14:00:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/3] btrfs-progs: fix make install failure
Message-ID: <20160519120032.GB29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463634794-591-1-git-send-email-anand.jain@oracle.com>
 <1463634794-591-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1463634794-591-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 01:13:12PM +0800, Anand Jain wrote:
> /usr/bin/install -c -m644 -d 64-btrfs-dm.rules /usr/lib/udev/rules.d
> /usr/bin/install: cannot create directory ‘64-btrfs-dm.rules’: File exists
> Makefile:400: recipe for target 'install' failed
> make: *** [install] Error 1
> 
> fixes: btrfs-progs: udev: add rules for dm devices

>  ifneq ($(udevdir),)
> -	$(INSTALL) -m644 -d $(udev_rules) $(DESTDIR)$(udevruledir)
> +	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
>  endif

We have to conditionally create the directory, so extra -d on the
udevrule or -D is needed. Looking at the patch we have in openSUSE, it
does the former. I'll update the patch.

