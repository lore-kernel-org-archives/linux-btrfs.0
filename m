Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62043 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3A3SRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:17:30 -0500
Received: by mail-ie0-f174.google.com with SMTP id k10so1544676iea.19
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 10:17:28 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: corrupted file size on inline extent conversion?
From: Mike Lowe <j.michael.lowe@gmail.com>
In-Reply-To: <20130129145429.GD3660@localhost.localdomain>
Date: Wed, 30 Jan 2013 13:17:25 -0500
Cc: Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Message-Id: <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net> <20130129145429.GD3660@localhost.localdomain>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well I found this, so I think it's likely:

root@gwboss2:~# dmesg |grep bitten
[ 3196.193238] this would have bitten us in the ass
[ 3196.193784] this would have bitten us in the ass

On Jan 29, 2013, at 9:54 AM, Josef Bacik <jbacik@fusionio.com> wrote:

> On Mon, Jan 28, 2013 at 05:12:12PM -0700, Sage Weil wrote:
>> A ceph user observed a incorrect i_size on btrfs.  The pattern looks like 
>> this:
>> 
>> - some writes at low file offsets
>> - a write to 4185600 len 8704 (i_size should be 4MB)
>> - more writes to low offsets
>> - a write to 4181504 len 4096 (abutts the write above)
>> - a bit of time goes by...
>> - stat returns 4186112 (4MB - 8192)
>> - that's a fwe bytes to the right of the top write above.
>> 
>> There are some logs showing the full read/write activity to the file at
>> 
>> 	http://tracker.newdream.net/attachments/658/object_log.txt
>> 
>> on issue
>> 
>> 	http://tracker.newdream.net/issues/3810
>> 
>> The kernel was 3.7.0-030700-generic (and probably also observed on 3.7.1).
>> 
>> Is this a known bug?
> 
> Not known but I took a long hard look at our ordered i size updating and I think
> I spotted the bug.  Could you run this patch and see if you get the printk?  If
> you do then that was the problem and you should be good to go.  It definitely
> needs to be fixed, hopefully it's also your bug.  Thanks,
> 
> Josef
> 
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index cbd4838..dbd4905 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -895,8 +895,14 @@ int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
> 	 * if the disk i_size is already at the inode->i_size, or
> 	 * this ordered extent is inside the disk i_size, we're done
> 	 */
> -	if (disk_i_size == i_size || offset <= disk_i_size) {
> +	if (disk_i_size == i_size)
> 		goto out;
> +
> +	if (offset <= disk_i_size) {
> +		if (ordered && ordered->outstanding_isize > disk_i_size)
> +			printk(KERN_ERR "this would have bitten us in the ass\n");
> +		else
> +			goto out;
> 	}
> 
> 	/*

