Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36190 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbIPTgg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 15:36:36 -0400
Received: by igcrk20 with SMTP id rk20so41627836igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 12:36:36 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <A4269DC6-6CD6-4E8C-B3C9-5F5DDBE86911@up4.com> <55F9B357.4070505@gmail.com>
 <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F9C4BD.5040100@gmail.com>
Date: Wed, 16 Sep 2015 15:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <54A9EC91-FDFD-44A8-97B9-7347A89FA415@up4.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060709030707020901070200"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060709030707020901070200
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-16 15:04, Vincent Olivier wrote:
>
>> On Sep 16, 2015, at 2:22 PM, Austin S Hemmelgarn <ahferroin7@gmail.com=
> wrote:
>>
>> On 2015-09-16 12:51, Vincent Olivier wrote:
>>> Hi,
>>>
>>>
>>>> On Sep 16, 2015, at 11:20 AM, Austin S Hemmelgarn <ahferroin7@gmail.=
com> wrote:
>>>>
>>>> On 2015-09-16 10:43, M G Berberich wrote:
>>>>> Hello,
>>>>>
>>>>> just for information. I stumbled about a rant about btrfs-performan=
ce:
>>>>>
>>>>>   http://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs=
-for-oltp
>>> I read it too.
>>>> It is worth noting a few things that were done incorrectly in this t=
esting:
>>>> 1. _NEVER_ turn off write barriers (nobarrier mount option), doing s=
o subtly breaks the data integrity guarantees of _ALL_ filesystems, but e=
specially so on COW filesystems like BTRFS.  With this off, you will have=
 a much higher chance that a power loss will cause data loss.  It shouldn=
't be turned off unless you are also turning off write-caching in the har=
dware or know for certain that no write-reordering is done by the hardwar=
e (and almost all modern hardware does write-reordering for performance r=
easons).
>>> But can the =E2=80=9Cnobarrier=E2=80=9D mount option affect performan=
ces negatively for Btrfs (and not only data integrity)?
>> Using it improves performance for every filesystem on Linux that suppo=
rts it.  This does not mean that it is _EVER_ a good idea to do so.  This=
 mount option is one of the few things on my list of things that I will _=
NEVER_ personally provide support to people for, because it almost guaran=
tees that you will lose data if the system dies unexpectedly (even if it'=
s for a reason other than power loss).
> OK fine. Let it be clearer then (on the Btrfs wiki): nobarrier is an ab=
solute no go. Case closed.
 From the https://btrfs.wiki.kernel.org/index.php/Mount_options
NOTE: Using this option greatly increases the chances of you=20
experiencing data corruption during a power failure situation. This=20
means full file-system corruption, and not just losing or corrupting=20
data that was being written during a power cut or kernel panic.

