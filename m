Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35204 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbbKLWmS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 17:42:18 -0500
Received: by obbnk6 with SMTP id nk6so59747313obb.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 14:42:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <SN2PR07MB01362A586F4293204E66FCFCF120@SN2PR07MB013.namprd07.prod.outlook.com>
References: <SN2PR07MB013A0D1DE3EC69CFAD9885ACF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97BwoMcqE978Fcdu3keN4UNtxqoBDPdbYb_T0C-wR-CBsg@mail.gmail.com>
 <SN2PR07MB013F045DB3B42E4AD8AA3D6CF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97Cv01-8z-oA_pGea9RHQ6d53w=FLbuvpadB=m_LtTPiXw@mail.gmail.com> <SN2PR07MB01362A586F4293204E66FCFCF120@SN2PR07MB013.namprd07.prod.outlook.com>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Thu, 12 Nov 2015 16:41:58 -0600
Message-ID: <CAC=t97AUVQ_Jk1aSmhHodF-Db7NjaUvD1pfbFokx+q_bg3QtxA@mail.gmail.com>
Subject: Re: BTRFS Error - Rockstor
To: Scotty Edmonds <scotty@scottyedmonds.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 12, 2015 at 4:24 PM, Scotty Edmonds
<scotty@scottyedmonds.com> wrote:
> Not exactly sure what to look for in dmesg..   If it is a disk fail shouldn't I just be able to remove the disk as it's RAID5?
>

Yes theoretically.


> [   20.323997] BTRFS: device label seagate3x2tb devid 2 transid 2315 /dev/sdc
> [   20.324387] BTRFS: device label seagate3x2tb devid 1 transid 2315 /dev/sda
> [   20.324601] BTRFS: device label seagate3x2tb devid 3 transid 2315 /dev/sdd
> [   20.324698] BTRFS: device label mainNAS devid 1 transid 25209 /dev/sdg
> [   20.324794] BTRFS: device label mainNAS devid 2 transid 25209 /dev/sdf
> [   20.324938] BTRFS: device label mainNAS devid 5 transid 25209 /dev/sde
> [   20.325124] BTRFS: device label mainNAS devid 4 transid 25209 /dev/sdb
> [   20.325256] BTRFS: device label mainNAS devid 3 transid 25209 /dev/sdh
> [  105.285746] BTRFS info (device sdh): disk space caching is enabled
> [  105.285753] BTRFS: has skinny extents
> [  105.756545] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  105.758877] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  105.759154] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  105.759340] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  105.759417] BTRFS: failed to read chunk tree on sdh
> [  105.774774] BTRFS: open_ctree failed
> [  127.736060] BTRFS info (device sdd): disk space caching is enabled
> [  127.736066] BTRFS: has skinny extents
> [  141.887422] BTRFS info (device sdh): disk space caching is enabled
> [  141.887428] BTRFS: has skinny extents
> [  141.899666] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  141.902385] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  141.902639] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  141.902795] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [  141.902870] BTRFS: failed to read chunk tree on sdh
> [  141.915337] BTRFS: open_ctree failed
> [17748.031552] BTRFS info (device sdh): disk space caching is enabled
> [17748.031559] BTRFS: has skinny extents
> [17748.072339] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17748.077023] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17748.077350] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17748.077511] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17748.077587] BTRFS: failed to read chunk tree on sdh
> [17748.088908] BTRFS: open_ctree failed
> [17800.758291] BTRFS info (device sdh): disk space caching is enabled
> [17800.758298] BTRFS: has skinny extents
> [17800.765770] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17800.768816] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17800.769054] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17800.769192] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
> [17800.769264] BTRFS: failed to read chunk tree on sdh
> [17800.784937] BTRFS: open_ctree failed
> [root@rockstor ~]#
>
> and then I get this:
>
> [root@rockstor ~]# btrfs-debug-tree -b 12060305965056 /dev/sdh
> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
> bytenr mismatch, want=12060305965056, have=13820656527619066643
> Couldn't read chunk tree
> unable to open /dev/sdh
> [root@rockstor ~]#
>
> Thanks,
>
> Scotty Edmonds
> Scotty@ScottyEdmonds.com

I think we need to see what some of the more experienced users think
on this one.  But you can try removing sdh and seeing if you can mount
it *read only* and degraded.  Just make sure whatever you do and play
with is done read only.  Don't try any fixes or repairs with the tools
unless told to do so by someone who really knows what they're talking
about.

