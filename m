From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: what does "scrub" mean?
Date: 02 Nov 2011 19:37:00 +0100
Message-ID: <Bx5Iq9Yy1uB@helmut.hullen.de>
References: <4EB18540.8060105@gmx.net>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB18540.8060105@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Arne,

Du meintest am 02.11.11:

>> # btrfs scrub status /srv/MM
>>
>> scrub status for 120b036a-883f-46aa-bd9a-cb6a1897c8d2
>> 	scrub resumed at Wed Nov  2 17:02:07 2011 and was aborted after
>> 16519 seconds 	total bytes scrubbed: 1.79TB with 61 errors
>> 	error details: read=4 verify=21 csum=36
>> 	corrected errors: 28, uncorrectable errors: 24, unverified errors:
>> 0
>>

> can you also show the output in dmesg? Maybe the extent tree is
> damaged to a point where it can't be fully traversed.

from "/var/log/warn":

Nov  1 18:04:31 Arktur kernel: parent transid verify failed on 8520218480640 wanted 57343 found 55967
Nov  1 18:08:14 Arktur kernel: parent transid verify failed on 5340294963200 wanted 57354 found 42286

( btrfs scrub start /srv/MM )

Nov  1 19:58:46 Arktur kernel: parent transid verify failed on 21094400 wanted 57401 found 47987
Nov  1 19:58:46 Arktur kernel: btrfs: failed to read chunk tree on sdg1
Nov  1 19:58:46 Arktur kernel: btrfs: open_ctree failed
Nov  1 19:58:50 Arktur kernel: parent transid verify failed on 21094400 wanted 57401 found 47987
Nov  1 19:58:50 Arktur kernel: btrfs: failed to read chunk tree on sdg1
Nov  1 19:58:50 Arktur kernel: btrfs: open_ctree failed
Nov  1 20:12:30 Arktur kernel: parent transid verify failed on 21094400 wanted 57401 found 47987
Nov  1 20:12:30 Arktur kernel: btrfs: failed to read chunk tree on sdg1
Nov  1 20:12:30 Arktur kernel: btrfs: open_ctree failed
Nov  1 20:12:50 Arktur kernel: parent transid verify failed on 21094400 wanted 57401 found 47987
Nov  1 20:12:50 Arktur kernel: btrfs: failed to read chunk tree on sdg1
Nov  1 20:12:50 Arktur kernel: btrfs: open_ctree failed
Nov  1 21:54:40 Arktur kernel: btrfs: fixed up at 21094400
Nov  1 21:54:42 Arktur kernel: parent transid verify failed on 8520776052736 wanted 57347 found 55978
Nov  1 21:55:02 Arktur kernel: parent transid verify failed on 8520777674752 wanted 57362 found 57240
Nov  1 21:58:20 Arktur kernel: btrfs: fixed up at 21094400
Nov  1 21:58:20 Arktur kernel: parent transid verify failed on 8520776052736 wanted 57347 found 55978
Nov  1 21:58:26 Arktur kernel: parent transid verify failed on 8520777674752 wanted 57362 found 57240
Nov  2 00:11:06 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2
Nov  2 00:11:06 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2

( maybe btrfs scrub was finished )

Nov  2 06:50:46 Arktur kernel: btrfs: fixed up at 21094400
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340295811072
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340292898816
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340295815168
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340295839744
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340295872512
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340295843840
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340297310208
Nov  2 06:51:04 Arktur kernel: btrfs: fixed up at 5340297973760
Nov  2 06:51:05 Arktur kernel: btrfs: fixed up at 5340297986048
Nov  2 06:51:05 Arktur kernel: btrfs: fixed up at 5340298403840
Nov  2 08:16:45 Arktur kernel: scrub_fixup: 2 callbacks suppressed
Nov  2 08:16:45 Arktur kernel: btrfs: unable to fixup at 5165489049600
Nov  2 08:16:45 Arktur kernel: btrfs: unable to fixup at 5165489053696
Nov  2 08:17:06 Arktur kernel: end_request: I/O error, dev sdg, sector 385395216
Nov  2 08:17:06 Arktur kernel: btrfs: unable to fixup at 5165519876096
Nov  2 08:17:06 Arktur kernel: btrfs: unable to fixup at 5165519880192
Nov  2 08:17:06 Arktur kernel: btrfs: unable to fixup at 5165519896576
Nov  2 08:17:06 Arktur kernel: btrfs: unable to fixup at 5165519900672
Nov  2 08:17:24 Arktur kernel: end_request: I/O error, dev sdg, sector 385395216
Nov  2 08:17:24 Arktur kernel: btrfs: unable to fixup at 5165519904768
Nov  2 08:17:40 Arktur kernel: end_request: I/O error, dev sdg, sector 385395223
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165519908864
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165532839936
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165532844032
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165519912960
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165519917056
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165519921152
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165524221952
Nov  2 08:17:40 Arktur kernel: btrfs: unable to fixup at 5165524226048
Nov  2 08:17:41 Arktur kernel: btrfs: unable to fixup at 5165541158912
Nov  2 08:17:46 Arktur kernel: btrfs: fixed up at 5064609521664
Nov  2 08:17:46 Arktur kernel: btrfs: fixed up at 5064609525760
Nov  2 08:17:46 Arktur kernel: btrfs: fixed up at 5064609554432
Nov  2 08:17:46 Arktur kernel: btrfs: fixed up at 5064609562624
Nov  2 08:17:48 Arktur kernel: end_request: I/O error, dev sdg, sector 385409567
Nov  2 08:17:48 Arktur kernel: btrfs: fixed up at 5064609800192
Nov  2 08:17:51 Arktur kernel: end_request: I/O error, dev sdg, sector 385409567
Nov  2 08:17:51 Arktur kernel: btrfs: fixed up at 5064609742848
Nov  2 08:17:51 Arktur kernel: btrfs: fixed up at 5064612601856
Nov  2 08:17:55 Arktur kernel: btrfs: fixed up at 5064612712448
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615608320
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615624704
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615661568
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615628800
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615665664
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615632896
Nov  2 08:18:01 Arktur kernel: btrfs: fixed up at 5064615669760
Nov  2 09:43:57 Arktur kernel: btrfs: unable to fixup at 4963026173952
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675143168
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675278336
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675294720
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675298816
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675302912
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675307008
Nov  2 09:50:25 Arktur kernel: btrfs: unable to fixup at 4949675311104
Nov  2 10:23:10 Arktur kernel: parent transid verify failed on 8520218849280 wanted 57343 found 55967
Nov  2 10:48:36 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2
Nov  2 10:48:36 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2
Nov  2 11:26:05 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2
Nov  2 11:26:05 Arktur kernel: btrfs: corrupt leaf, bad key order: block=8520786001920,root=1, slot=2

(btrfs scrub resume /srv/MM)

Nov  2 17:02:07 Arktur kernel: parent transid verify failed on 4478091280384 wanted 57352 found 57303
Nov  2 17:02:08 Arktur kernel: parent transid verify failed on 8520218472448 wanted 57343 found 55967
Nov  2 17:39:32 Arktur kernel: parent transid verify failed on 8520218472448 wanted 57343 found 55967

-------------------------------------------------------------------

Yes - I know the system is damaged.
But 2-TByte HDs are expensive, and the data isn't critical.

Nearly all (or all) of the more than 2000 files seem to be readable. And  
writing new files to the system works at least most times.

Viele Gruesse!
Helmut
