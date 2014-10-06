Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35184 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbaJFTG0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Oct 2014 15:06:26 -0400
Date: Mon, 6 Oct 2014 15:06:18 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: btrfs send and kernel 3.17
To: David Arendt <admin@prnet.org>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412622378.31886.3@mail.thefacebook.com>
In-Reply-To: <5432E466.9070604@prnet.org>
References: <5432E466.9070604@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 6, 2014 at 2:50 PM, David Arendt <admin@prnet.org> wrote:
> Hi,
> 
> After upgrading to kernel 3.17 btrfs send has stopped working.
> 
> ERROR: send ioctl failed with -5: Input/output error
> 
> The following message is printed by kernel:
> 
> [75322.782197] BTRFS error (device sda2): did not find backref in
> send_root. inode=461, offset=0, disk_byte=1094713344 found 
> extent=1094713344
> 
> btrfs inspect-internal inode-resolve -v 461 /u00/root.snapshot 
> returns:
> 
> /var/log/emerge-fetch.log
> 
> After removing this file, the error moves on to another file.
> 
> btrfs scrub output:
> 
> scrub status for bc31b068-2c36-4ff2-ac5c-7ce55af5371d
>     scrub started at Mon Oct  6 19:49:25 2014 and finished after 1748
> seconds
>     total bytes scrubbed: 94.21GiB with 0 errors
> 
> Other then the btrfs send problem, the filesystem works normally.
> 
> Is this a bug in btrfs-send or is my filesystem corrupted and should 
> be
> restored from backup ?
> 
> Please tell me if I can do anything else to help debugging this issue.

Which kernel did you upgrade from?  I don't think we have changes in 
3.17 that should impact this.

Is merge-fetch.log just a simple append-only log file?

-chris



