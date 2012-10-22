Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35372 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2JVRDp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 13:03:45 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1169385bkc.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 10:03:44 -0700 (PDT)
Message-ID: <50857C8F.9030401@gmail.com>
Date: Mon, 22 Oct 2012 19:04:15 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: device delete, error removing device
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
In-Reply-To: <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-22 18:42, Chris Murphy wrote:
> [root@f18v ~]# btrfs fi show
> failed to read /dev/sr0
> Label: none  uuid: 6e96a96e-3357-4f23-b064-0f0713366d45
> 	Total devices 5 FS bytes used 7.52GB
> 	devid    5 size 12.00GB used 4.17GB path /dev/sdf
> 	devid    4 size 12.00GB used 4.62GB path /dev/sde
> 	devid    3 size 3.00GB used 2.68GB path /dev/sdd
> 	devid    2 size 3.00GB used 2.68GB path /dev/sdc
> 	*** Some devices missing
> 
> However, I think that last line is a bug. When I


Which version of "btrfs" tool are you using ? There was a bug on this.
Try the latest.

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
