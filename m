Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35066 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbF3QZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 12:25:05 -0400
Received: by pdbci14 with SMTP id ci14so8732362pdb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 09:25:04 -0700 (PDT)
Subject: Re: [PATCH] Btrfs: add autodefrag inode flag
To: dsterba@suse.cz, Omar Sandoval <osandov@fb.com>,
        linux-btrfs@vger.kernel.org
References: <49b5df0f2a140a18386d794447aae87e165e6559.1434679740.git.osandov@fb.com>
 <20150630161830.GI726@twin.jikos.cz>
From: Omar Sandoval <osandov@osandov.com>
Message-ID: <5592C2D5.1040304@osandov.com>
Date: Tue, 30 Jun 2015 09:24:53 -0700
MIME-Version: 1.0
In-Reply-To: <20150630161830.GI726@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2015 09:18 AM, David Sterba wrote:
> On Thu, Jun 18, 2015 at 07:10:47PM -0700, Omar Sandoval wrote:
>> In some cases, we may not want to enable automatic defragmentation for
>> the whole filesystem with the "autodefrag" mount option but we still
>> want to defragment specific files or directories. Add an inode flag
>> which allows us to do specify that.
> 
> While I think all sorts of inode flags can be useful, the autodefrag is
> a good example, please note that you're touching a public interface
> header
> 
>>  include/uapi/linux/fs.h |  1 +
> 
> so this should be discussed at fsdevel.

Ah, right, definitely. I'll resend the patch and CC fsdevel.

Thanks,
-- 
Omar
