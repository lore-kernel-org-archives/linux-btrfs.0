Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbaA0RTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 12:19:13 -0500
Date: Mon, 27 Jan 2014 18:19:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 1/6] btrfs: search_ioctl accepts varying buffer
Message-ID: <20140127171911.GA6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <1390829312-814-2-git-send-email-Gerhard@Heift.Name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390829312-814-2-git-send-email-Gerhard@Heift.Name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 27, 2014 at 02:28:27PM +0100, Gerhard Heift wrote:
> @@ -1931,17 +1931,22 @@ overflow:
>  }
>  
>  static noinline int search_ioctl(struct inode *inode,
> -				 struct btrfs_ioctl_search_args *args)
> +				 struct btrfs_ioctl_search_key *sk,
> +				 size_t buf_size,
> +				 char *buf
> +				 )

Minor style issue, don't put the ) on a separate line,
otherwise ok.
