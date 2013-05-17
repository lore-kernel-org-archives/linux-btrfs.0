Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:52009 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3EQLV2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 07:21:28 -0400
Received: by mail-we0-f170.google.com with SMTP id u54so3369040wes.15
        for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 04:21:27 -0700 (PDT)
Message-ID: <519612B1.7050601@gmail.com>
Date: Fri, 17 May 2013 13:21:21 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] a structure for the disks scan for btrfs
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 May 2013 18:54:38 +0800, Anand Jain wrote:
> The idea was to introduce /dev/mapper to find for btrfs disk, 
> However I found first we need to congregate the disk scan
> procedure at a function so it would help to consistently tune
> it across the btrfs-progs. As of now both fi show and
> dev scan use the disks scan they do it on their own.
> 
> So here it would congregate btrfs-disk scans at the function
> scan_devs_for_btrfs, adds /dev/mapper to be used to scan
> for btrfs, and updates its calling functions and few bug fixes.

Just scan /dev/block/*.  That contains all block devices.


