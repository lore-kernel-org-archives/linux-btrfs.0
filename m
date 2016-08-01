Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19473 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbcHABa6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 21:30:58 -0400
Subject: Re: Btrfs send to send out metadata and data separately
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <07e7aea4-ebc7-1c47-34fb-daaae42ab245@gmx.com>
 <8930800.y3r4nzIv9U@libor-nb>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <140dea59-c35d-dac6-0686-229e7a1e70a2@cn.fujitsu.com>
Date: Mon, 1 Aug 2016 09:22:40 +0800
MIME-Version: 1.0
In-Reply-To: <8930800.y3r4nzIv9U@libor-nb>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 07/29/2016 09:14 PM, Libor Klepáč wrote:
> Hello,
>
> just a little question on receiver point 0), see bellow
>
> Dne pátek 29. července 2016 20:40:38 CEST, Qu Wenruo napsal(a):
>> Hi Filipe, and maintainers,
>>
>> Receive will do the following thing first before recovering the
>> subvolume/snapshot:
>>
>> 0) Create temporary dir for data extents
>>     Create a new dir with temporary name($data_extent), to put data
>> extents into it.
>
> These are the directories in format "o4095916-21925-0" on receiver side?

That's the temporary dir/file receive creates.

If using send-test(not complied anymore), you will see that that's how 
receive recover files/dirs:

1) mkfile/mkdir with temporary name
2) rename temporary file/dir to its final name

>
> I'm in middle of send/receive and i have over 300 thousand of them already.
> I was always told, that directory with lots of items suffers on performance
> (but i newer used btrfs before :), is that true?

Not completely true.

The fact is even worse, no matter dir or file, if there are too much 
inodes/extents in a *subvolume/snapshot*, it will be slowed down.

Unlike normal fs (ext*/xfs), btrfs put all dir/file info into one 
subvolume tree.

But that's to say, if you design the subvolume layout carefully, which 
means never put too many things into one subvolume, then it should not 
be a big problem though.

>
> Should it be little structured (subdirs based on extent number, for example) ?

Dir and file are sharing the same subvolume/dir tree, so subdir won't help.

But I can create a new subvolume for data extents, and reflink can work 
across subvolumes.
So that's won't cause a big problem though.

Thanks,
Qu

>
> Libor
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�n�߲)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
>


