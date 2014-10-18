Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:40813 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936AbaJRNdM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Oct 2014 09:33:12 -0400
Message-ID: <54426C16.5030206@pobox.com>
Date: Sat, 18 Oct 2014 06:33:10 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: russell@coker.com.au, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au>
In-Reply-To: <201410181454.19375.russell@coker.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/17/2014 08:54 PM, Russell Coker wrote:
> # find . -name "*546"
> ./1412233213.M638209P10546
> # ls -l ./1412233213.M638209P10546
> ls: cannot access ./1412233213.M638209P10546: No such file or directory
>
> Any suggestions?
>

Does "ls -l *546" show the file to exist? e.g. what happens if you use 
the exact same wildcard in the ls command as you used in the find?

It is possible (and back in the day it was quite common) for files to be 
created with non-renderable nonsense in the name. for instance if the 
first four characters of the name were "13^H4" (where ^H is the single 
backspace character) the file wold look like it was named 14* but it 
would be listed by ls using "13*". If the file name is "damaged", which 
is usually a failing in the program that created the file, then it can 
be "hidden in plain sight".

Note that this sort of name is hidden from the copy-paste done in the 
terminal window because the binary nonsense is just not in the output 
any more by the time you select it with the mouse.

It doesn't have to be a backspace, BTW, it can be any character that the 
terminal window will not render.

If things get really ugly you may need to remove the file using

find . -name "*546" -exec rm "{}" \;

(This takes the wildcard expansion out of the hands of the shell and 
makes it happen in the find command, which may have different 
functionality in your build.)

Anyway, this sort of mangled file name can happen in any file system as 
the various binary and non-printable name elements are completely legal 
in the POSIX standard.

-- Rob.
