Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43387 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3CZMz1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 08:55:27 -0400
Message-ID: <51519ABB.4030207@profihost.ag>
Date: Tue, 26 Mar 2013 13:55:23 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
References: <5F36F35C-39BE-4244-B8FB-A80EC2B06D48@profihost.ag> <514C4A8C.90607@profihost.ag> <20130322135322.GB1955@localhost.localdomain> <514C6319.7030400@profihost.ag> <20130322155453.GD1955@localhost.localdomain> <514CAC8D.7010409@profihost.ag> <20130322204932.GE1955@localhost.localdomain> <514CC52B.1000201@profihost.ag> <20130325201426.GG1955@localhost.localdomain> <51515226.9010509@profihost.ag> <20130326125319.GH1955@localhost.localdomain>
In-Reply-To: <20130326125319.GH1955@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Am 26.03.2013 13:53, schrieb Josef Bacik:
> On Tue, Mar 26, 2013 at 01:45:42AM -0600, Stefan Priebe wrote:
>> Hi,
>>
>> output here:
>> [  590.546162] returning enospc, space_info 3, size 0 reserved 0, flush 
>> 2, flush_state 7  dumping space info
>> [  590.548280] space_info 4 has 6439292928 free, is full
>> [  590.548283] space_info total=25748307968, used=19308916736, pinned=0, 
>> reserved=32768, may_use=6438354944, readonly=65536
>> [  590.550147] returning enospc, space_info 3, size 0 reserved 0, flush 
>> 2, flush_state 7  dumping space info
>> [  590.552264] space_info 4 has 6439284736 free, is full
>> [  590.552267] space_info total=25748307968, used=19308916736, pinned=0, 
>> reserved=40960, may_use=6438354944, readonly=65536
>> [  590.554141] returning enospc, space_info 3, size 0 reserved 0, flush 
>> 2, flush_state 7  dumping space info
>> [  590.556258] space_info 4 has 6439284736 free, is full
>> [  590.556261] space_info total=25748307968, used=19308916736, pinned=0, 
>> reserved=40960, may_use=6438354944, readonly=65536
>> [  591.145255] returning enospc, space_info 3, size 0 reserved 0, flush 
>> 2, flush_state 7  dumping space info
>> [  591.147373] space_info 4 has 6439235584 free, is full
>> [  591.147375] space_info total=25748307968, used=19308916736, pinned=0, 
>> reserved=90112, may_use=6438354944, readonly=65536
>> [  595.560257] returning enospc, space_info 3, size 0 reserved 0, flush 
>> 2, flush_state 7  dumping space info
>> [  595.562390] space_info 4 has 6439120896 free, is full
>> [  595.562393] space_info total=25748307968, used=19309047808, pinned=0, 
>> reserved=73728, may_use=6438297600, readonly=65536
>>
> 
> Weird, we have all the flushing stuff set and yet there is still a whole lot of
> outstanding reservations.  Do you have compression enabled?  Thanks,

no - it's just mounted with mount -o noatime

:~# cat /proc/mounts | grep btrfs
/dev/mapper/raid54tb1 /mnt btrfs rw,noatime,space_cache 0 0

Greets,
Stefan
