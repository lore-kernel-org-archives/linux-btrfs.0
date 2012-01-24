From: Martin Mailand <martin@tuxadero.com>
Subject: Re: Btrfs slowdown with ceph (how to reproduce)
Date: Tue, 24 Jan 2012 21:55:37 +0100
Message-ID: <4F1F1AC9.1090307@tuxadero.com>
References: <CAO47_-8Eb_v8X95KxSZ2H-DNC3hLZkrfq1ce3CAfW2G9CUV5gQ@mail.gmail.com> <20120123181928.GA3724@localhost.localdomain> <20120123185040.GH4387@shiny> <4F1F036E.9030801@tuxadero.com> <20120124194044.GI4387@shiny>
Reply-To: martin@tuxadero.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, Christian Brunner <chb@muc.de>,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20120124194044.GI4387@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
great to hear that, could you give me a ping if you fixed it, than I can 
retry it?

-martin

Am 24.01.2012 20:40, schrieb Chris Mason:
> On Tue, Jan 24, 2012 at 08:15:58PM +0100, Martin Mailand wrote:
>> Hi
>> I tried the branch on one of my ceph osd, and there is a big
>> difference in the performance.
>> The average request size stayed high, but after around a hour the
>> kernel crashed.
>>
>> IOstat
>> http://pastebin.com/xjuriJ6J
>>
>> Kernel trace
>> http://pastebin.com/SYE95GgH
>
> Aha, this I know how to fix.  Thanks for trying it out.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
