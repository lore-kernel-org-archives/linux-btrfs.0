From: Josef Bacik <josef@redhat.com>
Subject: Re: BTRFS should increase the hard-link in the same directory limit
Date: Mon, 22 Aug 2011 10:54:21 -0400
Message-ID: <4E526D9D.8010202@redhat.com>
References: <874o1aztkm.fsf-genuine-vii@john.fremlin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: John Fremlin <john@fremlin.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <874o1aztkm.fsf-genuine-vii@john.fremlin.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/21/2011 11:13 AM, John Fremlin wrote:
> It seems a priori that there should not be any need for more than 256
> names for the same file in the same directory. However, the GNUS
> mailreader's nnmaildir backend uses hardlinks to mark email messages
> read, and instead of creating a separate inode for each marked
> message, uses a hardlink to a single markfile. This means that there
> maybe thousands of hardlinks to the same inode in a single directory.
> 
> This is not unreasonable as the obvious workaround is to wastefully
> create more inodes. 
> 
> This restriction causes btrfs-convert 0.19 to crash out with a segfault and
> no helpful message: something like btrfs-convert: segfault at
> ffffffffcfb25fb9 ip 000000000040f9f1 sp 00007fffddefb398 error 6 in
> btrfs-convert[400000+21000].
> 
> Is there any plan to alleviate this unfortunate limit (or at least make
> btrfs-convert give the location of the file which causes it to fail?).

It's a disk format change, something we don't do lightly.

Josef
