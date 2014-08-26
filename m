Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40389 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbaHZW46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Aug 2014 18:56:58 -0400
Message-ID: <53FD10AC.8050906@oracle.com>
Date: Wed, 27 Aug 2014 06:56:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Eric Sandeen <sandeen@redhat.com>, dsterba@suse.cz,
        Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/3] btrfs-progs: remove full /dev scanning
References: <53F51F4D.2090203@redhat.com> <53F635B9.6050900@libero.it> <20140826105522.GN29981@twin.jikos.cz> <53FC9EFE.8050105@redhat.com> <53FC9F80.6070608@fb.com>
In-Reply-To: <53FC9F80.6070608@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26/08/2014 22:53, Chris Mason wrote:
> On 08/26/2014 10:51 AM, Eric Sandeen wrote:
>> On 8/26/14, 5:55 AM, David Sterba wrote:
>>> On Thu, Aug 21, 2014 at 08:08:57PM +0200, Goffredo Baroncelli wrote:
>>>> Of course I (we) don't care cdrom and/or floppy, but this raises
>>>> the question: are there other block devices which aren't showed in
>>>> proc/partitions ?
>>>
>>> cdrom appears as /dev/sr0, floppy is /dev/fd0 if the respective modules
>>> are loaded, no breakage here.
>>>
>>>> I am thinking to some less common hardware like
>>>> NON USB sd disk (I saw this kind of hardware, but now I don't have
>>>> it in my hands....).
>>>
>>> A block device whose driver calls register_blkdev should appear in
>>> proc/partitions, if not then I think it's a bug or a very non-standard
>>> interface.
>>>
>>> I don't know about any other cases where full /dev scan would reveal
>>> something that /proc/partitions not, so I guess it's safe to remove it.
>>
>> Yesterday, Chris did mention <something something mumble> about /dev/mapper/*
>>
>> [12:57]  <cmason> I got inconsistent results from /proc/partitions
>> [12:57]  <cmason> this was 3 years ago now
>> [12:58]  <cmason> it didn't find everything for dm devices, yeah
>> [12:58]  <cmason> especially dm multipath got really confused
>>
>> and I'll be honest, I didn't test with devicemapper devices, much
>> less dm multipath, so I suppose that's warranted prior to removal.
>>
>> I'll see what I can do.
>>
>> If there's a problem, I bet there's a solution that doesn't involve
>> scanning everything under /dev ...
>
> That's definitely the problem I hit, but it was years ago.  I'm willing
> to bet we're safe to keep /proc/partitions now.

  I was tempted to remove BTRFS_SCAN_PROC completely when I introduced
  BTRFS_SCAN_LBLKID, but then there was less clarity on this as it is
  now.

  The point I am trying to make is that we could remove BTRFS_SCAN_PROC
  all together and keep only the BTRFS_SCAN_LBLKID.
  (Which means we shall remove the -d option under btrfs filesystem
  show and btrfs device scan).

  We could remove scanning /proc/partition (the BTRFS_SCAN_PROC)
  because the libblkid (under scan method BTRFS_SCAN_LBLKID) would scan
  both udev and /proc/partition by default. (as in the libblkid
  man page). Further libblkid is end user configurable. end user can
  override the default configuration and can scan either of udev
  /dev/disk/by-* symlinks or /proc/partitions only.

  Further if still some device is not found then it would be a libblkid
  bug/enhancement, so we need to fix it under libblkid.

  The scan method BTRFS_SCAN_PROC is redundant.

Thanks, Anand


> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
