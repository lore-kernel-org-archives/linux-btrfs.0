From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Blocked for more than 120 seconds
Date: Sat, 03 Dec 2011 02:35:50 +0200
Message-ID: <4ED96EE6.2010308@gmail.com>
References: <4ED34359.6010305@robotech.de> <1322472549.1962.2.camel@Nokia-N900> <4ED5FAEF.8070400@robotech.de> <20111130141006.GY24338@shiny> <4ED738E5.3080200@robotech.de> <20111201184158.GB10535@shiny> <4ED8D6C8.4020609@robotech.de> <4ED8ED36.3080105@gmail.com> <4ED8F34F.8090609@robotech.de> <4ED92CA6.3030302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Tobias <tracer@robotech.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED92CA6.3030302@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

After about 1TB of rsyncs from multiple servers at the same time, plus=20
some heavy filesystem loading, i believe that 3.2rc4 solves the problem=
=20
for me. Now if only we had deduplication and an fsck tool :)
On =CE=A0=CE=B1=CF=81=CE=B1=CF=83=CE=BA=CE=B5=CF=85=CE=AE, 2 =CE=94=CE=B5=
=CE=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 9:53:10 =CE=BC=CE=
=BC, Konstantinos Skarlatos=20
wrote:
> I see they got into 3.2rc4, so I am now compiling it. I will report=20
> back in a few hours
>
> On =CE=A0=CE=B1=CF=81=CE=B1=CF=83=CE=BA=CE=B5=CF=85=CE=AE, 2 =CE=94=CE=
=B5=CE=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 5:48:31 =CE=BC=
=CE=BC, Tobias wrote:
>> Am 02.12.2011 16:22, schrieb Konstantinos Skarlatos:
>>>>> So, the transaction close is in btrfs_evict_inode, which sounds=20
>>>>> like a
>>>>> deadlock recently fixed by this commit:
>>>>>
>>>>> http://git.kernel.org/?p=3Dlinux/kernel/git/mason/linux-btrfs.git=
;a=3Dcommit;h=3Daa38a711a893accf5b5192f3d705a120deaa81e0=20
>>>>>
>>>>>
>>>>> If you pull the for-linus branch from today, hopefully the proble=
m=20
>>>>> will
>>>>> be gone.
>>>>>
>>>>
>>>> This looks very good. With this Kernel i still have some hangs, bu=
t=20
>>>> only in rsync, only under high load and they don't lock up the=20
>>>> system - so i guess it's ok now.
>>>
>>> I still have hangs and lock ups under the same situation (rsync of=20
>>> many files) under 3.2rc3. rc3 made the hang appear after 200gb of=20
>>> files, while in rc2 i had hangs after only 11gb .
>>
>> Yes, i had them too in 3.2rc3! The problem where solved with patches=
=20
>> from the "btrfs-for-linus" -branch. (see link above).
>>
>> Tobias
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