It could be a bit clearer, but it's pretty well spelled out.
>>>> 2. He provides no comparison of any other filesystem with TRIM suppo=
rt turned on (it is very likely that all filesystems will demonstrate suc=
h performance drops.  Based on that graph, it looks like the device doesn=
't support asynchronous trim commands).
>>> I think he means by the text surrounding the only graph that mentions=
 TRIM that this exact same test on the other filesystems he benchmarked y=
ield much better results.
>> Possibly, but there are also known issues with TRIM/DISCARD on BTRFS i=
n 4.0.  And his claim is still baseless unless he actually provides refer=
ence for it.
> Same as above: TRIM/DISCARD officially not recommended in production un=
til further notice?
TRIM/DISCARD do work, it's just that they don't work to the degree they=20
are expected to, there's some cases where BTRFS doesn't issue a discard=20
when it should, and fstrim doesn't properly trim everything.
>>>> 3. He's testing it for a workload is a known and documented problem =
for BTRFS, and claiming that that means that it isn't worth considering a=
s a general usage filesystem.  Most people don't run RDBMS servers on the=
ir systems, and as such, such a workload is not worth considering for mos=
t people.
>>> Apparently RDBMS being a problem on Btrfs is neither known nor docume=
nted enough (he=E2=80=99s right about the contrast with claiming publicly=
 that Btrfs is indeed production ready).
>> OK, maybe not documented, but RDBMS falls under 'Large files with high=
ly random access patterns and heavy RMW usage', which is a known issue fo=
r BTRFS, and also applies to VM images.
> This guy is no idiot. If it wasn=E2=80=99t clear enough for him. It=E2=80=
=99s not clear enough period.
 From https://btrfs.wiki.kernel.org/index.php/Gotchas
Fragmentation
Files with a lot of random writes can become heavily fragmented (10000+=20
extents) causing trashing on HDDs and excessive multi-second spikes of=20
CPU load on systems with an SSD or large amount a RAM.
On servers and workstations this affects databases and virtual machine=20
images.
The nodatacow mount option may be of use here, with associated gotchas.
On desktops this primarily affects application databases (including=20
Firefox and Chromium profiles, GNOME Zeitgeist, Ubuntu Desktop Couch,=20
Banshee, and Evolution's datastore.)
Workarounds include manually defragmenting your home directory using=20
btrfs fi defragment. Auto-defragment (mount option autodefrag) should=20
solve this problem in 3.0.
Symptoms include btrfs-transacti and btrfs-endio-wri taking up a lot of=20
CPU time (in spikes, possibly triggered by syncs). You can use filefrag=20
to locate heavily fragmented files (may not work correctly with=20
compression).
>>>> His points about the degree of performance jitter are valid however,=
 as are the complaints of apparent CPU intensive stalls in the BTRFS code=
, and I occasionally see both on my own systems.
>>> Me too. My two cents is that focusing on improving performances for B=
trfs-optimal use cases is much more interesting than bringing new feature=
s like automatically turning COW off for RDBMS usage or debugging TRIM su=
pport.
>> It depends, BTRFS is still not feature complete with the overall inten=
t when it was started (raid56 and qgroups being the two big issues at the=
 moment), and attempting to optimize things tends to introduce bugs, whic=
h we have quite enough of already without people adding more (and they st=
ill seem to be breeding like rabbits).
> I would just like a clear statement from a dev-lead saying : until we a=
re feature-complete (with a finite list of features to complete) the focu=
s will be on feature-completion and not optimizing already-implemented fe=
atures. Ideally with an ETA on when optimization will be more of a priori=
ty than it is today.
As of right now, the list as far as I know is (in no particular order):
* working raid5/6
* n-copy replication (ie, three or more copy replication)
* qgroups
* improved read-balancing (technically an optimization)
* proper swap file support
* better random-write performance (again, optimization)
* online fsck (not scrub, but actual fsck)
* in-band data de-duplication
* various code cleanups
* many more things listed on the wiki
>> That said, my systems (which are usually doing mostly CPU or memory bo=
und tasks, and not I/O bound like the aforementioned benchmarks were test=
ing) run no slower than they did with ext4 as the main filesystem, and in=
 some cases work much faster (even after averaging out the jitter in perf=
ormance).  Based on this, I wouldn't advocate it for most server usage (e=
xcept possibly as the root filesystem), but it does work very well for mo=
st desktop usage patterns and a number of HPC usage patterns as well.
> See, this is interesting: I=E2=80=99d rather have a super fast and disc=
ardable SSD F2FS/ext4 root with a large Btrfs RAID for (NAS) server usage=
=2E Does your non-advocacy of Btrfs for server usage include a <10 user S=
amba NAS ?
If it's light usage, and you keep the softwarae running it up to date=20
(and make sure you have other backups), this should do just fine.  By=20
server usage I meant large scale deployment with very big volumes of=20
critical data.
> Are more details about the Facebook deployment going to be available so=
on ? I=E2=80=99m very curious about this.
I really have no idea about this.




--------------ms060709030707020901070200
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE2MTkzNjI5WjBPBgkq
hkiG9w0BCQQxQgRAsVU5xS/gnHLiEYOhKG9Z5Bb9ZO5l38dZMsyAS/nbbi3Nffb2LZ+8B9BL
AAH0uJ89dlFlYo4KEQxfOY0t9luDszBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAFyQVW+KbuwgDbowXXVsurAAjJDoTtcvPCvTHxem4QPvT/RZPV
rgcCfDAgIeZX+85shDrsosL/r5rwmfxJ1SBQchc04HstA8CmJ/IbUILQgBQkMTceAPoh9wGJ
ARtiB86o08cKsxfFfmq/4v6SPKFlr2n2mgW2z8Il1IKIhrY39X469os+6B6J0GS/CR1jpNAv
oaohAC0v+eN0q+q2qU2O06DmYaYM0ZTN4aCnNo5SNhQ4Aa9otGUufLlqz2byeoeRtXmAncK8
DRmjYtD7Y62wyOhgmHHDBpjSwTXEZYXnNwSA0ds08o2MzqA9SZRoQlt0uQBDGs9eQGM1QYCP
yZRA/JeWT3/h1i71qNWWY5h9c+5L9sQXYgy63hPftFvkwRuDP4wHC9fXsOydePCeTTeUxxHo
I2IqaxpK3kBglyTp14+Xda0v3/i4cUt+YRlcTUnB1evoOmhoO6byrVZRe4Bri84ibycyAcTo
TkrjJgQE2jiLH4UTYbOOrhFxh7GnV8uBIb35glNgJYNg9mBCqSB40CBG0tiE6Vgk6yz1VT3D
kSVhD2B6njZEwR1zAydYt1hFGHuxcaedWxESo9EZa5lzQKzppzknMEhhklk7OsDRGtFyNgw5
S/EBsQzFHuT8GMGDFWsTKG/U7fs2Ww4HLkP0/gmG2C/Rjz8GN9wnwM+0ZAAAAAAAAA==
--------------ms060709030707020901070200--
