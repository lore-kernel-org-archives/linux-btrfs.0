Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45843 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753348AbaGBOPq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 10:15:46 -0400
Message-ID: <53B4140C.8060406@fb.com>
Date: Wed, 2 Jul 2014 10:15:40 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Cody P Schafer <dev@codyps.com>
CC: Chris Samuel <chris@csamuel.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
References: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>	<4623589E-3298-4980-A257-665CFA9FB61B@colorremedies.com>	<pan$26aa0$13a0ca68$c41d00a9$e8c14640@cox.net>	<3081460.dX0cLeJPhK@quad>	<CAPoQQ-093rEw6mRRDCS4bq8oGOvmuR_a6UAVOjK_ytb=Yq2BSw@mail.gmail.com>	<53B1A862.50503@fb.com>	<53B1ACAA.5040505@fb.com>	<CAPoQQ-14VPzzwTDDXmLSmEUs2Rm_HyukoYjeFfOi9LOjqaRCWw@mail.gmail.com>	<53B32275.6010200@fb.com>	<CAPoQQ-3DmAg=s0eBKirGmkfMhaC1bEyJu8fSJc-6fV-EvUbmxQ@mail.gmail.com> <CAPoQQ-1kn+UNfcE4+qeO4yKaX43PenqxBtMXABuP=Ot8=ZB2Gw@mail.gmail.com> <53B40FEC.4030902@fb.com>
In-Reply-To: <53B40FEC.4030902@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/02/2014 09:58 AM, Chris Mason wrote:
> On 07/02/2014 08:27 AM, Cody P Schafer wrote:
> 
>>> Will do. The rsync I'm running is processing a lot of chromium cache
>>> files when it hangs (just for a reference), and ends up triggering a
>>> bunch of deletes as well.
>>
>> Still a problem with your v3.15.y (eb97581), here's the log with
>> sysrq-t and sysrq-l
>> https://urldefense.proofpoint.com/v1/url?u=http://bpaste.net/show/428234/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=9lRzEuxWeyHtsDXvFJNWlf2CgKZWZ1w%2FScqbUMy1jII%3D%0A&s=0daa1232bef652c4f16c9d12cdad408909feaa5069ba3c1888fa4895e01ec3a2
>>
>> Also, correction, it's a firefox cache dir rsync that seems to trigger
>> it (stalls pretty early on and very consistently):
>>
>> [... snip ...]
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/1F/F43F9d01
>>           5.23M 100%   17.82MB/s    0:00:00 (xfr#452, ir-chk=1201/6659)
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/20/
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/20/23A66d01
>>         116.82K 100%  376.50kB/s    0:00:00 (xfr#453, ir-chk=1200/6659)
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/21/
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/23/
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/24/
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/25/
>> .cache/mozilla/firefox/kqtl1tlc.test/Cache/7/25/7C836d01
>> [... stall here ...]
>>
> 
> Ok, and just to clarify, are you actively using the files on the
> destination outside of rsync?

Also, do you have compression on?

-chris

