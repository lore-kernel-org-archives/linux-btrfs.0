Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbcE0AEF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 20:04:05 -0400
Date: Thu, 26 May 2016 17:04:01 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160527000401.GW7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 05:45:12AM +0200, Adam Borowski wrote:
> (Only btrfs currently implements dedupe_file_range.)
> 
> Instead of checking the mode of the file descriptor, let's check whether
> it could have been opened rw.  This allows fixing failures when deduping
> a live system: anyone trying to exec a file currently being deduped gets
> ETXTBSY.
> 
> Issuing this ioctl on a ro file was already allowed for root/cap.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>

Hi Adam, this patch seems reasonable to me but I have to admit to being
worried about 'unintended consequences'. I poked around the code in fs/ for
a bit and saw mostly checks against file open mode. It might be that dedupe
is a special case due to the potential for longer running operations, but
theoretically you'd see the same problem if trying to exec against a file
being cloned too, correct? If that's the case then I wonder how this issue
gets solved for other ioctls.
	--Mark

--
Mark Fasheh
