From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Blocked for more than 120 seconds
Date: Fri, 02 Dec 2011 17:22:30 +0200
Message-ID: <4ED8ED36.3080105@gmail.com>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900> <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED8D6C8.4020609@robotech.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all

On 2/12/2011 3:46 =CE=BC=CE=BC, Tobias wrote:
> Hi Chris!
>
> Am 01.12.2011 19:41, schrieb Chris Mason:
>>
>> So, the transaction close is in btrfs_evict_inode, which sounds like=
 a
>> deadlock recently fixed by this commit:
>>
>> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git;a=3D=
commit;h=3Daa38a711a893accf5b5192f3d705a120deaa81e0=20
>>
>>
>> If you pull the for-linus branch from today, hopefully the problem w=
ill
>> be gone.
>>
>
> This looks very good. With this Kernel i still have some hangs, but=20
> only in rsync, only under high load and they don't lock up the system=
=20
> - so i guess it's ok now.
I still have hangs and lock ups under the same situation (rsync of many=
=20
files) under 3.2rc3. rc3 made the hang appear after 200gb of files,=20
while in rc2 i had hangs after only 11gb .
>
> Thank You very much for Your help!
>
> When will this patches go into the main Kernel?
>
> Tobias
>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
