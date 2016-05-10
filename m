Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19191 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbcEJX6G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 19:58:06 -0400
Date: Tue, 10 May 2016 19:57:58 -0400
From: Chris Mason <clm@fb.com>
To: Eric Biggers <ebiggers3@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING at fs/btrfs/inode.c:9261 btrfs_destroy_inode()
Message-ID: <20160510235758.3ow2wdumtisauw4n@floor.thefacebook.com>
References: <20160510231920.GA938@zzz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160510231920.GA938@zzz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 06:19:20PM -0500, Eric Biggers wrote:
> Hello,
> 
> The following warning has been triggering for me since about v4.6-rc3:
> 
> 	WARN_ON(BTRFS_I(inode)->csum_bytes);
> 
> On one machine the warning has occurred 657 times since v4.6-rc5.  On another it
> has occurred 3 times since v4.6-rc3.  Both are now on v4.6-rc7, where I have
> still observed the warning.  The warnings occur in groups, and do_unlinkat() and
> evict() are always in the call stack.
> 
> Is this a known issue?  Here is the first occurrence:

It is a known issue, but I'm having a very hard time triggering it
quickly enough to track it down.  I do know csum_bytes is only 4096 or
8192 when it hits, but beyond that I haven't been able to trigger it
consistently enough to test a patch.

But, I'm trying ;)

-chris
