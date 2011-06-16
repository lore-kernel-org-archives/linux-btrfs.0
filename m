From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [RFC][BTRFS-PROG] Avoid to scan cdrom and floppy
Date: Thu, 16 Jun 2011 22:07:53 +0200
Message-ID: <4DFA6299.3040904@libero.it>
References: <Bn+os9hi1uB@helmut.hullen.de>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Helmut Hullen <Hullen@t-online.de>, linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Bn+os9hi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut

On 06/16/2011 05:09 PM, Helmut Hullen wrote:
> Hallo, Josef,
>
> Du meintest am 16.06.11:
>
>>>> Who the hell doesn't use udev?
>
>>> Me - p.e.
>>> "udev" may be interesting for desktop users, for multimedia
>>> computers. It's not necessary for a simple server, for a machine
>>> where the administrator wants to rule instead of "udev".
>
>> You don't need udev to use btrfs, I've just not seen a distro that
>> allows you to not run with udev, so my question is more curiosity
>> than anything.
>
> But the developers seem to use only machines where "udev" runs.
>
> p.e. when testing the disks (I've told this bug about 1 year ago), p.e.
> with "/dev/btrfs-control".
>
> "btrfs-control" has to exist before btrfs is started, and there is
> neither a hint in the documentation nor a check.
>

Sorry Helmut, but I don't understand if you are blaming about lack of 
documentation or about a problem.

The fact that the file /dev/btrfs-control doesn't exist, is not a 
bug/problem of btrfs. This file should be created by the distribution: 
or via the udev or via devtmpfs or statically. In this is not different 
by any other device (like /dev/sdaX for example). They have to exists 
before mounting the root-filesystem.

BR
G.Baroncelli
