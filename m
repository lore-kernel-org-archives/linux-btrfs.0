Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:37875 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbbJSTsp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 15:48:45 -0400
Received: by igbhv6 with SMTP id hv6so60438941igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 12:48:44 -0700 (PDT)
Subject: Re: btrfs autodefrag?
To: Erkki Seppala <flux-btrfs@inside.org>, linux-btrfs@vger.kernel.org
References: <56227910.7000208@gmail.com>
 <CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
 <20151018144015.GV25907@carfax.org.uk> <m49zizfbcsb.fsf@coffee.modeemi.fi>
 <5624DA83.40200@gmail.com> <m49si56bzv3.fsf@coffee.modeemi.fi>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562548F5.4050301@gmail.com>
Date: Mon, 19 Oct 2015 15:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <m49si56bzv3.fsf@coffee.modeemi.fi>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060105040307050801070006"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060105040307050801070006
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 12:13, Erkki Seppala wrote:
> Austin S Hemmelgarn <ahferroin7@gmail.com> writes:
>
>> And that is exactly the case with how things are now, when something
>> is marked NOCOW, it has essentially zero guarantee of data consistency=

>> after a crash.
>
> Yes. In addition to the zero guarantee of the data validity for the dat=
a
> being written into, btrfs also doesn't give any guarantees for the rest=

> of the data, even if it was perfectly quiescent, but was just marked CO=
W
> at the time it was written :).
Assuming you do actually mean COW and not NOCOW, in which case there is=20
a guarantee that the data will either:
1. Match the original data prior to the write.
2. Match the data that was written.
or, if you are using only single copies of the metadata blocks and the=20
system crashes exactly during a write to a metadata block:
3. Everything under that metadata block will become inaccessible, and=20
require usage of btrfs-progs to recover.

In the case of NOCOW however, there is absolutely no such guarantee=20
(just like ext4 for example can not provide such a guarantee), and any=20
of the above could be the case, or any arbitrary portion of the new data =

could have been written.
>>   As things are now though, there is a guarantee that
>> you can still read the file, but using checksums like you suggest
>> would result in it being unreadable most of the time, because it's
>> statistically unlikely that we wrote the _whole_ block (IOW, we can't
>> guarantee without COW that the data was completely written) because:
>
> Well, the amount of data being written at any given time is very small
> compared to the whole device. So it's not all the data that is at risk
> of having the wrong checksum. Given how small blocks are (4k) I really
> doubt that the likelihood of large amounts of data remaining unreadable=

> would be great.
That very much depends on how you are using things.for many of the types =

of things which NOCOW should be used for, directio and AIO are also very =

commonly used, and those can write chunks much bigger than BTRFS's block =

size in one go.
>
> However, here's a compromise: when detecting an error on a COW file,
> instead of refusing to read it, produce a warning to the kernel log. In=

> addition, when scrubbing it, the last resort after trying other copies
> the checksum could simply be repaired, paired with an appropriate log
> message. Such a log message would not indicate that the data is wrong,
> but that the system administrator might be interested in checking it,
> for example against backups, or by perhaps running a scrub within the
> virtual machine.
In this case I'm assuming you mean NOCOW instead of COW, as the=20
corruption can't be detected in a NOCOW file by BTRFS.

In a significant majority of cases, it is actually better to return no=20
data than to return known corrupted data (think medical or military=20
applications, in those kind of cases it's quite often worse to act on=20
incorrect data than it is to not act at all).  Disk images for virtual=20
machines are one of the very few rare cases where this is not true,=20
simply because they can usually correct the corruption themselves.
>
> If the scrub would say everything is OK, then certainly everything woul=
d
> be OK.
That's a _very_ optimistic point of view to take, and doesn't take into=20
account software bugs, or potential hardware problems.
>
>> a. While some disks do atomically write single sectors, most don't,
>> and if the power dies during the disk writing a single sector, there
>> is no certainty exactly what that sector will read back as.
>
> So it seems that the majority vote is to not to provide a feature to th=
e
> minority.. :)
For something that provides a false sense of data safety and is=20
potentially easy to shoot yourself in the foot with?  Yes we will almost =

certainly not provide it.  If, however, you wish to write a patch to=20
provide such a feature (or pay someone to do so for you), there is=20
nothing stopping you from doing so, and if it's something that people=20
actually want, then it will likely end up included.
>> b. Assuming that item a is not an issue, one block in BTRFS is usually=

>> multiple sectors on disk, and a majority of disks have volatile write
>> caches, thus it is not unlikely that the power will die during the
>> process of writing the block.
>
> I'm not at all familiar with the on-disk structure of Btrfs, but it
> seems that indeed the block size is 16 kilobytes by default, so the ris=
k
> of one of the four device-blocks (on modern 4kB-sector HDDs) being
> corrupted or only a set of them having being written is real. But,
> there's only so much data in-flight at any given time.
While the default is usually 16k, there are situations where it may be=20
different, for example if the system has a page size greater than 16k=20
(some ARM64, PPC, and MIPS systems use 64k pages), or if it's a small=20
filesystem (in which case the blocks will be 4k).