>
> ________________________________________
> From: Donald Pearson <donaldwhpearson@gmail.com>
> Sent: November-12-15 6:19 PM
> To: Scotty Edmonds; Btrfs BTRFS
> Subject: Re: BTRFS Error - Rockstor
>
> Anything interesting in dmesg?
>
> That looks similar to the kind of problems I had when I had a disk fail.
>
> On Thu, Nov 12, 2015 at 4:08 PM, Scotty Edmonds
> <scotty@scottyedmonds.com> wrote:
>> I get this:
>>
>> [root@rockstor ~]# btrfs check /dev/sdd
>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>> bytenr mismatch, want=12060305965056, have=13820656527619066643
>> Couldn't read chunk tree
>> Couldn't open file system
>> [root@rockstor ~]#
>>
>> Thanks,
>>
>> Scotty Edmonds
>> Scotty@ScottyEdmonds.com
>>
>> ________________________________________
>> From: Donald Pearson <donaldwhpearson@gmail.com>
>> Sent: November-12-15 2:55 PM
>> To: Scotty Edmonds
>> Cc: linux-btrfs@vger.kernel.org
>> Subject: Re: BTRFS Error - Rockstor
>>
>> What does btrfs check without any repair options report?
>>
>> btrfs check /dev/sdd
>>
>> On Thu, Nov 12, 2015 at 12:48 PM, Scotty Edmonds
>> <scotty@scottyedmonds.com> wrote:
>>> Rockstor was running great, I ordered a SuperMicro 24-bay Chassis and decided to power down the machine while I was away.  When I turned it back on I got "Failed to read chunk tree" & "open_ctree failed" error (http://i.imgur.com/rGk9M57l.jpg)
>>>
>>> I spoke with support at Rockstor and they recommended I seek help via the mailing list.  Here are some details and commands I've run.  The specific array is in RAID5 and the label is mainNAS, seagate3x2tb is running perfectly.
>>>
>>> [root@rockstor ~]# btrfs device scan
>>> Scanning for Btrfs filesystems
>>> [root@rockstor ~]#
>>>
>>>
>>>
>>> [root@rockstor ~]# /usr/bin/lsblk -P -o NAME,MODEL,SERIAL,SIZE,TRAN,VENDOR,HCTL,TYPE,FSTYPE,LABEL,UUID
>>> NAME="sda" MODEL="WDC WD30EFRX-68E" SERIAL="WD-WCC4N4KVC39Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:0:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>> NAME="sdb" MODEL="WDC WD30EZRX-00M" SERIAL="WD-WCAWZ2551761" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:1:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>> NAME="sdc" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J590GY" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:2:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>> NAME="sdd" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J5WA1Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:3:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>> NAME="sde" MODEL="ST3000DM001-1CH1" SERIAL="Z1F517PH" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:4:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>> NAME="sdf" MODEL="ST2000DL003-9VT1" SERIAL="5YD1WK0V" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:5:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>> NAME="sdg" MODEL="ST2000DL003-9VT1" SERIAL="5YD2EBDA" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:6:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>> NAME="sdh" MODEL="ST2000DL003-9VT1" SERIAL="5YD2L28Z" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:7:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>> NAME="sdi" MODEL="INTEL SSDSA2CW08" SERIAL="CVPR1330019Y080BGN" SIZE="74.5G" TRAN="sata" VENDOR="ATA     " HCTL="1:0:0:0" TYPE="disk" FSTYPE="" LABEL="" UUID=""
>>> NAME="sdi1" MODEL="" SERIAL="" SIZE="500M" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="ext4" LABEL="" UUID="53aabf2f-5e28-4a18-922f-b0767a77a8ec"
>>> NAME="sdi2" MODEL="" SERIAL="" SIZE="7.3G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="swap" LABEL="" UUID="bf9e72c7-7d72-4a33-a5eb-0a0013033234"
>>> NAME="sdi3" MODEL="" SERIAL="" SIZE="66.8G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="btrfs" LABEL="rockstor_rockstor" UUID="3533171e-d95b-4491-aa4c-cc956536a1c3"
>>> [root@rockstor ~]#
>>>
>>>
>>>
>>>
>>> [root@rockstor ~]# btrfs fi show
>>> Label: 'rockstor_rockstor'  uuid: 3533171e-d95b-4491-aa4c-cc956536a1c3
>>>         Total devices 1 FS bytes used 2.17GiB
>>>         devid    1 size 66.79GiB used 7.02GiB path /dev/sdi3
>>>
>>> Label: 'seagate3x2tb'  uuid: 6ef19043-2d83-4ff1-b959-b9f3c425cc69
>>>         Total devices 3 FS bytes used 1.13TiB
>>>         devid    1 size 1.82TiB used 595.03GiB path /dev/sdh
>>>         devid    2 size 1.82TiB used 595.01GiB path /dev/sdf
>>>         devid    3 size 1.82TiB used 595.01GiB path /dev/sdg
>>>
>>> Label: 'mainNAS'  uuid: e8c92d93-fac3-4f83-b3aa-31cb92caafd9
>>>         Total devices 5 FS bytes used 5.43TiB
>>>         devid    1 size 2.73TiB used 1.36TiB path /dev/sdd
>>>         devid    2 size 2.73TiB used 1.36TiB path /dev/sdc
>>>         devid    3 size 2.73TiB used 1.36TiB path /dev/sda
>>>         devid    4 size 2.73TiB used 1.36TiB path /dev/sde
>>>         devid    5 size 2.73TiB used 1.36TiB path /dev/sdb
>>>
>>>
>>> btrfs-progs v4.2.1
>>>
>>> I'm unable to mount any of the drives that are in the mainNAS array, this is the error when I try to mount all of the drives degraded.
>>>
>>> [root@rockstor ~]# mount -v -o degraded /dev/sdd /mnt2/mainNAS
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdd,
>>>        missing codepage or helper program, or other error
>>>        In some cases useful info is found in syslog - try
>>>        dmesg | tail or so.
>>> [root@rockstor ~]#
>>>
>>> I haven't given up hope yet as the "btrfs fi show" gives me all the correct data and I ran chunk-recover and superblocks all report back as good.
>>>
>>>
>>> Thanks for your help, let me know if you need any further information.
>>>
>>>  Thanks,
>>>
>>>  Scotty Edmonds
>>>  Scotty@ScottyEdmonds.com
>>>     --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
