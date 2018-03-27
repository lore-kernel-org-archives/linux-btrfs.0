Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34341 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751316AbeC0TTD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 15:19:03 -0400
Date: Tue, 27 Mar 2018 21:16:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/8] btrfs: return required error from
 btrfs_check_super_csum
Message-ID: <20180327191636.GE30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-3-anand.jain@oracle.com>
 <4203fb44-3fd4-1e26-bf03-40d640de09af@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4203fb44-3fd4-1e26-bf03-40d640de09af@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2018 at 11:05:53AM +0300, Nikolay Borisov wrote:
> > +	if (err) {
> > +		if (err == -EINVAL)
> > +			pr_err("BTRFS error (device %pg): "\
> > +				"unsupported checksum algorithm",
> > +				fs_devices->latest_bdev);
> 
> I don't think strings should be idented. I.e the correct thing here
> should be to have only fs_devices->latest_bdev on a new line, even if
> the string goes above the char limit of 80. In any case the \ is not
> needed due to gcc's support for string literal concatenation:
> 
> pr_err("BTRFS error (device %pg): "
>        "unsupported checksum algorithm",
>        fs_devices->latest_bdev)
> 
> should work equally well. But as I said I don't think this is even
> needed. Let's wait and see what David says.

The strings should not be split, because we want to be able to grep the
sources for the error messages. If the string does not fit 80 chars
per line, then it can be moved to the next line and un-indented to the
left. Plenty of examples.
