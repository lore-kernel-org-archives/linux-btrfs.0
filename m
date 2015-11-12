Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:40246 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbbKLTV1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 14:21:27 -0500
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5644E6B5.9070405@inwind.it>
Date: Thu, 12 Nov 2015 20:21:25 +0100
MIME-Version: 1.0
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-11-09 11:56, Anand Jain wrote:
> These set of patches provides btrfs hot spare and auto replace support
> for you review and comments.

Hi Anand,

is there any reason to put this kind of logic in the kernel space ? I think that it could be more simply to create a daemon which checks the disks and when needed it starts a replace...

The pool policy could be more sophisticated: some filesystem could require a "dedicated" pool (for example because the disks are in the same enclosure); in other case a global pool may be more useful.

Another feature of this daemon could be to add a disk when the disk space is too low, or to start a balance when there is no space to allocate further chunk.....

Of course all these logic could be implemented in kernel space, but I think that we should avoid that when possible. Moreover in user space the logging is more easy....


Only my 2¢...

BR
G.Baroncelli
[...]

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
