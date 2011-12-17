From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 17:35:15 +0100
Message-ID: <201112171735.15402.Martin@lichtvoll.de>
References: <201112161851.52011.Martin@lichtvoll.de> <201112171238.07681.Martin@lichtvoll.de> <20111217114508.GE17573@carfax.org.uk> (sfid-20111217_125531_294162_E841BA0A)
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: Hugo Mills <hugo@carfax.org.uk>,
	Sergei Trofimovich <slyich@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111217114508.GE17573@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 17. Dezember 2011 schrieb Hugo Mills:
> > I might still be doing the balance for that optical viewing pleasure
> > ;).
> 
>    :)
> 
>    It can't hurt, and with such a small FS it probably won't take
> long.

Now I first did a defrag and then a balance. The balance was heavier I had 
music stalls of about 5 to 10 seconds at time.

The defrag aborted  quickly with a non-zero return code on second run:

deepdance:~> btrfs filesystem defragment /
^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C

I wanted to start it via time.

deepdance:~> /usr/bin/time btrfs filesystem defragment /
Command exited with non-zero status 20
0.00user 1.26system 0:03.86elapsed 32%CPU (0avgtext+0avgdata 
2160maxresident)k
2656inputs+70712outputs (2major+184minor)pagefaults 0swaps

Nothing in dmesg. Does 20 as return code mean "already defragmented"? ;)

I am looking forward to the new asynchronous defrag interface I read about 
somewhere.

Current state now is:

deepdance:~> btrfs filesystem df /                   
Data: total=7.75GB, used=6.91GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=896.00MB, used=506.47MB

Lets see how that fares.

Balance did log something:

[24065.740937] btrfs: found 4207 extents
[24075.581494] btrfs: found 4207 extents
[24077.982099] btrfs: relocating block group 24465375232 flags 1
[24090.418623] btrfs: found 1152 extents
[24099.195646] btrfs: found 1152 extents
[24100.994087] btrfs: relocating block group 24196939776 flags 1
[24124.823654] btrfs: found 3857 extents
[24140.208385] btrfs: found 3857 extents
[24142.334232] btrfs: relocating block group 23928504320 flags 1
[24164.219827] btrfs: found 534 extents
[24171.483027] btrfs: found 534 extents
[24176.021604] btrfs: relocating block group 23391633408 flags 1
[24230.123062] btrfs: found 8607 extents
[24255.193673] btrfs: found 8607 extents
[24258.142945] btrfs: relocating block group 22586327040 flags 1
[24271.875868] btrfs: relocating block group 22452109312 flags 36
[24322.334007] btrfs: found 19112 extents
[24324.253074] btrfs: relocating block group 22317891584 flags 36
[24361.999904] btrfs: found 6934 extents
[24362.927413] btrfs: relocating block group 22183673856 flags 36
[24393.151548] btrfs: found 9031 extents
[24395.447755] btrfs: relocating block group 22049456128 flags 36
[24432.611355] btrfs: found 13216 extents
[24435.508280] btrfs: relocating block group 20975714304 flags 1
[24574.903545] btrfs: found 14600 extents
[24642.613698] btrfs: found 14586 extents
[24647.144462] btrfs: relocating block group 20841496576 flags 36
[24730.473343] btrfs: found 19754 extents
[24735.912210] btrfs: relocating block group 20707278848 flags 36
[24852.827906] btrfs: found 26482 extents
[24853.838002] btrfs: relocating block group 20698890240 flags 34
[24854.825685] btrfs: found 1 extents
[24855.858015] btrfs: relocating block group 20564672512 flags 36
[25001.321705] btrfs: found 31648 extents
[25002.330616] btrfs: relocating block group 20430454784 flags 36
[25170.694953] btrfs: found 30709 extents
[25173.027484] btrfs: relocating block group 20296237056 flags 36
[25240.022780] btrfs: found 19729 extents
[25242.373217] btrfs: relocating block group 20162019328 flags 36
[25293.659547] btrfs: found 11857 extents
[25294.514415] btrfs: relocating block group 20027801600 flags 36
[25381.873449] btrfs: found 20892 extents
[25382.837313] btrfs: relocating block group 18954059776 flags 1
[25407.731124] btrfs: relocating block group 17880317952 flags 1
[25528.179185] btrfs: found 13850 extents
[25572.737920] btrfs: found 13831 extents
[25574.017807] btrfs: found 1 extents
[25577.603801] btrfs: relocating block group 16806576128 flags 1
[25667.266953] btrfs: found 2448 extents
[25689.503862] btrfs: found 2448 extents
[25691.924348] btrfs: relocating block group 15732834304 flags 1
[25796.270409] btrfs: found 11264 extents
[25838.860555] btrfs: found 11264 extents
[25843.971106] btrfs: relocating block group 14659092480 flags 1
[25959.486034] btrfs: found 18680 extents
[26037.370148] btrfs: found 18680 extents
[26040.637078] btrfs: relocating block group 13585350656 flags 1
[26131.997384] btrfs: found 26798 extents
[26211.759652] btrfs: found 26787 extents
[26215.846016] btrfs: relocating block group 12511608832 flags 1
[26331.196068] btrfs: found 33247 extents
[26470.846542] btrfs: found 33197 extents
[26479.487194] btrfs: relocating block group 12377391104 flags 36
[26503.391492] btrfs: found 4410 extents
[26507.133189] btrfs: relocating block group 11303649280 flags 1
[26607.401285] btrfs: found 32999 extents
[26770.759705] btrfs: found 32926 extents
[26778.218628] btrfs: relocating block group 11169431552 flags 36
[26921.757006] btrfs: found 23449 extents
[26922.956668] btrfs: relocating block group 11035213824 flags 36
[27047.652332] btrfs: found 21526 extents

Appears quite fragmented to me, but as I do not understand whats exactly 
behind this numbers I leave it as it.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
