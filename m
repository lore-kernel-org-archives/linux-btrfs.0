Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36172 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552AbbJ0P1S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 11:27:18 -0400
Received: by ioll68 with SMTP id l68so226444480iol.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 08:27:17 -0700 (PDT)
Subject: Re: Bad fs performance, IO freezes
To: "cheater00 ." <cheater00@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com>
 <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com>
 <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
 <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
 <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
Cc: Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562F97B5.8000108@gmail.com>
Date: Tue, 27 Oct 2015 11:26:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080401040008060802070908"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080401040008060802070908
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-27 10:43, cheater00 . wrote:
> I have remounted without autodefrag and the issue keeps on happening.
OK, that at least narrows things down further.  My guess is the spikes=20
are utorrent getting a bunch of blocks at once from one place, and then=20
trying to write all of them at the same time, which could theoretically=20
cause a latency spike on any filesystem, and BTRFS may just be making it =

worse.
>
> On Tue, Oct 27, 2015 at 3:30 PM, cheater00 . <cheater00@gmail.com> wrot=
e:
>> Feel free to suggest a good 1.5m USB3 cable, too. Let's get rid of all=

>> the unknowns.
When it comes to external cables, I've had really good success with=20
Amazon's 'Amazon Basics' branded stuff.  It's usually some of the best=20
quality you can find for the price.  The 'Cable Matters' and 'Pluggable' =

brands also tend to be really good quality for the price.
>> On Tue, Oct 27, 2015 at 3:26 PM, cheater00 . <cheater00@gmail.com> wro=
te:
>>> If you can suggest a dual (or better yet quad) USB3 bay that can be
>>> bought on Amazon, I'll buy it now, and once that arrives, we can be
>>> sure it's not the JMicron chipset.
I don't really have any suggestions here.  Usually when I hook up an=20
external drive, it's to recover data from a friends computer, so I don't =

typically use a enclosure, but just use a simple adapter cable.  I would =

suggest looking for one advertising 'UAS' or 'UASP' support, as that's a =

relatively new standard for USB storage devices, and newer hardware=20
should be more reliable.  It's also notoriously hard to determine what=20
chipset a given model of external drive bay has (there are people I know =

who bought multiples of the same model and each one had a different=20
chipset internally), and to complicate matters, quite often the exact=20
same hardware gets marketed under half a dozen different names.  JMicron =

is popular because their chips are comparatively inexpensive, and while=20
I've not had good results with them, that doesn't mean that they are all =

bad (especially considering that they are highly configurable based on=20
how they are wired into the device, and not everyone who designs=20
hardware around them properly understands the implications of some of=20
the features).
>>>
>>> On Tue, Oct 27, 2015 at 3:22 PM, cheater00 . <cheater00@gmail.com> wr=
ote:
>>>> The (dual) HDD bay and the chipset are, according to lsusb:
>>>> Bus 002 Device 005: ID 152d:0551 JMicron Technology Corp. / JMicron
>>>> USA Technology Corp.
>>>> Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
>>>>
>>>> Not sure how to find out specific model numbers? I could open up the=

>>>> bay. OK I'll open up the bay.
>>>> Good thing I have just the right screwdriver. It's a JMS551, and jus=
t
>>>> for records sake, here's the manufacture info:
>>>>
>>>> JMS551
>>>> 1120 LGAA2 A
>>>> 572QV0024
>>>>
>>>> The laptop manual says it's either "Intel HM65 Express chipset with
>>>> NEC USB 3.0 (select models only)" or "Intel HM65 Express chipset".
>>>> Here are technical documents for my model:
>>>> Manual: http://docdro.id/hG627JM
>>>> "Intel chipset datasheet": http://docdro.id/yKRupYO
>>>> Service guide: http://docdro.id/AuDgUdE
>>>> Service guide, alt. ver.: http://docdro.id/WwQRpsH
 From what I can tell, you've got the one with the NEC USB 3.0 chip, I'm =

pretty cure that the HM65 doesn't have USB 3.0 itself.  FWIW, I've never =

