From: Henning Rohlfs <x+btrfs@xehonk.de>
Subject: Re: Abysmal Performance
Date: Wed, 22 Jun 2011 16:15:14 +0200
Message-ID: <e5b85820126546a3369499aebb166c60@localhost>
References: <7da312412980843ba746e4e8809060f8@localhost>
 <1308669852.2106.7.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1308669852.2106.7.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

 On Tue, 21 Jun 2011 11:24:11 -0400, Calvin Walton wrote:
> On Mon, 2011-06-20 at 23:51 +0200, Henning Rohlfs wrote:
>> Hello,
>>
>>  I've migrated my system to btrfs (raid1) a few months ago. Since=20
>> then
>>  the performance has been pretty bad, but recently it's gotten
>>  unbearable: a simple sync called while the system is idle can take=20
>> 20 up
>>  to 60 seconds. Creating or deleting files often has several seconds
>>  latency, too.
>
> I think I=E2=80=99ve been seeing a fairly similar, or possibly the sa=
me?=20
> issue
> as well. It looks like it=E2=80=99s actually a regression introduced =
in=20
> 2.6.39 -
> if I switch back to a 2.6.38 kernel, my latency issues magically go
> away! (I'm curious: does using the older 2.6.38.x kernel help with
> anyone else that's seeing the issue?)
>
> Some hardware/configuration details:
> btrfs on a single disc (Seagate Momentus XT hybrid), lzo compression=20
> and
> space cache enabled. Some snapshots in use.
>
> I notice that in latencytop I'm seeing a lot of lines with (cropped)
> traces like
>
> sleep_on_page wait_on_page_bit read_extent_buffer_ 13.3 msec         =
=20
> 0.5 %
>
> showing up that I didn't see with the 2.6.38 kernel. I occasionally=20
> see
> latencies as bad as 20-30 seconds on operations like fsync or
> synchronous writes.
>
> I think I can reproduce the issue well enough to bisect it, so I=20
> might
> give that a try. It'll be slow going, though.

 You are right. This seems to be a regression in the .39 kernel. I=20
 tested with 2.6.38.2 just now and the performance is back to normal.

 Thanks,
 Henning




 server ~ # uname -a
 Linux server 2.6.38.2 #1 SMP Thu Apr 14 13:05:35 CEST 2011 x86_64 AMD=20
 Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux

 server ~ # sync; time sync
 real	0m0.144s
 user	0m0.000s
 sys	0m0.020s

 server ~ # bonnie++ -d tmp -u 0:0
 Version  1.96       ------Sequential Output------ --Sequential Input-=20
 --Random-
 Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
 --Seeks--
 Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP =
=20
 /sec %CP
 server          16G   147  97 279933  56 73245  34  1258  78 102379  2=
3=20
 177.3  50
 Latency               423ms     103ms     645ms     163ms     404ms   =
 =20
 264ms
 Version  1.96       ------Sequential Create------ --------Random=20
 Create--------
 server              -Create-- --Read--- -Delete-- -Create-- --Read---=20
 -Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP =
=20
 /sec %CP
                  16  3784  28 +++++ +++  8519  60 13694  59 +++++ +++=20
 11710  76
 Latency               127ms    1024us   18718us   15958us     119us   =
=20
 2459us
 1.96,1.96,server,1,1308745595,16G,,147,97,279933,56,73245,34,1258,78,1=
02379,23,177.3,50,16,,,,,3784,28,+++++,+++,8519,60,13694,59,+++++,+++,1=
1710,76,423ms,103ms,645ms,163ms,404ms,264ms,127ms,1024us,18718us,15958u=
s,119us,2459us

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
