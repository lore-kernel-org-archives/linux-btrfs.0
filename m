Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29041 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbaB1NFe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 08:05:34 -0500
Message-ID: <53108991.4030504@fb.com>
Date: Fri, 28 Feb 2014 08:05:21 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: >16TB Btrfs volumes are mountable on 32 bit kernels
References: <994B6F86-9AF0-4826-8352-8573EE8003B6@colorremedies.com> <530FA8FA.9020700@fb.com> <20140228043807.GC13647@dastard>
In-Reply-To: <20140228043807.GC13647@dastard>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 11:38 PM, Dave Chinner wrote:
> On Thu, Feb 27, 2014 at 04:07:06PM -0500, Josef Bacik wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 02/27/2014 04:05 PM, Chris Murphy wrote:
>>> User reports successfully formatting and using an ~18TB Btrfs 
>>> volume on hardware raid5 using i686 kernel for over a year,
>>> and then suddenly the file system starts behaving weirdly:
>>> 
>>> https://urldefense.proofpoint.com/v1/url?u=http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg31856.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=5ac126734d7fa1d3238ab09a2ddc021a8dcc8fff7b022560a4d068be2de37c00
>>>
>>>
>>>
>>>
>>> 
I think this is due to the kernel page cache address space being
>>> 16TB limited on 32-bit kernels, as mentioned by Dave Chinner
>>> in this thread:
>>> 
>>> https://urldefense.proofpoint.com/v1/url?u=http://oss.sgi.com/pipermail/xfs/2014-February/034588.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=6eUt5RgBggFh930oFrH19iR4z%2BFVzT%2F0%2F4dYPt3g48U%3D%0A&s=3e45f9288e6a77bc1a24dded368802c2ab46b812bf59953f74d4ee1d4141f7d2
>>>
>>>
>>> 
So it sounds like it shouldn't be possible to mount a Btrfs volume
>>> larger than 16TB on 32-bit kernels. This is consistent with
>>> ext4 and XFS which refuse to mount large file systems.
>>> 
>>> 
>> 
>> Well that's not good, I'll fix this up.  Thanks,
> 
> Well, don't go assuming there's a problem just because I made an 
> off-hand comment. i.e my comment was simply "maybe it hasn't been 
> tested", and not an assertion that there is a bug or a problem....
> 

If I can't take your word as gospel then my whole life has been a lie!
 I'll look into it some more then but I seem to remember this being a
real problem, like we'd wrap around in pagecache once we went above
16tb, which would cause problems for metadata since our btree inode is
mapped logically to the entire fs.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTEImAAAoJEANb+wAKly3BtrwP/jChKmHL74UNkeKytwRtbKn9
MxudB5MxzaAzYcXpwVXOxhDAYy870htbzyePddhEjMCubY5Hnb10klGx3QztxV1z
G7qnoJp0FchpLSMSAhQE0B8steRTPbawKBIYqb1Kj7p39j+HmQ4K6fafcajtA929
rgFcNIa61rTjurknI9N9Lf2palReycl1Ee3psiH+mXN+RvPBAZ13sFp1sVJWJvoE
qHDB0g1vC47MbsvrADMeI/W6MUS8hXaZ31xS5PVOBTQiabH2ycw2853fAJsVdSsZ
0oh4E8AwnWf5+/V0wqFXFE0zMoEpWOc5JScbWMB1kZYQbBLCWUue5olLoPyOv2M6
WUS89IpTrspQ80KvWIGN1Bg4p7BAJ2h74zWWrEyGLtt3ujoKffcycGI19i7ln9cq
glLf8ofCiOCGs5VSTQMdSl6Eu0XYPQQViq0autpcBhkit0DV7A/caK+b351+t3c7
SI+Xx8LsvUVVATo11nSI/Z9lRol/XEX08G2XrDI+YiSOaW1qjDueNDBrpai/8gRt
dN8qbooDPArf82maNfCXsuEkKQIvkICxhRc3BWFvKeS/UTw5T9Y20UWAwanJfRfD
bLE357shUKimRtunr0MplQU9GVyCD/0tTtm3BPzOcWlG5QX7fugAobJPRqpQTD6b
d6PAQswquwuEfcqr38nk
=+lP6
-----END PGP SIGNATURE-----
