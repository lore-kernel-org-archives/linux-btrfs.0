Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:56360 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751279AbbJEUJs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 16:09:48 -0400
Reply-To: kreijack@inwind.it
Subject: btrfs machine readable output [was Re: btrfs patches]
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
 <560FA944.3050606@digint.ch> <5610134D.9070807@inwind.it>
 <pan$c5775$3f0b408b$41f20753$9ede78d@cox.net> <561138F4.5090105@inwind.it>
 <56129171.4040200@digint.ch> <56129A7C.8060701@inwind.it>
 <5612B30A.9030308@tty0.ch>
To: Axel Burri <axel@tty0.ch>, David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5612D908.4000201@inwind.it>
Date: Mon, 5 Oct 2015 22:09:44 +0200
MIME-Version: 1.0
In-Reply-To: <5612B30A.9030308@tty0.ch>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Axel,

I add CC:linux-btrfs because I think that what you are saying is important and it was discussed in ML.

[we are talking about the Axel patches to "btrfs sub list" command]
On 2015-10-05 19:27, Axel Burri wrote:
> Hi Goffredo
> 
> Don't get me wrong, I don't want to blame you (or anyone), actually I'm
> only arguing what I think is best for btrfs. I started to write those
> patches because btrfs-scriptability is pretty bad (there is also "btrfs
> sub show" which has pretty un-parseable output"), and I think this is
> very important for the success of btrfs, and no-one seemed to address this.

In the past, when I developed the "btrfs fi usage/btrfs dev usage" I put a lot of effort to have an output easily machine readable: one data per line, key without space; I remember the battle to have in the key "_" instead of space :-)
However other people changed that to a more (human) readable output.

May be that I was wrong; I don't know. 

However for sure, if I look to other projects:
- systemd: it uses some btrfs capability, but it uses the ioctl directly.
- snapper: it uses ioctl directly

So I have to conclude that it is not common to use btrfs (as progs) directly.
Few times I noticed somebodies are working on a libbtrfs. May be this is a better approach.

> 
> I know that nowadays people expect to get shiny output from command-line
> tools, but IMHO it is much more important to have consistent
> machine-readable output before even thinking of human readability (since
> there are so many unix commands to translate it, e.g. "columns"). Now
> this is sadly not the case with btrfs-progs, and it's hard to change it
> when people are used to it. Note that when writing the patches I was
> also thinking of introducing some "--machine-readable" option, but this
> seemed so wrong to me...

I think that "--machine-readable" (or similar) is a better approach: the output of the btrfs command in the past is changed even drastically (give a look to my work on the mkfs.btrfs); but we could force us to have an output "backward compatible" and machine (programmer) friendly if a switch like "--machine-readable" is used.

[...]
> 
> Regards,
> 
> - Axel

BR
Goffredo


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
