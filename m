Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62116 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaESR7F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 13:59:05 -0400
Received: by mail-ig0-f176.google.com with SMTP id hl10so3804107igb.15
        for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 10:59:04 -0700 (PDT)
Message-ID: <537A4665.9080202@gmail.com>
Date: Mon, 19 May 2014 13:59:01 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>
CC: linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>
Subject: Re: send/receive and bedup
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <537A3B63.40806@gmail.com>
In-Reply-To: <537A3B63.40806@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080504080803050204050803"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080504080803050204050803
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-05-19 13:12, Konstantinos Skarlatos wrote:
> On 19/5/2014 7:01 =CE=BC=CE=BC, Brendan Hide wrote:
>> On 19/05/14 15:00, Scott Middleton wrote:
>>> On 19 May 2014 09:07, Marc MERLIN <marc@merlins.org> wrote:
>>>> On Wed, May 14, 2014 at 11:36:03PM +0800, Scott Middleton wrote:
>>>>> I read so much about BtrFS that I mistaked Bedup with Duperemove.
>>>>> Duperemove is actually what I am testing.
>>>> I'm currently using programs that find files that are the same, and
>>>> hardlink them together:
>>>> http://marc.merlins.org/perso/linux/post_2012-05-01_Handy-tip-to-sav=
e-on-inodes-and-disk-space_-finddupes_-fdupes_-and-hardlink_py.html
>>>>
>>>>
>>>> hardlink.py actually seems to be the faster (memory and CPU) one eve=
nt
>>>> though it's in python.
>>>> I can get others to run out of RAM on my 8GB server easily :(
>>
>> Interesting app.
>>
>> An issue with hardlinking (with the backups use-case, this problem
>> isn't likely to happen), is that if you modify a file, all the
>> hardlinks get changed along with it - including the ones that you
>> don't want changed.
>>
>> @Marc: Since you've been using btrfs for a while now I'm sure you've
>> already considered whether or not a reflink copy is the better/worse
>> option.
>>
>>>>
>>>> Bedup should be better, but last I tried I couldn't get it to work.
>>>> It's been updated since then, I just haven't had the chance to try i=
t
>>>> again since then.
>>>>
>>>> Please post what you find out, or if you have a hardlink maker that'=
s
>>>> better than the ones I found :)
>>>>
>>>
>>> Thanks for that.
>>>
>>> I may be  completely wrong in my approach.
>>>
>>> I am not looking for a file level comparison. Bedup worked fine for
>>> that. I have a lot of virtual images and shadow protect images where
>>> only a few megabytes may be the difference. So a file level hash and
>>> comparison doesn't really achieve my goals.
>>>
>>> I thought duperemove may be on a lower level.
>>>
>>> https://github.com/markfasheh/duperemove
>>>
>>> "Duperemove is a simple tool for finding duplicated extents and
>>> submitting them for deduplication. When given a list of files it will=

>>> hash their contents on a block by block basis and compare those hashe=
s
>>> to each other, finding and categorizing extents that match each
>>> other. When given the -d option, duperemove will submit those
>>> extents for deduplication using the btrfs-extent-same ioctl."
>>>
>>> It defaults to 128k but you can make it smaller.
>>>
>>> I hit a hurdle though. The 3TB HDD  I used seemed OK when I did a lon=
g
>>> SMART test but seems to die every few hours. Admittedly it was part o=
f
>>> a failed mdadm RAID array that I pulled out of a clients machine.
>>>
>>> The only other copy I have of the data is the original mdadm array
>>> that was recently replaced with a new server, so I am loathe to use
>>> that HDD yet. At least for another couple of weeks!
>>>
>>>
>>> I am still hopeful duperemove will work.
>> Duperemove does look exactly like what you are looking for. The last
>> traffic on the mailing list regarding that was in August last year. It=

>> looks like it was pulled into the main kernel repository on September
>> 1st.
>>
>> The last commit to the duperemove application was on April 20th this
>> year. Maybe Mark (cc'd) can provide further insight on its current
>> status.
>>
> I have been testing duperemove and it seems to work just fine, in
> contrast with bedup that i have been unable to install/compile/sort out=

> the mess with python versions. I have 2 questions about duperemove:
> 1) can it use existing filesystem csums instead of calculating its own?=

While this might seem like a great idea at first, it really isn't.
BTRFS uses CRC32c at the moment as it's checksum algorithm, and while
that is relatively good at detecting small differences (i.e. a single
bit flipped out of every 64 or so bytes), it is known to have issues
with hash collisions.  Normally, the data on disk won't change enough
even from a media error to cause a hash collision, but when you start
using it to compare extents that aren't known to be the same to begin
with, and then try to merge those extents, you run the risk of serious
file corruption.  Also, AFAIK, BTRFS doesn't expose the block checksum
to userspace directly (although I may be wrong about this, in which case
i retract the following statement) this would therefore require some
kernelspace support.
> 2) can it be included in btrfs-progs so that it becomes a standard
> feature of btrfs?
I would definitely like to second this suggestion, I hear a lot of
people talking about how BTRFS has batch deduplication, but it's almost
impossible to make use of without extra software or writing your own code=
=2E


