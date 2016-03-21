Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36431 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbcCUWoQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 18:44:16 -0400
Received: by mail-pf0-f196.google.com with SMTP id q129so32953519pfb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 15:44:16 -0700 (PDT)
Received: from mail-pf0-f173.google.com (mail-pf0-f173.google.com. [209.85.192.173])
        by smtp.googlemail.com with ESMTPSA id 85sm13939729pfq.6.2016.03.21.15.44.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Mar 2016 15:44:15 -0700 (PDT)
Received: by mail-pf0-f173.google.com with SMTP id n5so281585489pfn.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 15:44:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321174914.GC8095@twin.jikos.cz>
References: <CAO8L9g6EpXMNjWVunz2A-EPwGHBo=18T_a+3xovqMbHux3aHsw@mail.gmail.com>
 <20160321174914.GC8095@twin.jikos.cz>
From: Dan Fuhry <dan@fuhry.com>
Date: Mon, 21 Mar 2016 18:43:55 -0400
Message-ID: <CAO8L9g5R_v7UMtiop6KogdPZ7=sK6Q75atPPgPcvpaedwVbitg@mail.gmail.com>
Subject: Re: [PATCH] Add support for RENAME_{EXCHANGE,WHITEOUT}
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 1:49 PM, David Sterba <dsterba@suse.cz> wrote:
>
> On Thu, Jan 28, 2016 at 10:52:28AM -0500, Dan Fuhry wrote:
> > Add support for the RENAME_WHITEOUT and RENAME_EXCHANGE flags in
> > renameat2(). This brings us pretty close to having btrfs ready to be
> > an upper layer for overlayfs. (The last remaining issue is in
> > btrfs_sync_file, which I'm looking at next if I have time.)
>
> The sync_file issue should be fixed by filipes' fix from today.
>
> > This includes Davide Italiano's implementation of RENAME_EXCHANGE. I
> > quickly pinged him on github [1] last week to confirm resubmission of
> > his patch which originally went to this list on 2 April 2015 and
> > didn't make it in.
> >
> > This is my first time submitting a kernel patch, I think I've covered
> > all the style recommendations, and also addressed Filipe David
> > Manana's review notes [2] on Davide Italiano's patch. Certainly let me
> > know if there's anything else that should be cleaned up. Thanks!
>
> The patch style looks, I've briefly tested it in fstests and it blows
> very quickly, the stacktraces are unreadable. So I could mismerge it or
> there's another reason. Anyway, I'm going to pick this patch for 4.7 and
> will add it to my for-next after the crashes are resolved.

David,
Thanks for looking at this. I will test against for-linus-4.6 tomorrow
(unless there's a better branch to build against - I'm a noob here)
and see if I can find anything obvious.

I've had success with a rudimentary test that evaluates only the two
new rename modes, and does not test behavior when subvolumes are
involved, but have yet to subject it to a larger test suite such as
xfstests. So it wouldn't surprise me if it breaks down there. I'll try
and get that going on my system and see if I can reproduce.

Dan
