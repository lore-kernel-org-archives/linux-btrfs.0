Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:40676 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960AbaK1HNC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 02:13:02 -0500
Message-ID: <54782078.1010700@pobox.com>
Date: Thu, 27 Nov 2014 23:12:56 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu> <54765FC2.2050309@pobox.com> <pan$38a8e$6ec3447a$892ad9ec$128580b7@cox.net>
In-Reply-To: <pan$38a8e$6ec3447a$892ad9ec$128580b7@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/2014 01:27 AM, Duncan wrote:
> Robert White posted on Wed, 26 Nov 2014 15:18:26 -0800 as excerpted:
>
>> I also don't see anything in the code that says "this ioctl will create
>> the checksums for the selected file" so you may have to do the copy you
>> tried to avoid.
> Note that btrfs check has an --init-csum-tree switch.

I thought about that, but I doubt it's going to go through all the 
inodes and clear the NODATASUM bit from the inode flags where it's been 
set by something such as the conversion using -d or setting the 
NODATACOW flag (e.g. the +C attribute).

So while that will, hopefully, recalculate the checksums on the regular 
files I don't think it would have fixed his problem since those files 
weren't "regular" at that point.

