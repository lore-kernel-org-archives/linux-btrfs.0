From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Performance degradation
Date: Wed, 22 Sep 2010 13:03:03 +0100
Message-ID: <AANLkTikLcyQr7Ooi5jxMMHOq9Y1OaH58GMjucGhfUQUH@mail.gmail.com>
References: <AANLkTimhpg22M0UUcfksh1H9oGMweVhwpDvqeu0nfOP0@mail.gmail.com>
	<D1A263E5-C03A-4D6B-BC4D-6085F10714E1@noir.com>
	<AANLkTi=569wzOheD_eeai6O7uaWBxMhRv5_YuUE1dJZb@mail.gmail.com>
	<20100922000217.GP27633@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	"K. Richard Pixley" <rich@noir.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Dave Cundiff <syshackmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100922000217.GP27633@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 22 September 2010 01:02, Chris Mason <chris.mason@oracle.com> wrote:
> On Tue, Sep 21, 2010 at 12:27:03AM -0400, Dave Cundiff wrote:
>> On Mon, Sep 20, 2010 at 9:19 PM, K. Richard Pixley <rich@noir.com> w=
rote:
>> > Do you have any kernel processes running constantly? =A0Any taking=
 near 100% of a CPU?
>> >
>> > --rich
>> >
>>
>> Now that I look again, it seems that the btrfs-cleaner process is
>> still running. CPU isn't much of an issue on this box. Its a dual qu=
ad
>> E5620. 8 cores, 16 threads.
>> Looks like most of my load is wait from the cleaner process hammerin=
g
>> the disks. I deleted about 10 snapshots I think. Should this take 4
>> days to clean up from that?
>
> It shouldn't but it depends on how much metadata we have to read in t=
o
> process the snapshots. =A0Could you do a few sysrq-w? =A0We'll see wh=
ere you
> are spending your time based on the traces.

Also, using 'perf' may give a good picture of where the time is spent, =
eg:

$ sudo perf record -a sleep 20
$ sudo perf report | tee profile.txt
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
