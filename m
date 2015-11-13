Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:32576
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932453AbbKMCXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 21:23:30 -0500
From: Scotty Edmonds <scotty@scottyedmonds.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        Donald Pearson <donaldwhpearson@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS Error - Rockstor
Date: Fri, 13 Nov 2015 02:23:26 +0000
Message-ID: <SN2PR07MB013024CC746A3302C8FB614CF110@SN2PR07MB013.namprd07.prod.outlook.com>
References: <SN2PR07MB013A0D1DE3EC69CFAD9885ACF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97BwoMcqE978Fcdu3keN4UNtxqoBDPdbYb_T0C-wR-CBsg@mail.gmail.com>
 <SN2PR07MB013F045DB3B42E4AD8AA3D6CF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97Cv01-8z-oA_pGea9RHQ6d53w=FLbuvpadB=m_LtTPiXw@mail.gmail.com>
 <SN2PR07MB01362A586F4293204E66FCFCF120@SN2PR07MB013.namprd07.prod.outlook.com>
 <CAC=t97AUVQ_Jk1aSmhHodF-Db7NjaUvD1pfbFokx+q_bg3QtxA@mail.gmail.com>
 <20151112225701.GD24333@carfax.org.uk>
 <SN2PR07MB01305858FEC051F986D3546CF110@SN2PR07MB013.namprd07.prod.outlook.com>,<5645492B.9080808@cn.fujitsu.com>
In-Reply-To: <5645492B.9080808@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yes, no problem.  I had it powered off as I'm moving the system to a proper chassis and won't have it for another two weeks.

Thanks,

Scotty Edmonds
Scotty@ScottyEdmonds.com

________________________________________
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Sent: November-12-15 10:21 PM
To: Scotty Edmonds; Hugo Mills; Donald Pearson
Cc: Btrfs BTRFS
Subject: Re: BTRFS Error - Rockstor

Chunk root seems corrupted.
But that's not a really huge problem, tree root corruption happens, and
thanks to the full CoW of btrfs metadata, we will always be able to find
a old version one.

