Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41939 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3AROol (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 09:44:41 -0500
Date: Fri, 18 Jan 2013 15:44:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
Message-ID: <20130118144439.GB19967@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130117174721.GD22785@twin.jikos.cz>
 <50F95920.406@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F95920.406@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 18, 2013 at 09:16:00AM -0500, Gene Czarcinski wrote:
> >Sergei Trofimovich (1):
> >       version.sh: fix version when built from tarball
> While you are about it, how about adding in this fix from Dieter Ries to fix
> version a little more:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/20069

I did not notice it before, but Dieter's patch does not work when progs
are built from .git repository

-echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
+echo "#define BTRFS_BUILD_VERSION \"$v\"" >> .build-version.h

$v is set with the git tag, so the "Btrfs" string does not appear in the
output (eg. mkfs.btrfs).

Technically, $v should always contain some sort of a tag, Sergei's patch
hardcodes it to the latest one for the non-git case. This is IMHO the
right approach.

david
