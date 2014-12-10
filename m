Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21250 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaLJHto (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 02:49:44 -0500
Message-ID: <5487FBAF.9090902@oracle.com>
Date: Wed, 10 Dec 2014 15:52:15 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Goffredo Baroncelli <kreijack@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> This patch allows btrfs to skip LVM snapshot during the device scan
> phase.

  Its better to generalize the problem and fix it. The fix here is very
  specific to LVM use case. This does not work in cases where device is
  cloned using dd (device is unmounted).

  As mentioned we need to depend on the device wwn as provided by the
  device target driver.

Thanks, Anand