It is also worth noting that while most 'modern' HDDs use 4k sectors:
1. They are still vastly outnumbered by older HDDs that use 512 byte=20
sectors.
2. A significant percentage of them use 512 byte virtual sectors (that=20
is, they expose a 512 byte sector based interface to the OS, but use 4k=20
sectors internally, which has potentially dangerous implications if=20
their firmware is not well written).
3. SSD's internally use much bigger block sizes (the smallest erase=20
block size that I've personally seen in an SSD is 1M, usually it's 2M or =

4M).  The implications of this are pretty scary for cheap SSD's (and OCZ =

SSD's, which are not by any means cheap) that don't include=20
super-capacitors to ensure that power-loss in the middle of a write=20
won't interrupt the write.
4. I've heard rumors of some exotic ones out there that use 64k sectors=20
on disk.
>
> I did read that there are two checksums (on Wikipedia,
> Btrfs#Checksum_tree..): one per block, and one per a contiguous run of
> allocated blocks. The latter checksum seems more likely to be broken,
> but I don't see why in that case the per-block checksums (or one of the=

> two checksums I proposed) couldn't be referred to. This is of course
> because I don't understand much of the Btrfs on-disk format, technical
> feasibility be damned :).
>
> I understand that the metadata is always COW, so that level of
> corruption cannot occur.
Oh, it can occur in reality, it's just a _statistical_ impossibility.
>> c. In the event that both items a and b are not an issue (for example,=

>> you have a storage controller with a non-volatile write cache, have
>> write caching turned off on the disks, and it's a smart enough storage=

>> controller that it only removes writes from the cache after they
>> return), then there is still the small but distinct possibility that
>> the crash will cause either corruption in the write cache, or some
>> other hardware related issue.
>
> However, should this not be the case, for example when my computer is
> never brought down abruptly, it could still be valuable information to
> see that the data has not changed behind my back.
Well yes, but if that is the case, then you shouldn't be worrying about=20
anything, as un-mounting the filesystem requires that there be no open=20
files on it, and it explicitly flushes all the buffered writes in RAM=20
out to disk.

On the other hand, if you're worried about your disk or other hardware=20
having issues, then you should be seriously considering verifying that=20
it works correctly, and replacing it if it doesn't, and just using BTRFS =

on it is not a safe or even remotely reliable way to detect hardware=20
failures.
>
> I understand it is the prime motivation behind btrfs scrubbing in any
> case; otherwise there could be a faster 'queue a verify after a write'
> that would never scrub the same data twice.
Actually, having the ability to tell it to verify a block after writing=20
it would potentially be a very useful feature for unreliable hardware,=20
assuming you're willing to take the performance penalty for the=20
additional read on every write.



--------------ms060105040307050801070006
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTk0ODA1WjBPBgkq
hkiG9w0BCQQxQgRAZXzub4bEcpn5bpfH00M2ShQ7r0i12PQnIHRK10BR/Xv4rOMM5jnbOpui
oWthy3/xv71r7bNzZS0ck2GB5+4fWDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA5DecCyo3tZW4svwjcJy9QyIJ/pppc1Zu6NhRaecSlqkp1WKbF
JLDdo9bCuGQ0v8VfhwxQw3ez66PEEqn9GNJGCk8HT7q4YmkJZLHrUuW5ogK9vz9pATVw5lHn
n2VHMjeeT44oXG2v37QqWTvl86R+OtUmAlLZTWPrY/8stsfLJtwyzWCUcbooCWTfVIeQzMQU
JdXREa2Ubk9xHSu3qJ+K41iSqARBBFqN/lKuL2EOiysIrOPxE++/hHTOVMtGr0gjhTiu5nlW
lrXwIwAR49HzWzQLN/HwAyeetQOq+cE6wuxt9eRdAZ0nL+T9a7RRx99/T2N/GjNpiwJdFAgu
xGbYYgWRg8NpKxX8fBE62D3aA/WAAGFJjr5gXgZh9HNIu624yVQ4Ir0+eY2n3Tu1h6+PVhwG
e+q+aURaOz95Vr28SuHeyKkJNFi4MkLzRpLvibywXVuJeX7stZUOCKy2xNbBGzeE7pf0CiIY
QCkjEqqHCV5aCpawYzE2CP5mZQ1GQbbSIC9QvV6ox2B3EGCrTKufSRhrdIvfFRM7dNbEgCdx
2pnw/DG4xHGnSjefHWf0aWGpiLP+tYeMONF+iR5AK6md0M6iNiSktv9YJCztxYKylfkEvpIc
1iHIZuUDF4VVM3EG6TDOsMEg5dzWxuaHtHUUOOkx8NTsk9F7vLw2XocgpQAAAAAAAA==
--------------ms060105040307050801070006--
