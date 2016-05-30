Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35526 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbcE3MZM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 08:25:12 -0400
Date: Mon, 30 May 2016 14:24:57 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Mark Fasheh <mfasheh@suse.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160530122457.GA28316@angband.pl>
References: <1463715912-8005-1-git-send-email-kilobyte@angband.pl>
 <20160527000401.GW7633@wotan.suse.de>
 <20160528015922.GI15597@hungrycats.org>
 <20160529002103.GA31105@angband.pl>
 <20160529005639.GA3576@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160529005639.GA3576@hungrycats.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 28, 2016 at 08:56:39PM -0400, Zygo Blaxell wrote:
> On Sun, May 29, 2016 at 02:21:03AM +0200, Adam Borowski wrote:
> > In any case, this patch doesn't introduce any cases not already triggerable
> > by root.
> 
> It allows non-root to trigger cases that previously could only be
> triggered by root.

Only the proposed "ro is enough" variant does.  The patch, as written,
requires write permission on the inode, thus alleviating your concerns:
* mangling the contents of dstfile: the user has rw access so he can do that
  already
* triggering a bug: the user could have opened dstfile rw (like duperemove
  currently does)


Meow!
-- 
An imaginary friend squared is a real enemy.
