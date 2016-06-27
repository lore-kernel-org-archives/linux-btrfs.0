Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:37945 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870AbcF0Ga1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 02:30:27 -0400
Message-ID: <1467009019.1982.14.camel@sapo.pt>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
From: Vasco Almeida <vascomalmeida@sapo.pt>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 27 Jun 2016 06:30:19 +0000
In-Reply-To: <CAJCQCtSaMTA4a8+jGO8TXEQCQi7Yi2pS-S2qPNKt8q1eZSkULA@mail.gmail.com>
References: <loom.20160623T205347-371@post.gmane.org>
	 <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo>
	 <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
 <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
 <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com>
	 <1466946315.4049.19.camel@sapo.pt>
	 <CAJCQCtSaMTA4a8+jGO8TXEQCQi7Yi2pS-S2qPNKt8q1eZSkULA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A Dom, 26-06-2016 às 13:54 -0600, Chris Murphy escreveu:
> On Sun, Jun 26, 2016 at 7:05 AM, Vasco Almeida <vascomalmeida@sapo.pt
> > wrote:
> > I have tried "btrfs check --repair /device" but that seems do not
> > do
> > any good.
> > http://paste.fedoraproject.org/384960/66945936/
> 
> It did fix things, in particular with the snapshot that was having
> problems being dropped. But it's not enough it seems to prevent it
> from going read only.
> 
> There's more than one bug here, you might see if the repair was good
> enough that it's possible to use brtfs-image now.

File system image available at (choose one link)
https://mega.nz/#!AkAEgKyB!RUa7G5xHIygWm0ALx5ZxQjjXNdFYa7lDRHJ_sW0bWLs
https://www.sendspace.com/file/i70cft

>  If not, use
> btrfs-debug-tree <dev> > file.txt and post that file somewhere. This
> does expose file names. Maybe that'll shed some light on the problem.
> But also worth filing a bug at bugzilla.kernel.org with this debug
> tree referenced (probably too big to attach), maybe a dev will be
> able
> to look at it and improve things so they don't fail.

Should I file a bug report with that image dump linked above or btrfs-
debug-tree output or both?
I think I will use the subject of this thread as summary to file the
bug. Can you think of something more suitable or is that fine?

> > What else can I do or I must rebuild the file system?
> 
> Well, it's a long shot but you could try using --repair --init-csum
> which will create a new csum tree. But that applies to data, if the
> problem with it going read only is due to metadata corruption this
> won't help. And then last you could try --init-extent-tree. Thing I
> can't answer is which order to do it in.
> 
> In any case there will be files that you shouldn't trust after csum
> has been recreated, anything corrupt will now have a new csum, so you
> can get silent data corruption. It's better to just blow away this
> file system and make a new one and reinstall the OS. But if you're
> feeling brave, you can try one or both of those additional options
> and
> see if they can help.

I think I will reinstall the OS since, even if I manage to recover the
file system from this issue, that OS will be something I can not trust
fully.
