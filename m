Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55530 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081Ab3DANvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 09:51:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E52979A0689
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 07:51:47 -0600 (MDT)
Date: Mon, 1 Apr 2013 09:51:43 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Kastorff <encryptio@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>, Roman Mamedov <rm@romanrm.ru>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
Message-ID: <20130401135143.GI1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
 <20130401043605.2eb250a7@natsu>
 <20130401141207.533886a2@natsu>
 <20130401133110.GH1876@localhost.localdomain>
 <CAOOVQYKDyFXJPKFR-b20cMR6dWOW9MMu2Buk5644ig_45qvDWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOOVQYKDyFXJPKFR-b20cMR6dWOW9MMu2Buk5644ig_45qvDWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 01, 2013 at 07:45:16AM -0600, Chris Kastorff wrote:
> I have a (larger, 7x2TB at RAID10) filesystem that was recently hit by
> this. Same story; filesystem works normally, balance start, works for
> a while, then fails with similar stack traces and remounts read-only,
> after a reboot does not mount at all with similar error messages and
> stack traces.
> 
> The FS is still in that state. I'll grab an image and mail a link
> privately. I don't need to do anything special for btrfs-image on a
> multi-device fs, right?
> 

Right it will grab stuff from whatever mirror it's on and put it in the image.
Make sure to use -w, if the extent tree is corrupt the -w will make sure it
actually grabs all of the file system.  Thanks,

Josef
