Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33202 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbcANOmi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 09:42:38 -0500
Received: by mail-ob0-f182.google.com with SMTP id is5so84500103obc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 06:42:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160114124748.GV4227@suse.cz>
References: <20160114124748.GV4227@suse.cz>
From: Noah Massey <noah.massey@gmail.com>
Date: Thu, 14 Jan 2016 09:41:58 -0500
Message-ID: <CADfjVrjSDsD84MJ=kaXNFMj_Mgjnf5_nskROyt=nuTGgTJO3ew@mail.gmail.com>
Subject: Re: Btrfs progs pre-release 4.4-rc1
To: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        clm@fb.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 7:47 AM, David Sterba <dsterba@suse.cz> wrote:
> Hi,
>
> the btrfs-progs 4.4-rc1 has been tagged. This is a heads-up before the release
> (ETA tmorrow). Please give it some testing.

$ ./autogen.sh && ./configure && make static

Generate build-system by:
   aclocal:    aclocal (GNU automake) 1.15
   autoconf:   autoconf (GNU Autoconf) 2.69
   autoheader: autoheader (GNU Autoconf) 2.69
   automake:   automake (GNU automake) 1.15

....
    [LD]     btrfs.static
help.static.o: In function `usage_command':
/usr/local/src/btrfs-progs/help.c:120: multiple definition of `usage_command'
help.static.o:/usr/local/src/btrfs-progs/help.c:120: first defined here
help.static.o: In function `usage':
help.c:(.text.usage+0x0): multiple definition of `usage'
help.static.o:help.c:(.text.usage+0x0): first defined here
help.static.o: In function `usage_command_group_short':
help.c:(.text.usage_command_group_short+0x0): multiple definition of
`usage_command_group_short'
help.static.o:help.c:(.text.usage_command_group_short+0x0): first defined here
help.static.o: In function `usage_command_group':
help.c:(.text.usage_command_group+0x0): multiple definition of
`usage_command_group'
help.static.o:help.c:(.text.usage_command_group+0x0): first defined here
help.static.o: In function `help_unknown_token':
help.c:(.text.help_unknown_token+0x0): multiple definition of
`help_unknown_token'
help.static.o:help.c:(.text.help_unknown_token+0x0): first defined here
help.static.o: In function `help_command_group':
help.c:(.text.help_command_group+0x0): multiple definition of
`help_command_group'
help.static.o:help.c:(.text.help_command_group+0x0): first defined here
help.static.o: In function `prefixcmp':
help.c:(.text.prefixcmp+0x0): multiple definition of `prefixcmp'
help.static.o:help.c:(.text.prefixcmp+0x0): first defined here
help.static.o: In function `help_ambiguous_token':
help.c:(.text.help_ambiguous_token+0x0): multiple definition of
`help_ambiguous_token'
help.static.o:help.c:(.text.help_ambiguous_token+0x0): first defined here
collect2: error: ld returned 1 exit status
Makefile:269: recipe for target 'btrfs.static' failed
make: *** [btrfs.static] Error 1


git bisect blames  a6cc8ea10ad84e4b7d1303ed048e644f0dd7ae04

~ Noah