personally had issues with NEC's USB 3.0 chips, but I've not had much=20
experience using systems with them either.
>>>>
>>>> FWIW I'm using one of the USB3 ports on the left. The ones on the
>>>> right are USB2.
>>>>
>>>> I've never used docdro.id so if it's not good let me know where to
>>>> upload the PDFs to.
>>>>
>>>> autodefrag is on, yes. But I have been having issues before turning =
it
>>>> on - I turned it on as a measure towards fixing the issues. I will
>>>> turn it off and remount, then report. But I don't think that should =
be
>>>> it. As you see the transfer speeds are minimal. They're *all* that's=

>>>> happening on the disk. Right now that's under 100 KB/sec and I'm sti=
ll
>>>> getting freezes albeit less. Also why would I be getting freezes whe=
n
>>>> the transfer speeds jump up - just for them to drop again? Hmm, mayb=
e
>>>> utorrent has some sort of scheduler that gets preempted while the
>>>> spike is happening, and some algorithm in it gets the wrong idea and=

>>>> turns some sort of flow control on, because it thinks it's hit some
>>>> sort of physical transfer speed barrier. Also notice the upload and
>>>> download both scale together, but that just might be how torrent
>>>> works, maybe it just tries to be fair i.e. only uploads as much as i=
t
>>>> downloaded (scaled by a constant).
Yeah, utorrent defaults to trying for a 1:1 ratio of uploads to=20
downloads (so in terms of viewing the group of clients downloading a=20
torrent as a network, it defaults to contributing as much bandwidth as=20
it uses).  This is pretty typical behavior for most torrent clients, and =

in fact downloading more than you upload for a torrent is generally=20
considered bad etiquette.
>>>>
>>>> The system is 32 bit because I installed ubuntu 6 one day and just
>>>> kept on upgrading. I keep on telling myself I'll update to 64 bits,
>>>> one of these days. But this laptop only has 8 gigs of ram, so no rea=
l
>>>> reason to upgrade to 64 bit anyways. It's not like I need firefox to=

>>>> be able to eat 8 gb of ram whereas right now it can only eat 4. Ther=
e
>>>> is no simple upgrade path that I know of so it's either a fresh
>>>> install or doing something like this: http://www.ewan.cc/?q=3Dnode/1=
32
>>>> -- I keep telling myself /one of these days/...
That's entirely understandable.  It's never been easy to do an in-place=20
upgrade from 32 to 64 bit.  It's worth noting that while it's not easy=20
to do a full upgrade to 64-bit, it is relatively easy to run a 32-bit=20
userspace on a 64-bit kernel (at least, it should be, it's been so long=20
since I used Ubuntu for anything that I really don't have much frame of=20
reference regarding it beyond the fact that it's based on Debian).
>>>>
>>>> On Tue, Oct 27, 2015 at 2:30 PM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>> On 2015-10-27 09:00, Henk Slager wrote:
>>>>>>
>>>>>> I don't have a lot experience with autodefrag, but as indicated by=

>>>>>> Austin, expect a lot of full rewrites of files that are relatively=

>>>>>> slowly filled up by a torrent client, starting with a sparse file.=
 So
>>>>>> 1st advice would be to remove this option and run it as crontask a=
t
>>>>>> particular times.
>>>>>>
>>>>>> What SATA-USB bridge is between the harddisk and the PC motherboar=
d ?
>>>>>
>>>>> I hadn't thought of this, but the specific adapter being used for t=
he disk
>>>>> can have a lot of impact on how it preforms.  I've personally had l=
ots of
>>>>> issues with JMicron chipsets (ranging from latency issues like what=
 you are
>>>>> seeing to sever data corruption), but have found that ASMedia ones =
tend to
>>>>> be pretty much rock solid reliable and have good performance (altho=
ugh I
>>>>> think they only do USB 3.0 adapters).
>>>>>>
>>>>>> Also what USB host chipset is on the PC motherboard ?
>>>>>
>>>>> If it's a Intel motherboard, the USB 2.0 ports are probably routed =
through
>>>>> on-board hubs to the ports provided by whatever Intel calls their e=
quivalent
>>>>> of the south bridge these days, and the USB 3.0 ports are probably =
a mix of
>>>>> Intel and ASMedia XHCI controllers (ASMedia was one of the first co=
mpanies
>>>>> to do an inexpensive standalone XHCI chip, so they're relatively po=
pular for
>>>>> extra USB 3.0 ports).  FWIW, the first generation of Intel XHCI chi=
ps had
>>>>> some issues with older Linux kernels, although IIRC those issues we=
re along
>>>>> the lines of a port just disappearing after disconnecting whatever =
was
>>>>> connected to it.
>>>>>>
>>>>>> Why don't you run 64-bit Ubuntu on this core i7 ?
>>>>>
>>>>> 64 versus 32 bit shouldn't cause anything like this to happen (alth=
ough, if
>>>>> it can be proven that it does, then that is a serious bug that need=
s to be
>>>>> fixed).  That said, unless you have some desperate need to be runni=
ng 32-bit
>>>>> only, you should seriously look into updating to a 64-bit version, =
your
>>>>> whole system should run faster, and Ubuntu has really good 32-bit
>>>>> compatibility in the 64-bit version (which is part of why it's popu=
lar as a
>>>>> support target for third party software like Steam).
>>>>>
>>>>>>
>>>>>>
>>>>>> On Tue, Oct 27, 2015 at 12:44 PM, Austin S Hemmelgarn
>>>>>> <ahferroin7@gmail.com> wrote:
>>>>>>>
>>>>>>> On 2015-10-26 22:00, cheater00 . wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>> currently my computer freezes every several seconds for half a s=
econd
>>>>>>>> or so. Using it feels like I'm playing musical chairs with the k=
ernel.
>>>>>>>> I have just one download happening on utorrent right now - this =
is
>>>>>>>> what the graph looks like:
>>>>>>>> http://i.imgur.com/LqhMtrJ.png
>>>>>>>> and every time a new spike happens, a freeze happens just before=

