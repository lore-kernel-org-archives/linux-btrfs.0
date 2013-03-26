Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:45855 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab3CZQTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 12:19:15 -0400
Message-ID: <5151CA87.3050801@profihost.ag>
Date: Tue, 26 Mar 2013 17:19:19 +0100
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <20130322204932.GE1955@localhost.localdomain> <514CC52B.1000201@profihost.ag> <20130325201426.GG1955@localhost.localdomain> <51515226.9010509@profihost.ag> <20130326125319.GH1955@localhost.localdomain> <51519ABB.4030207@profihost.ag> <20130326133053.GK1955@localhost.localdomain> <5151A75C.6080703@profihost.ag> <20130326144426.GL1955@localhost.localdomain> <5151B8AF.60900@profihost.ag> <20130326152553.GN1955@localhost.localdomain>
In-Reply-To: <20130326152553.GN1955@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI,


Am 26.03.2013 16:25, schrieb Josef Bacik:
> On Tue, Mar 26, 2013 at 09:03:11AM -0600, Stefan Priebe - Profihost AG wrote:
>> Hi,
>> Am 26.03.2013 15:44, schrieb Josef Bacik:
>>>>>> Am 26.03.2013 13:53, schrieb Josef Bacik:
>>>>>> no - it's just mounted with mount -o noatime
>>>>>>
>>>>>> :~# cat /proc/mounts | grep btrfs
>>>>>> /dev/mapper/raid54tb1 /mnt btrfs rw,noatime,space_cache 0 0
>>>>>>
>>>>>
>>>>> Ok I think I see what's going on.  Can you try this patch and see if it fixes
>>>>> it?  Thanks,
>>>>
>>>> It still does not fix the problem.
>>>>
>>>> The rsync output looks like this so it does not work for file a but then
>>>> continues on c d e, ...
>>>>
>>>> sync -av --progress /backup/ /mnt/
>>>> sending incremental file list
>>>> .etc_openvpn/ipp.txt
>>>>           229 100%    3.99kB/s    0:00:00 (xfer#2, to-check=1009/1196)
>>>> .etc_openvpn/openvpn-status.log
>>>>           360 100%    6.28kB/s    0:00:00 (xfer#3, to-check=1007/1196)
>>>> rsync: rename "/mnt/.etc_openvpn/.ipp.txt.t9lucX" ->
>>>> ".etc_openvpn/ipp.txt": No space left on device (28)
>>>> .log/
>>>> .log/UcliEvt.log
>>>>        104188 100%  147.67kB/s    0:00:00 (xfer#4, to-check=1131/2700)
>>>> .log/auth.log
>>>>      15211522 100%    2.97MB/s    0:00:04 (xfer#5, to-check=1105/2700)
>>>> .log/auth.log.1
>>>>      19431424  61%    7.35MB/s    0:00:01
>>>>
>>>> the dmesg output looks like this:
>>>> [  551.321576] returning enospc, space_info 3, size 0 reserved 0, flush
>>>> 2, flush_state 7  dumping space info
>>>> [  551.323694] space_info 4 has 6439526400 free, is full
>>>> [  551.323696] space_info total=25748307968, used=19308666880, pinned=0,
>>>> reserved=49152, may_use=6438453248, readonly=65536
>>>>
>>>
>>> Ok so then this is probably it, let me know if it helps.  Thanks,
>>
>> OK it now has copied a lot of files (170) without an error all were very
>> small.
>>
>
> Welp progress is good.  Throw this into the mix and go again, it's just adding
> some more debugging so I can make sure I'm going down the right rabbit hole.
> Thanks,

Output is now:
[ 9587.445642] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[ 9587.527392] dumping block rsv 2, size 0 reserved 0
[ 9587.567871] dumping block rsv 5, size 196608 reserved 196608
[ 9587.607661] dumping block rsv 1, size 6438256640 reserved 6438256640
[ 9587.646958] space_info 4 has 6439428096 free, is full
[ 9587.646963] space_info total=25748307968, used=19308769280, pinned=0, 
reserved=45056, may_use=6438453248, readonly=65536
[ 9587.649410] returning enospc, space_info 3, size 0 reserved 0, flush 
2, flush_state 7  dumping space info
[ 9587.727000] dumping block rsv 2, size 0 reserved 0
[ 9587.765284] dumping block rsv 5, size 98304 reserved 98304
[ 9587.802849] dumping block rsv 1, size 6438256640 reserved 6438256640
[ 9587.839935] space_info 4 has 6439428096 free, is full
[ 9587.839936] space_info total=25748307968, used=19308769280, pinned=0, 
reserved=45056, may_use=6438354944, readonly=65536

Stefan
