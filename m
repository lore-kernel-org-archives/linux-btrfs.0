Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:44859 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbeABKCn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jan 2018 05:02:43 -0500
Received: by mail-lf0-f51.google.com with SMTP id g63so33118399lfl.11
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Jan 2018 02:02:43 -0800 (PST)
Message-ID: <5A4B58BF.1090804@gmail.com>
Date: Tue, 02 Jan 2018 11:02:39 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: swestrup@gmail.com, Kai Krakow <hurikhan77@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: A Big Thank You, and some Notes on Current Recovery Tools.
References: <CAJt7KB9UuW5Zg35VJ+fNV8RVZk_kAukmcgyK8GH4d1M286DkXA@mail.gmail.com> <c3d54bf6-20a8-0b98-baef-d2353b97849e@gmx.com> <1clphe-a7q.ln1@hurikhan77.spdns.de> <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com>
In-Reply-To: <CAJt7KB-sq0sxHe_3LSC5kzU0CG8ABk4baDnGP138vNaLK0KN-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/01/2018 08:44 PM, Stirling Westrup wrote:
> On Mon, Jan 1, 2018 at 7:15 AM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> Am Mon, 01 Jan 2018 18:13:10 +0800 schrieb Qu Wenruo:
>>
>>> On 2018年01月01日 08:48, Stirling Westrup wrote:
>>>>
>>>> 1) I had a 2T drive die with exactly 3 hard-sector errors and those 3
>>>> errors exactly coincided with the 3 super-blocks on the drive.
>>>
>>> WTF, why all these corruption all happens at btrfs super blocks?!
>>>
>>> What a coincident.
>>
>> Maybe it's a hybrid drive with flash? Or something that went wrong in the
>> drive-internal cache memory the very time when superblocks where updated?
>>
>> I bet that the sectors aren't really broken, just the on-disk checksum
>> didn't match the sector. I remember such things happening to me more than
>> once back in the days when drives where still connected by molex power
>> connectors. Those connectors started to get loose over time, due to
>> thermals or repeated disconnect and connect. That is, drives sometimes
>> started to no longer have a reliable power source which let to all sorts
>> of very strange problems, mostly resulting in pseudo-defective sectors.
>>
>> That said, the OP would like to check the power supply after this
>> coincidence... Maybe it's aging and no longer able to support all four
>> drives, CPU, GPU and stuff with stable power.
> 
> You may be right about the cause of the error being a power-supply issue.
> For those that are curious, the drive that failed was a Seagate Barracuda
> LP 2000G drive (ST2000DL003).
> 

Forgive me if it's not relevant, but I own quite a few disks from that
series, like:

root@iomega-ordo:~# hdparm -i /dev/sda
/dev/sda:
 Model=ST2000DM001-1CH164, FwRev=CC27, SerialNo=Z1E6EV85
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }

root@iomega-acm:~# smartctl -d sat -a /dev/sda
=== START OF INFORMATION SECTION ===
Device Model:     ST3000DM001-9YN166
Serial Number:    S1F0PGQJ
LU WWN Device Id: 5 000c50 0516fce00
Firmware Version: CC4B

root@iomega-europol:~# smartctl -d sat -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [armv5tel-linux-2.6.31.8] (local build)
=== START OF INFORMATION SECTION ===
Device Model:     ST3000DM001-9YN166
Serial Number:    Z1F1H5KA
LU WWN Device Id: 5 000c50 04ec18fda

Different locations, different environments, different boards one more
stable (the power) than others.

I replaced at least three four in the past 3 years. All of them died
because heavy random wirte workload. (rsnapshot, massive cp -al of
millions of files every day). In my case every time bad sectors occurred
too, but I didn't analyze where exactly, it was just a backup
destination drive. I pretty convinced it could be ext2 supers too though.


-- 
PGP Public Key (RSA/4096b):
ID: 0xF2C6EA10
SHA-1: 51DA 40EE 832A 0572 5AD8 B3C0 7AFF 69E1 F2C6 EA10
