Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaHKROM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 13:14:12 -0400
Message-ID: <53E8F9E0.3050907@redhat.com>
Date: Mon, 11 Aug 2014 10:14:08 -0700
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem documentation
References: <53E888C3.70807@jp.fujitsu.com> <53E8F7F0.3060300@redhat.com>
In-Reply-To: <53E8F7F0.3060300@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/11/14, 10:05 AM, Eric Sandeen wrote:
> On 8/11/14, 2:11 AM, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>>  - Simplify and unify the description of both man and usage.
>>  - Fix to show -m and -d is not exclusive
>>    with "<path>|<uuid>|<device>|<label>".
>>  - Add the description about short options for "--mounted" and
>>    "--all-devices", "-m" and "-d" respectively.
>>  - Move the descriptions of options to "Options" section.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>>  Documentation/btrfs-filesystem.txt | 22 ++++++++++++++--------
>>  cmds-filesystem.c                  | 15 ++++++++++-----
>>  2 files changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
>> index c9c0b00..fe68496 100644
>> --- a/Documentation/btrfs-filesystem.txt
>> +++ b/Documentation/btrfs-filesystem.txt
>> @@ -20,15 +20,21 @@ SUBCOMMAND
>>  *df* <path> [<path>...]::
>>  Show space usage information for a mount point.
>>  
>> -*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
>> -Show the btrfs filesystem with some additional info.
>> +*show* [-d|-m] [<path>|<uuid>|<device>|<label>]::
>> +Show the structure of btrfs filesystem(s).
>>  +
>> -If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
>> -information of all the btrfs filesystem both mounted and unmounted.
>> -If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
>> -filesystem(s);
>> -If '--all-devices' is passed, all the devices under /dev are scanned;
>> -otherwise the devices list is extracted from the /proc/partitions file.
> 
>> +If none of '<path>|<uuid>|<device>|<label>' is passed, btrfs shows
>> +information of all the btrfs filesystems both mounted and unmounted.
> 
> that doesn't seem quite correct; 
> 
> # btrfs filesystem show -m
> 
> does not specify '<path>|<uuid>|<device>|<label>' but it only shows
> mounted filesystems, not all filesystems.
> 
> As I understand it, the -d and -m options control how the command
> finds devices; the '<path>|<uuid>|<device>|<label>' argument is
> used as a filter for what is found.
> 
>> ++
>> +The show command finds btrfs filesystems by scanning all the devices
>> +in /proc/partitions by default.
> 
> I think I would document it something like this:
> 
> show [-m|-d] [<path>|<uuid>|<device>|<label>]
> 	Show the structure of btrfs filesystem(s).
> 
> 	By default, the show command scans all devices found in /proc/partitions.	
> 	If [-d|--all-devices] is specified, all devices found under /dev are scanned.
> 	If [-m|--mounted] is specified, only mounted (btrfs?) devices are scanned.
> 
> 	By default, the structure of all discovered filesystems is shown.
> 	If any one of [<path>|<uuid>|<device>|<label>] is specified, only filesystems
> 	matching that identifier are shown.
> 
> (What seems to be missing, though, is why would the user ever choose to use '-d?')

Incidentally, there is some strange behavior here when looking for multiple filesystems which match.

Make 2 filesystems w/ the same label:

[root@bp-05 tmp]# btrfs filesystem label /dev/sdc1 testlabel2
[root@bp-05 tmp]# btrfs filesystem label /dev/sdc5 testlabel2

Show matching filesytems:

[root@bp-05 tmp]# btrfs filesystem show testlabel2
Label: 'testlabel2'  uuid: 8c6ec835-5628-439b-9749-d92f62573ce8
	Total devices 1 FS bytes used 112.00KiB
	devid    1 size 30.00GiB used 2.04GiB path /dev/sdc5

Label: 'testlabel2'  uuid: a43cd507-02a2-46d2-a754-322cb7bdc346
	Total devices 1 FS bytes used 384.00KiB
	devid    1 size 30.00GiB used 2.04GiB path /dev/sdc1

Btrfs v3.14.2

That works fine, but if one is mounted:

[root@bp-05 tmp]# mount /dev/sdc1 /mnt/test

only the mounted filesystem is shown:

[root@bp-05 tmp]# btrfs filesystem show testlabel2
Label: 'testlabel2'  uuid: a43cd507-02a2-46d2-a754-322cb7bdc346
	Total devices 1 FS bytes used 384.00KiB
	devid    1 size 30.00GiB used 2.04GiB path /dev/sdc1

Btrfs v3.14.2

That's unexpected.

Mount the other fs, and both are shown again:

[root@bp-05 tmp]# mount /dev/sdc5 /mnt/scratch
[root@bp-05 tmp]# btrfs filesystem show testlabel2
Label: 'testlabel2'  uuid: a43cd507-02a2-46d2-a754-322cb7bdc346
	Total devices 1 FS bytes used 384.00KiB
	devid    1 size 30.00GiB used 2.04GiB path /dev/sdc1

Label: 'testlabel2'  uuid: 8c6ec835-5628-439b-9749-d92f62573ce8
	Total devices 1 FS bytes used 384.00KiB
	devid    1 size 30.00GiB used 2.04GiB path /dev/sdc5

Btrfs v3.14.2


-Eric
