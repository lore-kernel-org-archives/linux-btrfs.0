Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48756 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbcAVD4B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 22:56:01 -0500
Subject: Re: "Some devices missing" only while not mounted
To: Konstantin Svist <fry.kun@gmail.com>, linux-btrfs@vger.kernel.org
References: <56A13176.2050502@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <56A1A84A.2020801@oracle.com>
Date: Fri, 22 Jan 2016 11:55:54 +0800
MIME-Version: 1.0
In-Reply-To: <56A13176.2050502@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 01/22/2016 03:28 AM, Konstantin Svist wrote:
> Hi,
>
> I have a btrfs raid10 with 4 drives on Fedora 23 x64.
> Currently, the array is mountable (non-degraded) and all the content
> appears accessible without any errors -- except that "btrfs dev ready"
> returns 1 and "btrfs fi show -d" says "*** Some devices missing".

  'btrfs fi show -d':

   Those were kind of anticipated !
     http://www.spinics.net/lists/linux-btrfs/msg31445.html

   end users:
    pls just ignore -d output. Instead use with no option, which then
    uses the kernel data for the mounted FS and userland data for the
    unmounted.


   'btrfs dev ready':
      - cannot be fixed without breaking the API rules.
      May be we would obsolete this cli to a sysfs interface or
      something else.
