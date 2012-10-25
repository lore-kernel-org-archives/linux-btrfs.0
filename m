Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44926 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331Ab2JYO6o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 10:58:44 -0400
Date: Thu, 25 Oct 2012 16:58:41 +0200
From: David Sterba <dave@jikos.cz>
To: Ins <insfocus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: mkfs.btrfs allow to set the sectorsize by the -s option but the
 kernel doesnot
Message-ID: <20121025145841.GF10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAMRmmpK8rYQDRWVM6nxsc2kouFNPyAnwAfB6Y19Ha40rLdeejA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMRmmpK8rYQDRWVM6nxsc2kouFNPyAnwAfB6Y19Ha40rLdeejA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 24, 2012 at 02:39:34PM +0800, Ins wrote:
>   mkfs.btrfs allows to set the sectorsize by the -s option.
...
> 2366        if (sectorsize != PAGE_SIZE) {
> 2367                printk(KERN_WARNING "btrfs: Incompatible sector size(%lu) "
> 2368                       "found on %s\n", (unsigned long)sectorsize, sb->s_id);
> 2369                goto fail_sb_buffer;
> 2370        }
...
> So the actually reason is?

The state is 'not implemented', the sectorsize == page size is a hard
requirement in current impelementation, though this may change.


david
