Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60623 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348AbbCROXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 10:23:52 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Date: Wed, 18 Mar 2015 15:23:50 +0100
Message-ID: <7757761.93uGJVH8dW@merkaba>
In-Reply-To: <20150318135230.GA20767@twin.jikos.cz>
References: <9389540.MYekrP2a8Q@merkaba> <1929370.YSr7hGqtmM@merkaba> <20150318135230.GA20767@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 18. März 2015, 14:52:30 schrieb David Sterba:
> On Wed, Mar 18, 2015 at 02:31:43PM +0100, Martin Steigerwald wrote:
> > Am Dienstag, 17. März 2015, 17:07:17 schrieb David Sterba:
> > > On Tue, Mar 17, 2015 at 02:33:30PM +0100, Martin Steigerwald wrote:
> > > > On BTRFS I see
> > > > 
> > > > martin@merkaba:~> ls -lid /usr/local
> > > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local
> > > > martin@merkaba:~> ls -lid /usr/local/.
> > > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/.
> > > > martin@merkaba:~> ls -lid /usr/local/bin/..
> > > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/bin/..
> > > > 
> > > > On other filesystems like Ext4 I see the actual number of
> > > > hardlinks to
> > > > the directory.
> > > > 
> > > > Is this intended behaviour of BTRFS or a bug?
> > > 
> > > Intended behaviour, this has been asked in the past, I don't have
> > > the
> > > link sorry, try searching the mailinglist archives.
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/14634
> 
> "Directories always have a link count of 1 in btrfs.  This tells find
> not to use the link count as the count of subdirectories in the
> directory."
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/29906
> 
> "As I understand it, inferring the number of directory entries from
> st_nlink is an optimization that isn't universally valid. If that
> count is 1, it must be considered invalid, and programs that don't
> handle this correctly are broken.  Coreutils handle this, at least..."

Okay, thanks. That was before I subscribed to BTRFS mailinglist so not in 
local mail archive.

It explains that having a correct hardlink number for directory is not 
mandatory, but it doesn´t explain why BTRFS always has 1 in there instead 
of the actual count of hardlinks. Is this an performance optimization for 
BTRFS or are there any other reasons why BTRFS does it this way?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
