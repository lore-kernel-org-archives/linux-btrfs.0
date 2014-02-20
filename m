Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34465 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbaBTSdH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 13:33:07 -0500
Message-ID: <53064A42.7000703@fb.com>
Date: Thu, 20 Feb 2014 13:32:34 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: Re: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
References: <52FD1A72.5060307@libero.it> <20140220180857.GW16073@twin.jikos.cz>
In-Reply-To: <20140220180857.GW16073@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/20/2014 01:08 PM, David Sterba wrote:
> On Thu, Feb 13, 2014 at 08:18:10PM +0100, Goffredo Baroncelli
> wrote:
>> space (if the next chunk are allocated as SINGLE) or the minimum
>> one ( if the next chunks are allocated as DUP/RAID1/RAID10).
>> 
>> The other two commands show the chunks in the disks.
>> 
>> $ sudo btrfs filesystem disk-usage /mnt/btrfs1/ Data,Single:
>> Size:8.00MB, Used:0.00 /dev/vdb	    8.00MB
> 
> The information about per-device usage can be enhanced and there's 
> enough space to print that:
> 
> * allocated in chunks (the number above) * actually used (simiar to
> what 'btrfs fi show' prints as 'used')
> 
> I don't see a reason why it would not fit here, nor any other
> place where this can be obtained.
> 
> There is the cumulative number of 'Used' for all devices, but I'd
> like to see it per-device as well.
> 
>> or in tabular format
>> 
>> $ sudo ./btrfs filesystem disk-usage -t /mnt/btrfs1/ Data   Data
>> Metadata Metadata System System Single RAID6   Single   RAID5
>> Single RAID5   Unallocated
>> 
>> /dev/vdb 8.00MB  1.00GB   8.00MB   1.00GB 4.00MB  4.00MB
>> 97.98GB /dev/vdc      -  1.00GB        -   1.00GB      -  4.00MB
>> 98.00GB /dev/vdd      -  1.00GB        -   1.00GB      -  4.00MB
>> 98.00GB /dev/vde      -  1.00GB        -   1.00GB      -  4.00MB
>> 98.00GB ====== ======= ======== ======== ====== =======
>> =========== Total    8.00MB  2.00GB   8.00MB   3.00GB 4.00MB
>> 12.00MB    391.97GB Used       0.00 11.25MB     0.00  36.00KB
>> 0.00  4.00KB
>> 
>> These are the most complete output, where it is possible to know
>> which disk a chunk uses and the usage of every chunk.
> 
> Though not per-device, similar to the above, but the tabular output
> is limited compared to the sequential output. Not sure what to do
> here.
> 
>> Finally the last command shows which chunks a disk hosts:
>> 
>> $ sudo ./btrfs device disk-usage /mnt/btrfs1/ /dev/vdb
>> 100.00GB Data,Single:              8.00MB Data,RAID6:
>> 1.00GB Metadata,Single:          8.00MB Metadata,RAID5:
>> 1.00GB System,Single:            4.00MB System,RAID5:
>> 4.00MB Unallocated:             97.98GB
>> 
>> /dev/vdc	  100.00GB Data,RAID6:               1.00GB 
>> Metadata,RAID5:           1.00GB System,RAID5:
>> 4.00MB Unallocated:             98.00GB
>> 
>> /dev/vdd	  100.00GB Data,RAID6:               1.00GB 
>> Metadata,RAID5:           1.00GB System,RAID5:
>> 4.00MB Unallocated:             98.00GB
>> 
>> /dev/vde	  100.00GB Data,RAID6:               1.00GB 
>> Metadata,RAID5:           1.00GB System,RAID5:
>> 4.00MB Unallocated:             98.00GB
> 
>> More or less are the same information above, only grouped by
>> disk.
> 
> Ie. it's only a variant of the 'filesystem usage' where it is
> grouped by blockgroup type.
> 
> Why doesn't 'btrfs device usage' take a device instead of the
> whole filesystem? This seems counterintuitive. It should be
> possible to ask for a device by it or path.
> 
> Also, I'd like to see all useful information about the device:
> 
> * id, path, uuid, ... whatever * physical device size * size
> visible by the filesystem * space allocated in chunks * space
> actually used
> 
>> Unfortunately I don't have any information about the chunk usage
>> per disk basis.
> 
> And I'm missing it. Is it a fundamental problem or just not
> addressed in this patchset?
> 
>> Finally I have to point out that the command btrfs fi df previous
>> didn't require the root capability, now with my patches it is
>> required, because I need to know some info about the chunks so I
>> need to use the "BTRFS_IOC_TREE_SEARCH".
>> 
>> I think that there are the following possibilities: 1) accept
>> this regresssion 2) remove the command "btrfs fi df" and leave
>> only "btrfs fi disk-usage" and "btrfs dev disk-usage" 3) adding a
>> new ioctl which could be used without root capability. Of course 
>> this ioctl would return only a subset of the
>> BTRFS_IOC_TREE_SEARCH info
>> 
>> I think that the 3) would be the "long term" solution. I am not
>> happy about the 1), so as "short term solution" I think that we
>> should go with the 2). What do you think ?
> 
> No sorry, 1) is not acceptable. We can live with this limitation
> only during development so we're not blocked by some new ioctl
> development.
> 
> No for 2), 'fi df' is useful as and widely used in existing
> scripts.
> 
> Yes for 3), we may also export the information through the
> existing ioctls if possible (eg. IOC_FS_INFO).
> 

