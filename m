Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:42490 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbcEZW5V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 18:57:21 -0400
Date: Fri, 27 May 2016 00:57:01 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] btrfs,vfs: allow FILE_EXTENT_SAME on a file opened ro
Message-ID: <20160526225701.GA22924@angband.pl>
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

>  fs/read_write.c | 2 +-

I'm unsure whom to bother with this patch.  I've sent it to -btrfs as it's
relevant only to btrfs (at least currently), but technically the file
changed belongs to vfs.  Was CCing -fsdevel enough or should I
retarget/resend the patch?


Apologies for a newbish question.
Meow!
-- 
An imaginary friend squared is a real enemy.
