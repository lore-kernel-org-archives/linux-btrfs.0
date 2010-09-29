From: cwillu <cwillu@cwillu.com>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 07:15:30 -0600
Message-ID: <AANLkTi=HmRxNnoDwSL_V=Kyo8X92+1+29O8o4+RXNE8f@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
	<AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
	<AANLkTi=UNd1=_q+n6m0vmf_YvDP1PBWZftCF=dUnNTYx@mail.gmail.com>
	<AANLkTimAk-svytPk-rQFXAZkrKdT5pU35GYfV7W33hi0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Francis Galiegue <fgaliegue@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimAk-svytPk-rQFXAZkrKdT5pU35GYfV7W33hi0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>>> Which kernel is that?
>> It was one of the 2.6.35 versions from the Ubuntu repository. I'm
>> running Ubuntu 10.04 Server.
>>
>
> Since 2.6.32 works, you should report that bug to Ubuntu.

Alternatively, retest using ubuntu's mainline kernel ppa
(http://kernel.ubuntu.com/~kernel-ppa/mainline/), which doesn't
include any ubuntu patches.