For _right now_ I'd say just not do the raid56 stuff if we don't
notice any raid56 chunks from the normal load_space_info, and then if
there are raid56 we try and run the tree search ioctl and notice if we
get back EPERM or whatever you get when you don't have permissions.
Then just spit out as much information that you can about the fs with
a little note at the bottom that available calculation isn't 100% and
you need to run as root if you want that info.

Then what we could do is add another flag type for the existing
SPACE_INFO ioctl to spit out the information you need about the
raid5/6 chunks and then just test for those flags and make the
adjustment necessary.  This way we avoid adding yet another ioctl and
stuff will still work nicely for old kernels that don't have the
updated ioctl.  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTBko8AAoJEANb+wAKly3B8bgP+wU2yWBhtUWE9gFycBeW0gk7
gKexgV/8OV93FQbhQcPburhkzGixS1XMLbVYnJsYfwfRLKZl4l+M2mOJHyDu93M3
HGfSSuKoTJ8cQ8Fa2qdFIbZNFWSBeHpkOSmOl0NxyFLq/uXLaDP+ANRSE94K54d2
jdT9ncKdQcgiqRRaEIwgUkOUKdqRdRytm3BDr2otuvatWeKRtSVsSE7hG9uyxCBP
CxwE8SM7I4OByEqfrm7MJ2beQiOJoYIAKfVRjC1h+rUMd6IhjkfQGL1CBBrkB732
JWsOupRPPZkGQLMpD1Cbxy7BebzagKwC7oTubaWr8NnTFTbRX1+URJJFkPSEKmNy
9iYK4P17/w30GIfHJ5G4oEr2dl+41iCCaOJM0G57/yTMn0ostfRtdv3gSXHDHGYr
o39sDymTIX+H8w5Jd+ItTFKiP2B8NE9o6k9ZvLCF5gS38SdisyOiMwUu85jiAjHA
7YcGP2+Z2s1OlYJLpNrASt/JoXMtzGnXr7IinuLxjyA9RbnQk6K0Vzoen8eF+mtU
Ge/2D5zDdILrdlPwf/gaffNglstH2MgkiY9uTeAxlN90i9zW2BylJW+WR3o3aDq+
ajZfIoerQkk16EUvXxOap+vbkBpOfaEkzfWOOj7JU8CdkMF4L2g0FUUSan9vDc5v
meYQ/s2qy0eKDeRTcj3m
=tF0W
-----END PGP SIGNATURE-----
