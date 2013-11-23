Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab3KWBVl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 20:21:41 -0500
Date: Sat, 23 Nov 2013 02:21:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Roman Mamedov <rm@romanrm.net>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: [virt-devel] btrfs NOCOW for VM disk images
Message-ID: <20131123012138.GL5007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131122142051.GA32192@stefanha-thinkpad.redhat.com>
 <1616992290.20969836.1385137054390.JavaMail.root@redhat.com>
 <pan$25aa5$1906a260$3a199c05$d941ebdc@cox.net>
 <20131123040028.71a8ba4e@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131123040028.71a8ba4e@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 23, 2013 at 04:00:28AM +0600, Roman Mamedov wrote:
> On Fri, 22 Nov 2013 21:26:16 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
> > > During testing I found that the NOCOW flag prevents file cloning from
> > > working.  cp --reflink fails with EINVAL when the source file has the
> > > NOCOW flag set.
> > 
> > That would be expected, since disabling COW means the file will be 
> > updated in-place, and if reflink-copying was allowed, changing the one 
> > view in-place would by definition change the other view of the same file, 
> > since it /is/ the same file data.
> 
> However snapshotting a subvolume which has NOCOW files *is* allowed.
> I'm told data is then COW'ed only once, and only the areas that are changed
> after the snapshot has been made (or something along those lines).

This is correct.

> So since snapshotting+NOCOW can be combined and everything works
> automagically as expected, maybe reflink could be made to work as
> well?

This works (to my own surprise). The clone ioctl checks if the files
have the same status regarding checksums, so reflink from nocow -> nocow
should work.

What does not work if one does

  $ cp --reflink=always nocow-file somefile
  cp: failed to clone ‘soefile’ from ‘nocow’: Invalid argument

because cp creates somefile without nocow status. But precreating
somefile with chattr +C and the calling the command above, cp does not
complain.

Rewriting one file does not modify the other though output of filefrag
after the modification does not seem to reflect that the files do not in
fact share the same blocks:

File size of somefile is 2097152 (512 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     511:   54865266..  54865777:    512:             eof
somefile: 1 extent found

File size of nocow is 2097152 (512 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     511:   54865266..  54865777:    512:             eof
nocow: 1 extent found

files were dd'ed with zeros and differ in the first 4k:

  dd if=/dev/urandom of=somefile bs=4k count=1 conv=notrunc

So there's a bug somewhere, probably in reporting extents through fiemap of
the modified nocow file. This hides the actual position of the new block and
fragmentation.


david
