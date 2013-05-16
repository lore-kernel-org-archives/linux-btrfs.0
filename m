Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay0-omc1-s25.bay0.hotmail.com ([65.54.190.36]:19043 "EHLO
	bay0-omc1-s25.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959Ab3EPTLV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 15:11:21 -0400
Message-ID: <BAY172-DS3707AF83BC83C3B48502DB0A30@phx.gbl>
From: "Kyle Gates" <kylegates@hotmail.com>
To: <bo.li.liu@oracle.com>, <dsterba@suse.cz>
Cc: <linux-btrfs@vger.kernel.org>
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com> <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl> <20130510051500.GB5615@liubo.jp.oracle.com> <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl>
In-Reply-To: <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl>
Subject: Re: nocow 'C' flag ignored after balance
Date: Thu, 16 May 2013 14:11:41 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Fri, May 10, 2013 Liu Bo wrote:
>> On Thu, May 09, 2013 at 03:41:49PM -0500, Kyle Gates wrote:
>>> I'll preface that I'm running Ubuntu 13.04 with the standard 3.8
>>> series kernel so please disregard if this has been fixed in higher
>>> versions. This is on a btrfs RAID1 with 3 then 4 disks.
>>>
>>> My use case is to set the nocow 'C' flag on a directory and copy in
>>> some files, then make lots of writes (same file sizes) and note that
>>> the number of extents stays the same, good.
>>> Then run a balance (I added a disk) and start making writes again,
>>> now the number of extents starts climbing, boo.
>>> Is this standard behavior? I realize a balance will cow the files.
>>> Are they also being checksummed thereby breaking the nocow flag?
>>>
>>> I have made no snapshots and made no writes to said files while the
>>> balance was running.
>>
>> Hi Kyle,
>>
>> It's hard to say if it's standard, it is a side effect casued by balance.
>>
>> During balance, our reloc root works like a snapshot, so we set
>> last_snapshot on the fs root, and this makes new nocow writes think that
>> we have to do cow as the extent is created before taking snapshot.
>>
>> But the nocow 'C' flag on the file is still there, if you make new
>> writes on the new extent after balance, you still get the same number of
>> extents.
>>
>> thanks,
>> liubo
>
> Thank you for the explanation.
> On my machine this didn't happen however. IIRC one ~10GiB file had 24 
> extents before balance, 26 extents after balance, and 1000+ and growing 
> when I checked the following day.
> I'll add that I am running a relatively recent version of btrfs-tools from 
> a ppa.
and mounted with autodefrag
Am I actually just seeing large ranges getting split while remaining 
contiguous on disk? This would imply crc calculation on the two outside 
ranges. Or perhaps there is some data being inlined for each write. I 
believe writes on this file are 32KiB each.
Does the balance produce persistent crc values in the metadata even though 
the files are nocow which implies nocrc?
...
I ran this test again and here's filefrag -v after about a day of use:

Filesystem type is: 9123683e
File size of /blah/blah/file is 10213265920 (2493474 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0 675625629               9
   1       9 675621279 675625638     55
   2      64 674410131 675621334    886
   3     950 675558303 674411017      9
   4     959 675583473 675558312     55
   5    1014 674411081 675583528    708
   6    1722 675456318 674411789      9
   7    1731 675710934 675456327     55
   8    1786 674411853 675710989    521
   9    2307 675424433 674412374      9
  10    2316 675471062 675424442     55
  11    2371 674412438 675471117    984
  12    3355 676012018 674413422      9
  13    3364 676024295 676012027     55
  14    3419 674413486 676024350    871
  15    4290 675681138 674414357      9
  16    4299 675618500 675681147     55
...
13986 2486955 671627059 675876382    627
13987 2487582 675677542 671627686      9
13988 2487591 675700351 675677551     55
13989 2487646 671627750 675700406   1212
13990 2488858 675932037 671628962      9
13991 2488867 675990025 675932046     55
13992 2488922 671629026 675990080    220
13993 2489142 675674447 671629246      9
13994 2489151 675687864 675674456     55
13995 2489206 671629310 675687919   1821
13996 2491027 676209288 671631131      9
13997 2491036 676260767 676209297     55
13998 2491091 671631195 676260822    285
13999 2491376 675650278 671631480      9
14000 2491385 675678822 675650287     55
14001 2491440 671631544 675678877   1464
14002 2492904 675534255 671633008      9
14003 2492913 675503514 675534264     55
14004 2492968 671633072 675503569    506 eof
/blah/blah/file: 14005 extents found

As you can see the 32KiB writes fit in the extents of size 9 and 55. Are 
those 9 block extents inlined?
If I understand correctly, new extents are created for these nocow writes, 
then the old extents are basically hole punched producing three (four? 
because of inlining) separate extents.
Something here begs for optimization. Perhaps balance should treat nocow 
files a little differently. That would be the time to remove the extra bits 
that prevent inplace overwrites. After the fact it becomes much more 
difficult, although removing a crc for the extent being written seems a 
little easier then iterating over the entire file.

Thanks for taking the time to read,
Kyle

P.S. I'm CCing David as I believe he wrote the patch to get the 'C' flag 
working on empty files and directories. 

