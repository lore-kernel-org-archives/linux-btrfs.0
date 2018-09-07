Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35868 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726031AbeIGPSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:18:41 -0400
Date: Fri, 7 Sep 2018 12:38:03 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?J=FCrgen?= Herrmann <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
Message-ID: <20180907103803.GK24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 11:56:18AM +0200, Jürgen Herrmann wrote:
> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
> ago. So i wanted to compile latest btrfs-progs and latest stable kernel
> first before reporting that here, BUT: I cannot compile btrfs-progs 
> 4.17.1
> because of the following error:
> 
>      [CC]     convert/source-reiserfs.o
> In file included from convert/source-reiserfs.c:30:0:
> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No such 
> file or directory
>   #include <reiserfs/misc.h>
>            ^~~~~~~~~~~~~~~~~
> compilation terminated.
> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
> make: *** [convert/source-reiserfs.o] Error 1
> 
> A google search did not turn up any help nor does apt know of any
> reiserfs related libs that i could install.

The build dependencies are in the file INSTALL.
