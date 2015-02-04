Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbbBDLkp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 06:40:45 -0500
Date: Wed, 4 Feb 2015 12:40:39 +0100
From: Karel Zak <kzak@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-prog: improve build-system by autoconf
Message-ID: <20150204114039.GB1238@ws.net.home>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
 <20141217140726.GY27601@twin.jikos.cz>
 <20150116152613.GC2181@x2.net.home>
 <20150128153815.GG3641@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150128153815.GG3641@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 28, 2015 at 04:38:15PM +0100, David Sterba wrote:
> Rebased on 3.18.3, fixed some minor conflicts.
> 
> * I'm a bit surprised that automake is required for the
>   config.{guess,sub} and install-sh files

 well, it's not required, but autoconf does not provide the scripts.
 You have to maintain the scripts in git three (IMHO not elegant
 solution) or use the scripts from automake.
 
 This problem does not exist if you have fully "autotoolized" project,
 because automake provides automatically all the scripts.

> * my oldish testbox' automake does not support the --print-libdir option
>   (automake-1.11), enterprise distros ship automake of similar age
> 
> * library build test fails, but this may be because I've mismerged
>   something, I'll check again
> 
> Otherwise looks ok and I'll merge it, plus a few fixups to make it build
> for me.
> 
> >     https://github.com/karelzak/btrfs-progs/commits/autoconf
> > 
> >  you can merge it (now or later) on command line by:
> > 
> >     git pull --log git@github.com:karelzak/btrfs-progs.git autoconf
> 
> git-pulls are not (yet) established workflow, mailinglist is preferred,
> but it does not hurt to publish branches along.

 OK.

> I've noticed the 'automake' branch that switches to automake. Looking at
> the amount of changes and the result, I'm not quite happy and don't see
> the benefit of automake. An extra layer that only obfuscates the build.

 I don't think the set of changes is so huge, all the changes are
 mostly Makefile.am.
 
 Anyway, why automake:

  - it's way how to standardize build-system, the automake rules are
    really easy to read, the Makefile.am files are almost the same in
    all projects. 

  - automake+autoconf provides AM_CONDITIONAL(), so you can keep your
    makefiles pretty simple and maintain all if-then logic in ./configure
    script where you have available shell and huge number of tests.

    For example in util-linux we have many internal and external
    dependencies, but in makefiles we have only "if BUILD_UTILNAME",
    all logic is strictly in ./configure.ac

  - provides large set of targets

  - provides more portable environment
    (for example: if you want to distribute man pages, then
    dist_man_MANS += foo.8 is enough, you don't have to care about
    target directories for the man page section, etc.)

  - forces maintainer to generate better tarballs, after successful
    "make diskcheck" you can be sure that your tarballs are really
    usable (for example -- do you know how many header files are
    missing in the current btrfs-progs Makefile? Do you have a way how
    to check it?)

  - manually write and maintain smart build-system is difficult and
    result is almost always very complex stuff

 There is only one disadvantage, developers have to learn something
 new. Yes, people hate this thing :-)

 I guess we will see more and more stuff in btrfs-progs, so it's
 better to the change now than later. 
 
 See e2fsprogs (sorry Ted), it's result of "automake only obfuscates", 
 many Makefile.in files, '@' everywhere, nightmare.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
