From: cwillu <cwillu@cwillu.com>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 09:05:42 -0600
Message-ID: <AANLkTi=BFpyN_sTzzdboCMVoFEmU_pz3T2ezuHMh=5Ok@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
	<AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
	<AANLkTi=UNd1=_q+n6m0vmf_YvDP1PBWZftCF=dUnNTYx@mail.gmail.com>
	<AANLkTimAk-svytPk-rQFXAZkrKdT5pU35GYfV7W33hi0@mail.gmail.com>
	<AANLkTi=HmRxNnoDwSL_V=Kyo8X92+1+29O8o4+RXNE8f@mail.gmail.com>
	<AANLkTi=b-BXPzYS2H0H6v1Nvj--Q+0Czb0CLmwSusEYR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Francis Galiegue <fgaliegue@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=b-BXPzYS2H0H6v1Nvj--Q+0Czb0CLmwSusEYR@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 8:31 AM, Sebastian 'gonX' Jensen
<gonx@overclocked.net> wrote:
> On 29 September 2010 15:15, cwillu <cwillu@cwillu.com> wrote:
>>>>> Which kernel is that?
>>>> It was one of the 2.6.35 versions from the Ubuntu repository. I'm
>>>> running Ubuntu 10.04 Server.
>>>>
>>>
>>> Since 2.6.32 works, you should report that bug to Ubuntu.
>>
>> Alternatively, retest using ubuntu's mainline kernel ppa
>> (http://kernel.ubuntu.com/~kernel-ppa/mainline/), which doesn't
>> include any ubuntu patches.
>
> I used the mainline ppa when I used 2.6.35. That is where I had the
> issue. Forgive me for saying it was in the repository, but I did not
> realize they were not the same thing.

Well, it is a repository, but that one specifically doesn't include
ubuntu patches, as opposed to whats in the default repositories.
Given that you used the mainline kernels, it's unlikely to be an
ubuntu bug.