I'd like to do a full disk scan for any earlier version chunk root, but
I found that btrfs-find-root doesn't support search for chunk root.
(Hey, who is the bad ass wrote btrfs-find-root and made chunk root
search unsupported?! Oh, that's myself)

If you can wait, I'll add chunk root search support for you in recent
days, and then hopes we can find something helpful.

Thanks,
Qu

Scotty Edmonds wrote on 2015/11/13 01:46 +0000:
> Thanks for the help,  I got the same error on all variants.
>
> [root@rockstor ~]# btrfs check --readonly -s 0 /dev/sdh
> using SB copy 0, bytenr 65536
> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
> bytenr mismatch, want=12060305965056, have=13820656527619066643
> Couldn't read chunk tree
> Couldn't open file system
> [root@rockstor ~]#
>
>
> Thanks,
>
> Scotty Edmonds
> Scotty@ScottyEdmonds.com
>
> ________________________________________
> From: Hugo Mills <hugo@carfax.org.uk>
> Sent: November-12-15 6:57 PM
> To: Donald Pearson
> Cc: Scotty Edmonds; Btrfs BTRFS
> Subject: Re: BTRFS Error - Rockstor
>
>     On IRC earlier, I asked for the btrfs-debug-tree output of the
> broken tree block (1205030...etc). Since it's also failing, that would
> kind of indicate that this is pretty badly broken for some reason.
>
>     It doesn't quite feel like a broken disk to me, but I'm not sure
> what _has_ happened. Looks like something has stomped on a piece of
> metadata fairly high up in the data structures.
>
>     It probably won't show anything different, but could you do
>
> $ btrfs check --readonly -s $N /dev/$D
>
> for values of $N from 0 to 3, and for all the devices $D? I'm
> expecting to see the same errors (except for -s3, which is probably
> out of range), but if by any chance you get something different, that
> may give us a way into recovery.
>
>     Hugo.
>
> On Thu, Nov 12, 2015 at 04:41:58PM -0600, Donald Pearson wrote:
>> On Thu, Nov 12, 2015 at 4:24 PM, Scotty Edmonds
>> <scotty@scottyedmonds.com> wrote:
>>> Not exactly sure what to look for in dmesg..   If it is a disk fail shouldn't I just be able to remove the disk as it's RAID5?
>>>
>>
>> Yes theoretically.
>>
>>
>>> [   20.323997] BTRFS: device label seagate3x2tb devid 2 transid 2315 /dev/sdc
>>> [   20.324387] BTRFS: device label seagate3x2tb devid 1 transid 2315 /dev/sda
>>> [   20.324601] BTRFS: device label seagate3x2tb devid 3 transid 2315 /dev/sdd
>>> [   20.324698] BTRFS: device label mainNAS devid 1 transid 25209 /dev/sdg
>>> [   20.324794] BTRFS: device label mainNAS devid 2 transid 25209 /dev/sdf
>>> [   20.324938] BTRFS: device label mainNAS devid 5 transid 25209 /dev/sde
>>> [   20.325124] BTRFS: device label mainNAS devid 4 transid 25209 /dev/sdb
>>> [   20.325256] BTRFS: device label mainNAS devid 3 transid 25209 /dev/sdh
>>> [  105.285746] BTRFS info (device sdh): disk space caching is enabled
>>> [  105.285753] BTRFS: has skinny extents
>>> [  105.756545] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  105.758877] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  105.759154] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  105.759340] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  105.759417] BTRFS: failed to read chunk tree on sdh
>>> [  105.774774] BTRFS: open_ctree failed
>>> [  127.736060] BTRFS info (device sdd): disk space caching is enabled
>>> [  127.736066] BTRFS: has skinny extents
>>> [  141.887422] BTRFS info (device sdh): disk space caching is enabled
>>> [  141.887428] BTRFS: has skinny extents
>>> [  141.899666] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  141.902385] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  141.902639] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  141.902795] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [  141.902870] BTRFS: failed to read chunk tree on sdh
>>> [  141.915337] BTRFS: open_ctree failed
>>> [17748.031552] BTRFS info (device sdh): disk space caching is enabled
>>> [17748.031559] BTRFS: has skinny extents
>>> [17748.072339] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17748.077023] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17748.077350] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17748.077511] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17748.077587] BTRFS: failed to read chunk tree on sdh
>>> [17748.088908] BTRFS: open_ctree failed
>>> [17800.758291] BTRFS info (device sdh): disk space caching is enabled
>>> [17800.758298] BTRFS: has skinny extents
>>> [17800.765770] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17800.768816] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17800.769054] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17800.769192] BTRFS (device sdh): bad tree block start 13820666663704185619 12060305965056
>>> [17800.769264] BTRFS: failed to read chunk tree on sdh
>>> [17800.784937] BTRFS: open_ctree failed
>>> [root@rockstor ~]#
>>>
>>> and then I get this:
>>>
>>> [root@rockstor ~]# btrfs-debug-tree -b 12060305965056 /dev/sdh
>>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>>> bytenr mismatch, want=12060305965056, have=13820656527619066643
>>> Couldn't read chunk tree
>>> unable to open /dev/sdh
>>> [root@rockstor ~]#
>>>
>>> Thanks,
>>>
>>> Scotty Edmonds
>>> Scotty@ScottyEdmonds.com
>>
>> I think we need to see what some of the more experienced users think
>> on this one.  But you can try removing sdh and seeing if you can mount
>> it *read only* and degraded.  Just make sure whatever you do and play
>> with is done read only.  Don't try any fixes or repairs with the tools
>> unless told to do so by someone who really knows what they're talking
>> about.
>>
>>>
>>> ________________________________________
>>> From: Donald Pearson <donaldwhpearson@gmail.com>
>>> Sent: November-12-15 6:19 PM
>>> To: Scotty Edmonds; Btrfs BTRFS
>>> Subject: Re: BTRFS Error - Rockstor
>>>
>>> Anything interesting in dmesg?
>>>
>>> That looks similar to the kind of problems I had when I had a disk fail.
>>>
>>> On Thu, Nov 12, 2015 at 4:08 PM, Scotty Edmonds
>>> <scotty@scottyedmonds.com> wrote:
>>>> I get this:
>>>>
>>>> [root@rockstor ~]# btrfs check /dev/sdd
>>>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>>>> checksum verify failed on 12060305965056 found 779CCA23 wanted A746C37A
>>>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>>>> checksum verify failed on 12060305965056 found 1727A198 wanted 231E1577
>>>> bytenr mismatch, want=12060305965056, have=13820656527619066643
>>>> Couldn't read chunk tree
>>>> Couldn't open file system
>>>> [root@rockstor ~]#
>>>>
>>>> Thanks,
>>>>
>>>> Scotty Edmonds
>>>> Scotty@ScottyEdmonds.com
>>>>
>>>> ________________________________________
>>>> From: Donald Pearson <donaldwhpearson@gmail.com>
>>>> Sent: November-12-15 2:55 PM
>>>> To: Scotty Edmonds
>>>> Cc: linux-btrfs@vger.kernel.org
>>>> Subject: Re: BTRFS Error - Rockstor
>>>>
>>>> What does btrfs check without any repair options report?
>>>>
>>>> btrfs check /dev/sdd
>>>>
>>>> On Thu, Nov 12, 2015 at 12:48 PM, Scotty Edmonds
>>>> <scotty@scottyedmonds.com> wrote:
>>>>> Rockstor was running great, I ordered a SuperMicro 24-bay Chassis and decided to power down the machine while I was away.  When I turned it back on I got "Failed to read chunk tree" & "open_ctree failed" error (http://i.imgur.com/rGk9M57l.jpg)
>>>>>
>>>>> I spoke with support at Rockstor and they recommended I seek help via the mailing list.  Here are some details and commands I've run.  The specific array is in RAID5 and the label is mainNAS, seagate3x2tb is running perfectly.
>>>>>
>>>>> [root@rockstor ~]# btrfs device scan
>>>>> Scanning for Btrfs filesystems
>>>>> [root@rockstor ~]#
>>>>>
>>>>>
>>>>>
>>>>> [root@rockstor ~]# /usr/bin/lsblk -P -o NAME,MODEL,SERIAL,SIZE,TRAN,VENDOR,HCTL,TYPE,FSTYPE,LABEL,UUID
>>>>> NAME="sda" MODEL="WDC WD30EFRX-68E" SERIAL="WD-WCC4N4KVC39Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:0:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>>>> NAME="sdb" MODEL="WDC WD30EZRX-00M" SERIAL="WD-WCAWZ2551761" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:1:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>>>> NAME="sdc" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J590GY" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:2:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>>>> NAME="sdd" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J5WA1Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:3:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>>>> NAME="sde" MODEL="ST3000DM001-1CH1" SERIAL="Z1F517PH" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:4:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
>>>>> NAME="sdf" MODEL="ST2000DL003-9VT1" SERIAL="5YD1WK0V" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:5:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>>>> NAME="sdg" MODEL="ST2000DL003-9VT1" SERIAL="5YD2EBDA" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:6:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>>>> NAME="sdh" MODEL="ST2000DL003-9VT1" SERIAL="5YD2L28Z" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:7:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
>>>>> NAME="sdi" MODEL="INTEL SSDSA2CW08" SERIAL="CVPR1330019Y080BGN" SIZE="74.5G" TRAN="sata" VENDOR="ATA     " HCTL="1:0:0:0" TYPE="disk" FSTYPE="" LABEL="" UUID=""
>>>>> NAME="sdi1" MODEL="" SERIAL="" SIZE="500M" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="ext4" LABEL="" UUID="53aabf2f-5e28-4a18-922f-b0767a77a8ec"
>>>>> NAME="sdi2" MODEL="" SERIAL="" SIZE="7.3G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="swap" LABEL="" UUID="bf9e72c7-7d72-4a33-a5eb-0a0013033234"
>>>>> NAME="sdi3" MODEL="" SERIAL="" SIZE="66.8G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="btrfs" LABEL="rockstor_rockstor" UUID="3533171e-d95b-4491-aa4c-cc956536a1c3"
>>>>> [root@rockstor ~]#
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> [root@rockstor ~]# btrfs fi show
>>>>> Label: 'rockstor_rockstor'  uuid: 3533171e-d95b-4491-aa4c-cc956536a1c3
>>>>>          Total devices 1 FS bytes used 2.17GiB
>>>>>          devid    1 size 66.79GiB used 7.02GiB path /dev/sdi3
>>>>>
>>>>> Label: 'seagate3x2tb'  uuid: 6ef19043-2d83-4ff1-b959-b9f3c425cc69
>>>>>          Total devices 3 FS bytes used 1.13TiB
>>>>>          devid    1 size 1.82TiB used 595.03GiB path /dev/sdh
>>>>>          devid    2 size 1.82TiB used 595.01GiB path /dev/sdf
>>>>>          devid    3 size 1.82TiB used 595.01GiB path /dev/sdg
>>>>>
>>>>> Label: 'mainNAS'  uuid: e8c92d93-fac3-4f83-b3aa-31cb92caafd9
>>>>>          Total devices 5 FS bytes used 5.43TiB
>>>>>          devid    1 size 2.73TiB used 1.36TiB path /dev/sdd
>>>>>          devid    2 size 2.73TiB used 1.36TiB path /dev/sdc
>>>>>          devid    3 size 2.73TiB used 1.36TiB path /dev/sda
>>>>>          devid    4 size 2.73TiB used 1.36TiB path /dev/sde
>>>>>          devid    5 size 2.73TiB used 1.36TiB path /dev/sdb
>>>>>
>>>>>
>>>>> btrfs-progs v4.2.1
>>>>>
>>>>> I'm unable to mount any of the drives that are in the mainNAS array, this is the error when I try to mount all of the drives degraded.
>>>>>
>>>>> [root@rockstor ~]# mount -v -o degraded /dev/sdd /mnt2/mainNAS
>>>>> mount: wrong fs type, bad option, bad superblock on /dev/sdd,
>>>>>         missing codepage or helper program, or other error
>>>>>         In some cases useful info is found in syslog - try
>>>>>         dmesg | tail or so.
>>>>> [root@rockstor ~]#
>>>>>
>>>>> I haven't given up hope yet as the "btrfs fi show" gives me all the correct data and I ran chunk-recover and superblocks all report back as good.
>>>>>
>>>>>
>>>>> Thanks for your help, let me know if you need any further information.
>>>>>
>>>>>   Thanks,
>>>>>
>>>>>   Scotty Edmonds
>>>>>   Scotty@ScottyEdmonds.com
>
> --
> Hugo Mills             | "How deep will this sub go?"
> hugo@... carfax.org.uk | "Oh, she'll go all the way to the bottom if we don't
> http://carfax.org.uk/  | stop her."
> PGP: E2AB1DE4          |                                                  U571
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