>>>>>>>> that... that's the only time those freezes happen, too.
>>>>>>>>
>>>>>>> Do you have the 'autodefrag' mount option enabled?  If it is turn=
ed on,
>>>>>>> then
>>>>>>> that may be the problem.  Most bittorrent clients pre-allocate th=
e space
>>>>>>> for
>>>>>>> a download, then write each block directly into the location it's=

>>>>>>> supposed
>>>>>>> to be in the resultant download, which means depending on how it'=
s
>>>>>>> pre-allocating the space, that you end up with a large number of =
randomly
>>>>>>> ordered writes into a single file, which in turn will trigger the=

>>>>>>> autodefrag
>>>>>>> code, which can cause latency spikes when you're also hitting the=
 disk at
>>>>>>> the same time.



--------------ms080401040008060802070908
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI3MTUyNjQ1WjBPBgkq
hkiG9w0BCQQxQgRAjMmnuMjNtWWxKNRP9Tnyq8s4R5loQt6+gRsLCq3FzO/ePne3+Y2LzsN+
9CHpSqyePf3ZtlHReA+0UHwUavWHtTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBpaBkSo8v+yJCJNu65VDhLSvc5phseB3aNhIG1UNFcflMHLae5
W1sy0SL6rIGMcc0VTm+IIWSvWYOrvxde9+jClU07TkHUNd0qWKXCSDn2yU/XPIwrFtD/Fk0x
/vQP/Q62H4luVwMBFEej8Gb22jPJXJUBLA5w7zoRDx5CBsI/cq0Fuiq2T2hanDoHpL1sNANT
WpLUJXbh7xIl+rASOtb2aCHoobMDhoZRKy5f5jAGIQhtFED7kg/g4IZtxN5gh6P0n+1KiIRE
AwKa9hyOCI+mactU7tFOAhWMEoG2+UbJdUFONwgQSQLHno93qC12H5J9XOlzPPcvMQTbC3mU
TquJXwmJU4zzlQ3NKy7XBZ9yqAPaEnuZPA0DEDPNW7O1Cwjew8/xOgEPx62QQ1EVnmBBhJ6c
D/0CExlALRKtU+OfgxuB+RVcqfuS/rjYOB0v2mSeQUmOLyPU9qZeYjWyqmC3OkUX8KJ8EJll
zGPKs5mRQiHa3b1P3IFy2mbJ5bUF/Ft3B62dI1osxdd+09lG9YK26LCw6NFmh60VAxZy6OQQ
FwseGIXGhozcg4/5YaJamyQz+LkVWObWU6b4ceExmCGTSfDlOqs21ADYOqKL7ypEr5T3wIbm
QI+NgWGrUSiB0Fw9j/xe07wHeEjqiAa2GEf8KQS5Vfnc+Ij1cNo6T651BQAAAAAAAA==
--------------ms080401040008060802070908--
