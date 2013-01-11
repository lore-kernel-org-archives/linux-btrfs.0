Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:58222 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AKXxx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jan 2013 18:53:53 -0500
Received: by mail-bk0-f47.google.com with SMTP id j4so1198389bkw.20
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Jan 2013 15:53:52 -0800 (PST)
Message-ID: <50F0A60D.10001@gmail.com>
Date: Sat, 12 Jan 2013 00:53:49 +0100
From: =?ISO-8859-1?Q?Joshua_Sch=FCler?= <joshua.schueler@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: how to resize (grow) device partition of a multi-device BTRFS
 filesystem?
References: <7D0754FFADBD2D4785C1D233C497C47B1BCD8121@SJEXCHMB06.corp.ad.broadcom.com>
In-Reply-To: <7D0754FFADBD2D4785C1D233C497C47B1BCD8121@SJEXCHMB06.corp.ad.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.01.2013 00:39, Rick Liu wrote:
> Hi,
> 
> I'm running OpenSUSE12.2 on VMware ESXi5.
> I create /local using BTRFS file system with 3 devices (sdc, sdd, sde).
> These 3 devices are VMware's virtual disk (vmdk files).
> 
> Instead of adding another new virtual disk,
> ESXi allows to increase Virtual Disk size,
> so I increase the size for 3 devices (sdc, sdd, sde) from 300GB to 500GB for each.
> 
> In EXT4 file system,
> I can resize (grow) partition directly.
> How to do this on BTRFS partition?
> 
> 
> 
> Thanks,
> 
> Rick

Hi Rick,

use
btrfs fi resize <devid>:max
to make btrfs use all space of disk <devid>

Joshua
