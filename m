Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaGBJei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 05:34:38 -0400
Date: Wed, 2 Jul 2014 11:34:37 +0200
From: David Sterba <dsterba@suse.cz>
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: move the check_argc_* functions into
 utils.c
Message-ID: <20140702093436.GX1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <20140627123528.GC1553@twin.jikos.cz>
 <1404100452-8894-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140701231101.GT1553@twin.jikos.cz>
 <CALOYprWCwP0o0of0FCzrZSw8B5cU8kZT=TQB8RPJ0hXu5fF8nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALOYprWCwP0o0of0FCzrZSw8B5cU8kZT=TQB8RPJ0hXu5fF8nQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 02, 2014 at 01:20:41AM +0100, WorMzy Tykashi wrote:
> I'm getting a build failure in integration-20140701 in regard to these changes:
> 
> ---------
>     [CC]     help.o
> help.c:23:23: error: 'ARGV0_BUF_SIZE' undeclared here (not in a function)
>  static char argv0_buf[ARGV0_BUF_SIZE];
>                        ^
> help.c:23:13: warning: 'argv0_buf' defined but not used [-Wunused-variable]
>  static char argv0_buf[ARGV0_BUF_SIZE];
>              ^
> Makefile:114: recipe for target 'help.o' failed
> make: *** [help.o] Error 1
> ---------

Oh sorry, fixed branch pushed. I've added the utils.h inlucde into
cmds-property.c as well, fixes "implicit declaration of function"
warnings.
