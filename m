Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25873 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbbDAHI0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 03:08:26 -0400
Message-ID: <551B98FF.8070000@oracle.com>
Date: Wed, 01 Apr 2015 15:06:39 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Martin <m_btrfs@ml1.co.uk>, linux-btrfs@vger.kernel.org
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
References: <mfcdep$d97$1@ger.gmane.org> <20150331173756.GF6821@twin.jikos.cz> <mfeo14$sib$1@ger.gmane.org>
In-Reply-To: <mfeo14$sib$1@ger.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>> btrfs device delete /dev/sdf5 /mnt/data2
>>>
>>> ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl for
>>> device

  very strange. 'btrfs fi show -m' shows btrfs fs(s) that are mounted.

- Anand
