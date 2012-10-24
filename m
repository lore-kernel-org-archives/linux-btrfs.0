Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:52351 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816Ab2JXRXu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 13:23:50 -0400
Date: Wed, 24 Oct 2012 18:23:32 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: "frantz.hacquard" <frantz.hacquard@ensi-bourges.fr>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: help with btrfs send
Message-ID: <20121024172332.GC8624@campbell-lange.net>
References: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d867c8a573d19560c7b7f3aba7394b10@ensi-bourges.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24/10/12, frantz.hacquard (frantz.hacquard@ensi-bourges.fr) wrote:
> I don't know if it's the good place to ask my question.
> I'm a french student who studies IT.
> I'm working on a project with the btrfs filesystem on Gentoo 64 bits.
> I have to create snapshots and to compare the differences between
> them (new files, deleted files, modified files...).
> So i tried to use btrfs send -i old-snap new-snap.
> To make this command working i created my snapshots thanks to the -r
> option.
> However i only see on the standard output many weird characters but
> i don't understand them.
> I know it's still in developement but is it working ?
> I tried with kernel 3.6.2 and 3.7.0

Hi Frantz

The output of 'btrfs send' is in binary format. You can read more about
what is contained in the data stream in Jonathan Corbet's posting at LWN
here http://lwn.net/Articles/506244/

You'd normally do send/receive something like this:

    btrfs send /backup/start | btrfs receive /destination

There are also some notes on the btrfs wiki here, by Alexander Block
https://btrfs.wiki.kernel.org/index.php/Design_notes_on_Send/Receive
however I believe these are a bit out of date now.

You can look at the latest code for btrfs-progs here:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=summary
you may in particular want to look at Alexander Block's patchset here:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=commit;h=f1c24cd80dfd037407cdee85181646adca6dd5bb

-- 
Rory Campbell-Lange
rory@campbell-lange.net
