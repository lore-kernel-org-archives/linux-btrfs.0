From: Zhang Jingwang <yyalone@gmail.com>
Subject: Re: [PATCH 4/4] add snapshot/subvolume destroy ioctl
Date: Fri, 25 Sep 2009 09:45:13 +0800
Message-ID: <4486336c0909241845t267fa2a8t3fb39953b45398b7@mail.gmail.com>
References: <4AB37AB9.3060401@oracle.com>
	 <4486336c0909240127v2a3320c7s52db89b12d1d7272@mail.gmail.com>
	 <20090924124322.GB2797@think> <20090924135955.GC2797@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, john <yyalone@gmail.com>,
	"Yan, Zheng" <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090924135955.GC2797@think>
List-ID: <linux-btrfs.vger.kernel.org>

My test result confirms that it has been fixed. Thanks for your time.

2009/9/24 Chris Mason <chris.mason@oracle.com>:
> On Thu, Sep 24, 2009 at 08:43:22AM -0400, Chris Mason wrote:
>> On Thu, Sep 24, 2009 at 04:27:57PM +0800, john wrote:
>> > =A0 =A0After a git bisect, I think this patch may introduce a perf=
ormance
>> > =A0 =A0regression(about 15% slower) in postmark benchmark. Sometim=
es(last a few
>> > =A0 =A0seconds) in the test, CPU usage is 100% wait but NO IO is p=
erforming, it's
>> > =A0 =A0not IO-wait. This didn't happen for earlier versions.
>> > =A0 =A0test*environment:
>> > =A0 =A0hard disk: INTEL X25-E SSD 64G
>> > =A0 =A0mkfs options: mkfs.btrfs -m single /dev/xxx
>> > =A0 =A0mount options: -o ssd,nodatasum,nodatacow
>>
>> Thanks, I'll give this a shot here.
>
> Looks like Yan Zheng already tracked it down. =A0I've pushed his fix =
out
> to the master branch.
>
> Thanks,
> Chris
>
>



--=20
Zhang Jingwang
National Research Centre for High Performance Computers
Institute of Computing Technology, Chinese Academy of Sciences
No. 6, South Kexueyuan Road, Haidian District
Beijing, China
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
