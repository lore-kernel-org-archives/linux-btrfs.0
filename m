Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:34603 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3ARPtW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 10:49:22 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130118154921.PQCM17456.eastrmfepo201.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 18 Jan 2013 10:49:21 -0500
Message-ID: <50F96F00.3040008@czarc.net>
Date: Fri, 18 Jan 2013 10:49:20 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
References: <20130117174721.GD22785@twin.jikos.cz> <50F95920.406@czarc.net> <20130118144439.GB19967@twin.jikos.cz>
In-Reply-To: <20130118144439.GB19967@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/18/2013 09:44 AM, David Sterba wrote:
> On Fri, Jan 18, 2013 at 09:16:00AM -0500, Gene Czarcinski wrote:
>>> Sergei Trofimovich (1):
>>>        version.sh: fix version when built from tarball
>> While you are about it, how about adding in this fix from Dieter Ries to fix
>> version a little more:
>> http://article.gmane.org/gmane.comp.file-systems.btrfs/20069
> I did not notice it before, but Dieter's patch does not work when progs
> are built from .git repository
>
> -echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
> +echo "#define BTRFS_BUILD_VERSION \"$v\"" >> .build-version.h
>
> $v is set with the git tag, so the "Btrfs" string does not appear in the
> output (eg. mkfs.btrfs).
>
> Technically, $v should always contain some sort of a tag, Sergei's patch
> hardcodes it to the latest one for the non-git case. This is IMHO the
> right approach.
>
OK, I see what you mean.  However, the current situation when btrfs is 
built from a tarball results in:

 >btrfs  --version
Btrfs Btrfs v0.19

and

 >mkfs.btrfs  -V
mkfs.btrfs, part of Btrfs Btrfs v0.19

There must be a way to reliably just have one "Btrfs" and I will look 
into it.

Gene
