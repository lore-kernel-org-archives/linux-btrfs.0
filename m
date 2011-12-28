From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Date: Wed, 28 Dec 2011 23:58:10 +0200
Message-ID: <4EFB90F2.9030107@gmail.com>
References: <4EFB6D4F.6070002@gmail.com> <20111228214832.GG12731@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-kernel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-raid@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111228214832.GG12731@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On =CE=A4=CE=B5=CF=84=CE=AC=CF=81=CF=84=CE=B7, 28 =CE=94=CE=B5=CE=BA=CE=
=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 11:48:32 =CE=BC=CE=BC, Dav=
e Chinner wrote:
> On Wed, Dec 28, 2011 at 09:26:07PM +0200, Konstantinos Skarlatos wrot=
e:
>> Hello all:
>> I have two machines with btrfs, that give me the "blocked for more
>> than 120 seconds" message. After that I cannot write anything to
>> disk, i am unable to unmount the btrfs filesystem and i can only
>> reboot with sysrq-trigger.
>>
>> It always happens when i write many files with rsync over network.
>> When i used 3.2rc6 it happened randomly on both machines after
>> 50-500gb of writes. with rc7 it happens after much less writes,
>> probably 10gb or so, but only on machine 1 for the time being.
>> machine 2 has not crashed yet after 200gb of writes and I am still
>> testing that.
>>
>> machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs
>> filesystem that lies on a 10TB md raid5. mount options
>> compress=3Dzlib,compress-force
>>
>> machine 2: btrfs over md raid 5 (4x2TB)=3D5.5TB filesystem. mount
>> options compress=3Dzlib,compress-force
>>
>> pastebins:
>>
>> machine1:
>> 3.2rc7 http://pastebin.com/u583G7jK
>> 3.2rc6 http://pastebin.com/L12TDaXa
>
> These two are caused by it taking longer than 120s for XFS to fsync
> the loop file. Writing a signficant chunk of a sparse 6TB file on a
> software RAID5  volume is going to take some time.  However, if IO
> is not occurring, then somewhere below XFS an IO has gone missing
> (MD or hardware problem) because the fsync on the XFS file is
> blocked waiting for an IO completion.
>
>> machine2:
>> 3.2rc6 http://pastebin.com/khD0wGXx
>> 3.2rc7 (not crashed yet)
Crashed a few hours ago, here is the rc7 pastebin
http://pastebin.com/gvfUm0az=20
>
> These don't have XFS in the picture, but also appear to be hung
> waiting on IO completion with MD stuck in
> make_request()->get_active_stripe(). That, to me, indicates an MD
> problem.....
>
Added the linux-raid mailing list
Please reply to me too, because i am not subscribed.

> Cheers,
>
> Dave.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