--------------ms080504080803050204050803
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGuDCC
BrQwggScoAMCAQICAw8BRDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA1
MTIxNDEwMzJaFw0xNDExMDgxNDEwMzJaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDbLUaL
Gs4JTdU7sgr0MzD57CMUAv307ddC9pxooDMN3PiUvzEd5kLtBCh8KDB1wbMdfm4hte2rDd+j
hM1tIq67BvNbdDPztOcBZwT2/3OVyyG4B1ddCqUyt03zGKw6Y34eHNfapsZiiItX0GBNfjHU
Wv+WDo+XNha/WmGSSMv21HkftF9XA1KC9Bpr9JJI23MKK7T2g/7b3KoGZlx3ekLIJsF5B7+B
DMPPDqOHQbRnccyOHEMyhM13g6WoAbU+3aKYc+C/9UsYtDV+xlvBLWagky1acstD5wOA35V6
uDRbUhD+vOjuMRMCj9jJOIYqa6AeSagBjxRnisJr0RFzQ4f+NjGCHPaFTvRvbkiXh4q22doT
0SxbNBUm7B9ANugIOtS9/VQhTWKDi//WTqZQ7Ecl4yVJbMCUg/iaRHMCGS41vqMICPszRidW
rL04NwS9D2cREEY1y/xrNo0ZvKPZu6tLhxhPf7w+5rsN3+wWxGaR1hNpnVUT9AeacLKZO6W9
FsRT3Unkr91IhQATHTKYr4EAkjN/5lgvA+sxp5TxxsUnoJYrD8IHf8aYfJsAHMleBwx4xSeZ
tw/n5iIjJjFZq9IRZ1zQhK62p+a5vJ2vlJHjTgavhQrfb1pUOjbqsnI4ndQ5hNosL9el4Kxq
Yko+HsxVEmSwSsjq6cV2L3oz0z8NUwIDAQABo4IBWTCCAVUwDAYDVR0TAQH/BAIwADBWBglg
hkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQg
b3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwDgYDVR0PAQH/BAQDAgOoMEAGA1UdJQQ5
MDcGCCsGAQUFBwMEBggrBgEFBQcDAgYKKwYBBAGCNwoDBAYKKwYBBAGCNwoDAwYJYIZIAYb4
QgQBMDIGCCsGAQUFBwEBBCYwJDAiBggrBgEFBQcwAYYWaHR0cDovL29jc3AuY2FjZXJ0Lm9y
ZzAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8vY3JsLmNhY2VydC5vcmcvcmV2b2tlLmNybDA0
BgNVHREELTArgRRhaGZlcnJvaW43QGdtYWlsLmNvbYETYWhlbW1lbGdAb2hpb2d0LmNvbTAN
BgkqhkiG9w0BAQ0FAAOCAgEAIokFPcW8+cO2Clu0Ei+ehAmQRBHfV5RWJ8aMVLXOCfiJX0ch
IjVSIt6I3uQaR4J1ZIAjCSPkbpfZQDaLoGFI5j8aYEQhOeKxrvOMzY9/aSUYabCJIhE/sX64
klFV0bzm+PR9cDMWeQ9BoZf0m8UROPSfDnrjEk+p04hGg3pAZMcSwCzxdb604NHjgHJmf2xG
UQVzQgC6Ek/BKat0xuPTuPmtPv9OicK75CPmLZKYW3rFpCD6bhb1mm+ROcCNhniRY2LYm9YN
QdlHQUzTFqj0tvuYrzNI3LNV4PjEfN8z6omPCT2Rq8/uKLseN+m8F0ioqm+cphqpmzKoDUpN
nePLkqDFUFWCeWRxSjBTy4IMVUfdNXriVGihH8hyIICQiOfmmBOzhzUifdomJuTGtoXRuHVT
R2f/YdrJrLnKI4f+Othdp7F3KhB4c6JiOnTEH5J8n9q3rFjt4MPRwcjIHMhmF5nZVQlgxEMo
1cPCmvG1D9tcgXbH79jjqydo9SDXhzLQob7axkzGRY96IstNcvoQ/UNsdPPfFMYlHtGz4TxT
DhBjv4ERskGmKBZrfmxkXkcuTV/gcykct6Xvw9YXb8WTL4qSYHSYk9fReVLgE/L4RBUpX2JJ
QvIR0AJLER165/aZlQXZtuJjnfxJtJTJZZ+Gor9h0G2kuR5Dy0JuYdBO4t4xggShMIIEnQIB
ATCBgDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5v
cmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEW
EnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFEMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDUxOTE3NTkwMVowIwYJKoZIhvcNAQkE
MRYEFOceiM6VppW0dZb69cwrN4i0TdR8MGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEq
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYD
VQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMT
GUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2Fj
ZXJ0Lm9yZwIDDwFEMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENB
MR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2ln
bmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDwFE
MA0GCSqGSIb3DQEBAQUABIICALikrmMlGRagk0EzYy147q8Md/Un8MgAL/RGWiKvHxwpO9ou
y+uBtXu5v7P6V7SS6FVfVwtVDRn0Kw56yD82nb2z660VIPut+xjKO/tXNcFkCOhVIpcd+J50
xJHx92pROQUU1XbYJXFmGbNxhQjL4Px5IYzmjWHfxBt9KncuUiQwTP7ChKlTdFxHXvsO0mWo
VtCyDmBT8DdDmPzE8fyOsbvVuU/bEBgFKj0zEqNr7+pPpPN+xTQEPoOiNfo5HGbv3T9+3MtD
owdZaUcqmg0GrlvwI8fg+3l1TnACm9ttW9y0A0RouG3EHV4q/ynnkzVz78xFQ3+VOvyX5c6O
IAlpI8pJtxF8zi30MQDvC3wB5V3t+4DvEb5ieLfxPAdo+ZUZh/hxIowmWiC4MMWNoZAc3PRj
sPOIXmFa8PPohu+wcPU5rEjVDs8enwQ3T0evuRVajUkOej9epquhD2k1CDIhFReAUbfB8Cub
6wn2U+7md00vrN4W+52+aXZ11xa4NJj+pgZ1yFliPedfNfgY+sz0LHqq8vfV3QjIuQIf20rr
4zueqWH6W+4RQMClUVIeLTgn4Pu7KxCXsGgDttvwcK0z3G0RPD2U/WHfro1DSVg54bH7Rpeo
Pmf/W6wJ0x8sGc1cSauPPyeWfP7iDCtOzf/Pf+R3ioxNGogQXiFij2HXmBMzAAAAAAAA
--------------ms080504080803050204050803--
