Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41736 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752406AbaKUUJN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 15:09:13 -0500
Date: Fri, 21 Nov 2014 15:08:48 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
 write_time()
To: "Theodore Ts'o" <tytso@mit.edu>
CC: <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <1416600528.24312.10@mail.thefacebook.com>
In-Reply-To: <1416599964-21892-2-git-send-email-tytso@mit.edu>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 21, 2014 at 2:59 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> In preparation for adding support for the lazytime mount option, we
> need to be able to separate out the update_time() and write_time()
> inode operations.  Currently, only btrfs and xfs uses update_time().
> 
> We needed to preserve update_time() because btrfs wants to have a
> special btrfs_root_readonly() check; otherwise we could drop the
> update_time() inode operation entirely.

No objections here, I'll give the queue a whirl.  You can add my 
acked-by-or-Ill-fix-whatever-breaks

I look forward to the patch that makes us all lazy by default.

-chris



