Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34670 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbD0Eub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 00:50:31 -0400
Message-ID: <553DBF87.2080205@oracle.com>
Date: Mon, 27 Apr 2015 12:48:07 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wolfgang Mader <Wolfgang_Mader@brain-frog.de>, linux-btrfs@vger.kernel.org
Subject: Re: How to get the devid of a missing device
References: <1704142.6uN5bYeLWo@discus>
In-Reply-To: <1704142.6uN5bYeLWo@discus>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/27/2015 02:39 AM, Wolfgang Mader wrote:
> Hello,
>
> I have a raid10 with one device missing. I would like to use btrfs replace to
> replace it. However, I am unsure on how to obtain the devid of the missing
> device. Having the filesystem mounted in degraded mode under mnt, btrfs fs

  At the user end there is no way. unless you want to use gdb and dump
  the fs_uuids and check.

  Submitted these patches as of now to obtain from the logs. Will
  help in the situation when device is missing at the time of mount.

Btrfs: check error before reporting missing device and add uuid
Btrfs: log when missing device is created

  For long term we have sysfs interface, patches are in the ML if you
  want to tests.

Good luck.

Anand


