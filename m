Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49015 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3JWCI0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 22:08:26 -0400
Message-ID: <52672F90.8060804@oracle.com>
Date: Wed, 23 Oct 2013 10:08:16 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com> <1382421202-18494-2-git-send-email-anand.jain@oracle.com> <20131022143303.GU1032@twin.jikos.cz>
In-Reply-To: <20131022143303.GU1032@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 10/22/13 10:33 PM, David Sterba wrote:
> On Tue, Oct 22, 2013 at 01:53:22PM +0800, Anand Jain wrote:
>> @@ -386,7 +395,7 @@ static int btrfs_scan_kernel(void *search)
>>   static const char * const cmd_show_usage[] = {
>> -	"btrfs filesystem show [options] [<path>|<uuid>]",
>> +	"btrfs filesystem show [options|<path>|<uuid>]",
>
> Options should stay separate from the path/uuid, you're extending the
> syntax to accept a device:
>
> 	"btrfs filesystem show [options] [<path>|<uuid>|<device>]",
>
> I'm fixing it locally, let me know if this doesn't match what you've
> intended.

  I am confused, on how the options should be represented,
  but the internal design is as below.
  When either uuid/path/dev is provide the option
  -d/-m (which implies to read-disks or kernel) will not apply,
  since internally we would determine that based on whether the
  given disk/uuid is mounted/unmounted.
  so option -d/-m don't apply when last argument is provided.
  so the right commands are

  btrfs fi show <-- probe mount-points and then disks for unmounted btrfs
  btrfs fi show -d <-- probe all disks even they are mounted (for legacy 
purpose, as in the original design)
  btrfs fi show /dev/sda <-- use mount point if disk is mounted OR disk 
path if unmounted
  btrfs fi show -m <-- show only mounted btrfs.


Thanks, Anand
