Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61200 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbaBQNEU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 08:04:20 -0500
Message-ID: <5302096A.8070708@fb.com>
Date: Mon, 17 Feb 2014 08:06:50 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>, Dave <dave@thekilempire.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.14-rc1] BUG: soft lockup - CPU#1 stuck for 22s with 255 GiB
 BTRFS with only 6 GiB free
References: <16006080.zeFsK4Kcpx@merkaba> <CAAVQaYBurkq_OdE7K0vEoNhToFHYRQo5Y4bJE_Cx5J-awDh1ow@mail.gmail.com> <2243736.htmPCRf1EE@merkaba>
In-Reply-To: <2243736.htmPCRf1EE@merkaba>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/17/2014 05:35 AM, Martin Steigerwald wrote:
> Am Dienstag, 11. Februar 2014, 15:50:12 schrieb Dave:
>> On Tue, Feb 11, 2014 at 10:36 AM, Martin Steigerwald
>>
>> <Martin@lichtvoll.de> wrote:
>>> Today I started getting those on 3.14-rc. One core as displayed as 100%
>>> system CPU. I rebooted cause the system didn´t respond consistently to
>>> user input anymore.
>>
>> Does 3.14-rc1 have Joseph's delayed refs throttling code?  I had two
>> separate machines that exhibited similar symptoms.  Chris's for-linus
>> branch has a fix for this which solved my problems:
>> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h%3Dfor-linus%26id%3D27a377db745ed4d11b3b9b340756857cb8dde07f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=EO6xV8TuAFpGsdd9TfvXbfHYgIFA8%2BKZo1KnQ%2BZ6yzU%3D%0A&s=c9c8769a12e5537247d6ef176681cf19e2bf80fef186ead748b8a2cd2bac6a85
>
> I also got this now under 3.14-rc3 with almost 16 GiB left on heavy KMail /
> Akonadi activity. 3.14-rc3 includes above commit.
>
> As I now also got it with more free space and never saw this with upto
> 3.13 I think this is a regression.

Do we eventually recover or is it stuck like this forever?

-chris
