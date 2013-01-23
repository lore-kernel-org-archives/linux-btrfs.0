Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59627 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab3AWSML (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 13:12:11 -0500
Date: Wed, 23 Jan 2013 19:12:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, chris.mason@fusionio.com,
        sandeen@redhat.com
Subject: Re: [PATCH 2/6] Fedora 18 - build-fixes.patch
Message-ID: <20130123181209.GP28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358618781-26629-1-git-send-email-gene@czarc.net>
 <1358618781-26629-3-git-send-email-gene@czarc.net>
 <50FF03D8.3040009@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FF03D8.3040009@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:25:44PM -0500, Gene Czarcinski wrote:
> I believe that this if the likely source of this patch:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/4547

Thanks for the pointer.

> I do wonder how much this is still applicable.  However, it has been in the
> btrfs-progs package for Fedora 15, 16, 17, and 18 plus likely some versions
> of RHEL.

man getpagesize:

"Portable applications should employ sysconf(_SC_PAGESIZE) instead of getpagesize()"

added with the original changelog and s-o-b, modified the subject line
to say "Use sysconf instead of getpagesize".

david
