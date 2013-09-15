Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26784 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3IOEao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Sep 2013 00:30:44 -0400
Message-ID: <523537EB.5020604@oracle.com>
Date: Sun, 15 Sep 2013 12:30:35 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
References: <1379071943-27543-1-git-send-email-anand.jain@oracle.com> <1379071943-27543-3-git-send-email-anand.jain@oracle.com> <20130913172520.GP6810@twin.jikos.cz>
In-Reply-To: <20130913172520.GP6810@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> ---------------
>> btrfs fi show
>> Label: none  uuid: a2446ecf-68c5-4815-8b63-099d10fc373c mounted: /btrfs
>> 	Group profile: metadata: single  metadata: DUP  data: single
>
> I didn't notice that before, this does not bring much information
> without the numbers as 'fi df' does. Please drop the printf lines

  Thanks for the review.
  IMO group profile is useful info to have it at both the places.
  end user using this new btrfs fi show would surely notice that it
  will reduce other commands normally used following the current
  btrfs fi show command. (like mount and btrfs fi df). of course
  user should use fi df to know detailed info about the sizes.

-------
btrfs fi show
Label: none  uuid: 2c654c36-ba53-4cc8-9c95-f0bee667b9a6 mounted: /btrfs
	Group profile: Data+Metadata: single
	Total devices 2 FS bytes used 3.17MiB
	devid    1 size 1.98GiB used 12.00MiB path /dev/mapper/mpatha
	devid    2 size 2.00GiB used 416.00MiB path /dev/mapper/mpathb
-------

Thanks, Anand



