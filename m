Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaL2PJF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 10:09:05 -0500
Date: Mon, 29 Dec 2014 16:09:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Chris Murphy <chris@colorremedies.com>
Subject: Re: [PATCH] btrfs: suppress a build warning on building 32bit kernel
Message-ID: <20141229150903.GH6490@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com>
 <549BD725.8040603@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549BD725.8040603@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 25, 2014 at 06:21:41PM +0900, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2190,7 +2190,7 @@ void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end)
>   
>   		next = next_state(state);
>   
> -		failrec = (struct io_failure_record *)state->private;
> +		failrec = (struct io_failure_record *)(unsigned long)state->private;

We're always using the 'private' data to store a pointer to
'struct io_failure_record *', please change the defintion in
'struct extent_state' instead of the typecasting.

>   		free_extent_state(state);
>   		kfree(failrec);
