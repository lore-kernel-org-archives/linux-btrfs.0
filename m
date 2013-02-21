Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:54590 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3BUVlQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 16:41:16 -0500
Date: Thu, 21 Feb 2013 22:31:56 +0100
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: =?ISO-8859-1?B?U3fibWk=?= Petaramesh <swami@petaramesh.org>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
Message-ID: <20130221223156.5821a0a5@fem.tu-ilmenau.de>
In-Reply-To: <51265DB0.2060407@petaramesh.org>
References: <51264146.3070504@petaramesh.org>
	<1361462073.18057.23.camel@cwalton-XPS-8300>
	<512644DA.3050409@petaramesh.org>
	<20130221163844.GD14283@carfax.org.uk>
	<51265355.1020409@petaramesh.org>
	<20130221172502.GF14283@carfax.org.uk>
	<51265DB0.2060407@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 21 Feb 2013 18:47:28 +0100
Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Le 21/02/2013 18:25, Hugo Mills a écrit :
> > Correct. But btrfs isn't at that stage yet. It's getting visibly
> > closer, but it's not quite there. Hence the very strong
> > recommendation to keep up with the latest code. Hugo. 
> 
> The matter is that BTRFS had many early adopters just because it is -
> and has been for long now - in the mainline Linux kernel, so supposed
> stable and good choice for the future.

And it's marked as EXPERIMENTAL. So if you want to join the game, you
have to accept the rules.

> OTOH my 6th machine runs native ZFS on Linux, and I have to tell that
> it shows orders of magnitude better performance and never gave me a
> single problem in several (3 ?) years. Only upgrading the distro is
> always a big frightening and problematic. And initial installation
> was a bit tricky.

You didn't, many other had. I remember a lot of threads in the
OpenSolaris forum, where the solution for problems was: recreate your
filesystem, replay your backup.

> Everytime I show my Linux machines to friends and say : “Hey, I got
> the most advanced filesystem on earth !” I soon get the answer “Oh
> boy, that's the slowest machine boot and FS I've ever seen since I was
> reading floppy disks on my 386SX in 1991 ! Can you really live with
> this ?”

Did you presented it while (re)creating the inode_cache? Sounds a
little like that.

> So, for "not quite there" and the return codes "+20" that have been a
> minor pain in the arse for a couple years but the line is still in the
> code... I can understand developer's PoV, been there, done that, but
> still, BTRFS might in the end lose a numer of its early adopters if it
> keeps being "not quite there" too long.
> 
> Shitfing to ZFS is just a PPA and 2 apt-get install commands away...
> It will definitely be easier than start playing with mainline PPA
> Ubuntu kernels...

So why do you bother with btrfs, if ZFS fit your needs?


regards,
  Johannes
