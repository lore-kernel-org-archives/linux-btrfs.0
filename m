Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:46843 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033AbbLOCif (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 21:38:35 -0500
Subject: Re: btrfs: poor performance on deleting many large files
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
 <pan$eea04$e9596e27$78b44461$c5754723@cox.net>
 <1448488198.4717.4.camel@gmail.com>
 <pan$8ce6a$31af576$4416e55e$7b867388@cox.net>
 <1448562347.8809.16.camel@scientia.net>
 <pan$54542$5eb77bd3$8682bff8$82310de1@cox.net>
 <1448582805.11377.9.camel@scientia.net>
 <pan$34543$2ed1f043$2f803125$884b36c0@cox.net>
 <1448683025.6837.4.camel@scientia.net>
 <pan$46a28$81694e9d$c6d5f048$1c8bcdd8@cox.net>
 <1449958538.15961.3.camel@scientia.net> <566ED124.30803@gmail.com>
 <1450121957.6629.41.camel@scientia.net> <566F261F.4040705@gmail.com>
 <566F34F0.8050407@bouton.name> <1450135505.6629.66.camel@scientia.net>
 <pan$c3e1a$7bad3839$12bcfe1f$4c2ff85e@cox.net>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <566F7D29.9000707@bouton.name>
Date: Tue, 15 Dec 2015 03:38:33 +0100
MIME-Version: 1.0
In-Reply-To: <pan$c3e1a$7bad3839$12bcfe1f$4c2ff85e@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 15/12/2015 02:49, Duncan a écrit :
> Christoph Anton Mitterer posted on Tue, 15 Dec 2015 00:25:05 +0100 as
> excerpted:
>
>> On Mon, 2015-12-14 at 22:30 +0100, Lionel Bouton wrote:
>>
>>> I use noatime and nodiratime
>> FYI: noatime implies nodiratime :-)
> Was going to post that myself.  Is there some reason you:
>
> a) use nodiratime when noatime is already enabled, despite the fact that 
> the latter already includes the former, or

I don't (for some time). I didn't check for nodiratime on all the
systems I admin so there could be some left around but as they are
harmless I only remove them when I happen to stumble on them.

>
> b) didn't sufficiently research the option (at least the current mount 
> manpage documents that noatime includes nodiratime under both the noatime 
> and nodiratime options,

I just checked: this has only be made crystal-clear in the latest
man-pages version 4.03 released 10 days ago.

The mount(8) page of Gentoo's current stable man-pages (4.02 release in
August) which is installed on my systems states for noatime:
"Do not update inode access times on this filesystem (e.g., for faster
access on the news spool to speed up news servers)."

This is prone to misinterpretation: directories are inodes but that may
not be self-explanatory for everyone. At least it could leave me with a
doubt if I wasn't absolutely certain of the behavior (see below): I'm
not sure myself that there isn't a difference between a VFS inode (the
in-memory structure) and an on-disk structure called inode which some
filesystems may not have (I may have been mistaken but IIRC ReiserFS
left me with the impression that it wasn't storing directory entries in
inodes or it didn't call it that).

In fact I remember that when I read statements about noatime implying
nodiratime I had to check fs/inode.c after I found a random discussion
on the subject mentioning the proof being in the code to make sure of
the behavior.


>  and at least some hint of that has been in the 
> manpage for years as I recall reading it when I first read of nodiratime 
> and checked whether my noatime options included it) before standardizing 
> on it, or
>
> c) might have actually been talking in general, and there's some mounts 
> you don't actually choose to make noatime, but still want nodiratime, or

I probably used this case for testing purposes (but don't remember a
case where it was useful to me).
The expression I used was not meant to describe the exact flags in fstab
on my systems but the general idea of avoiding files and directories
atime updates as by using noatime I'm implicitly using nodiratime too.
Sorry for the confusion (I've been confused about the subject a long
time which probably didn't help express myself clearly).

Best regards,

Lionel
