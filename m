Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42836 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcE0AsW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 20:48:22 -0400
Date: Fri, 27 May 2016 02:48:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160527004811.GA30490@angband.pl>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160527000401.GW7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 05:04:01PM -0700, Mark Fasheh wrote:
> On Fri, May 20, 2016 at 05:45:12AM +0200, Adam Borowski wrote:
> > (Only btrfs currently implements dedupe_file_range.)
> > 
> > Instead of checking the mode of the file descriptor, let's check whether
> > it could have been opened rw.  This allows fixing failures when deduping
> > a live system: anyone trying to exec a file currently being deduped gets
> > ETXTBSY.
> > 
> > Issuing this ioctl on a ro file was already allowed for root/cap.
> 
> Hi Adam, this patch seems reasonable to me but I have to admit to being
> worried about 'unintended consequences'. I poked around the code in fs/ for
> a bit and saw mostly checks against file open mode.

I can't think of any unintended consequences:
* root already could dedupe a file opened ro, so the code can handle that
* a file being open ro but you having rw rights means you could have opened
  it rw

There are details related to inode_permission() I admit I don't fully
understand but I believe those don't really matter as reasons for not just
allowing FILE_EXTENT_SAME for anyone who can read the file are quite
far-fetched.

> It might be that dedupe is a special case due to the potential for longer
> running operations, but theoretically you'd see the same problem if trying
> to exec against a file being cloned too, correct?  If that's the case then
> I wonder how this issue gets solved for other ioctls.

Clone is a destructive operation that overwrites the file.  FILE_EXTENT_SAME
on the other hand makes no changes to the Posix view of the file, just to
its internal representation.


Meow!
-- 
An imaginary friend squared is a real enemy.
