Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbbCRNwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 09:52:32 -0400
Date: Wed, 18 Mar 2015 14:52:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Message-ID: <20150318135230.GA20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9389540.MYekrP2a8Q@merkaba>
 <20150317160717.GU20767@twin.jikos.cz>
 <1929370.YSr7hGqtmM@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1929370.YSr7hGqtmM@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 02:31:43PM +0100, Martin Steigerwald wrote:
> Am Dienstag, 17. März 2015, 17:07:17 schrieb David Sterba:
> > On Tue, Mar 17, 2015 at 02:33:30PM +0100, Martin Steigerwald wrote:
> > > On BTRFS I see
> > > 
> > > martin@merkaba:~> ls -lid /usr/local
> > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local
> > > martin@merkaba:~> ls -lid /usr/local/.
> > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/.
> > > martin@merkaba:~> ls -lid /usr/local/bin/..
> > > 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/bin/..
> > > 
> > > On other filesystems like Ext4 I see the actual number of hardlinks to
> > > the directory.
> > > 
> > > Is this intended behaviour of BTRFS or a bug?
> > 
> > Intended behaviour, this has been asked in the past, I don't have the
> > link sorry, try searching the mailinglist archives.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/14634

"Directories always have a link count of 1 in btrfs.  This tells find
not to use the link count as the count of subdirectories in the
directory."

http://thread.gmane.org/gmane.comp.file-systems.btrfs/29906

"As I understand it, inferring the number of directory entries from
st_nlink is an optimization that isn't universally valid. If that
count is 1, it must be considered invalid, and programs that don't
handle this correctly are broken.  Coreutils handle this, at least..."
