Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46552 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3HLCz7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Aug 2013 22:55:59 -0400
Message-ID: <52085025.7010504@oracle.com>
Date: Mon, 12 Aug 2013 11:01:57 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Error relating to /dev/sr0 when calling btrfs fi show /dev/sdxy
References: <20130810095922.206170@gmx.com> <44CB3A36-5FC9-4E57-9D38-D8945761EED4@colorremedies.com>
In-Reply-To: <44CB3A36-5FC9-4E57-9D38-D8945761EED4@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  This fixed it.

  http://permalink.gmane.org/gmane.comp.file-systems.btrfs/27129



>> % sudo btrfs fi show /dev/sda3
>> failed to open /dev/sr0: No medium found
