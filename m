Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33779 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbbLBNDg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 08:03:36 -0500
Received: by iouu10 with SMTP id u10so45397102iou.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 05:03:35 -0800 (PST)
Subject: Re: compression disk space saving - what are your results?
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565EEC1F.7070600@gmail.com>
Date: Wed, 2 Dec 2015 08:03:27 -0500
MIME-Version: 1.0
In-Reply-To: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080908090704060903090802"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080908090704060903090802
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 04:46, Tomasz Chmielewski wrote:
> What are your disk space savings when using btrfs with compression?
>
> I have a 200 GB btrfs filesystem which uses compress=3Dzlib, only store=
s
> text files (logs), mostly multi-gigabyte files.
>
>
> It's a "single" filesystem, so "df" output matches "btrfs fi df":
>
> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> (...)
> /dev/xvdb       200G  124G   76G  62% /var/log/remote
>
>
> # du -sh /var/log/remote/
> 153G    /var/log/remote/
>
>
>  From these numbers (124 GB used where data size is 153 GB), it appears=

> that we save around 20% with zlib compression enabled.
> Is 20% reasonable saving for zlib? Typically text compresses much bette=
r
> with that algorithm, although I understand that we have several
> limitations when applying that on a filesystem level.

This is actually an excellent question.  A couple of things to note=20
before I share what I've seen:
1. Text compresses better with any compression algorithm.  It is by=20
nature highly patterned and moderately redundant data, which is what=20
benefits the most from compression.
2. When BTRFS does in-line compression, it uses 128k blocks.  Because of =

this, there are diminishing returns for smaller files when using=20
compression.
3. The best compression ratio I've ever seen from zlib on real data is=20
about 65-70%, and that was using SquashFS, which is designed to take up=20
as little room as possible.
4. LZO gets a worse compression ratio than zlib (around 40-50% if you're =

lucky), but is a _lot_ faster.
5. By playing around with the -c option for defrag, you can compress or=20
uncompress different parts of the filesystem, and get a rough idea of=20
what compresses best.

Now, to my results.  These are all from my desktop system, with no=20
deduplication, and the data for zlib is somewhat outdated (I've not used =

it since LZO support stabilized).

For the filesystems I have on traditional hard disks:
1. For /home (mostly text files, some SQLite databases, and a couple of=20
git repositories), I get about 15-20% space savings with zlib, and about =

a 2-4$ performance hit.  I get about 5-10% space savings with lzo, but=20
performance is about 5-8% better than uncompressed.
2. For /usr/src (50/50 mix of text and executable code), I get about 25% =

space savings with zlib with a 5-7% hit to performance, and about 10%=20
with lzo with a 7% boost in performance relative to uncompressed.
3. For /usr/portage and /var/lib/layman (lots of small text files, a=20
number of VCS repos, and about 2000 compressed source archives), I get=20
about 25% space savings with zlib, with a 15% performance hit (yes,=20
seriously 15%), and with lzo I get about 25% space savings with no=20
measurable performance difference relative to uncompressed.

For the filesystems I have on SSD's:
1. For /var/tmp (huge assortment of different things, but usually=20
similar to /usr/src because this is where packages get built), I get=20
almost no space savings with either type of compression, and see a=20
performance reduction of about 5% for both.
2. For /var/log (Lots of text files (notably, I don't compress rotated=20
logs, and I don't have systemd's insane binary log files), I get about=20
30% space savings with zlib, but it makes the _whole_ system run about=20
5% slower, and I get about 20% space savings with lzo, with no=20
measurable performance difference relative to uncompressed.
3. For /var/spool (Lots of really short text files, mostly stuff from=20
postfix and CUPS), I actually see higher disk usage with both types of=20
compression, but almost zero performance impact from either of them.
4. For /boot (a couple of big binary files that already have built-in=20
compression), I see no net space savings, and don't have any numbers=20
regarding performance impact.
5. For / (everything that isn't on one of the other filesystems I listed =

above), I see about 10-20% space savings from zlib, with a roughly 5%=20
performance hit, and about 5-15% space savings with lzo, with no=20
measurable performance difference.


--------------ms080908090704060903090802
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTMwMzI3WjBPBgkq
hkiG9w0BCQQxQgRAzOiZ3wBrUtGvDR7wRivTeV2AO6zmIlkCXyPY30Gdycww50dvGNLbQFdJ
Itz8wX0DFNWsC8TUbGW+cKibKLIbbTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBd48tTupnTnR3cVWlsSJ8KtZ1ZVevHv9HYaJm3258gNaLoLFVN
juCBCZ6lTb1/xxbb+uO+LNh+PqZ/lNJNWjhpVE4mA3Ctg0tiO+Zz+7FsUx7uhH9nRTlDhVo+
ipEMJS/+iftxxbN902fYwqcd40tENQDJ4ZCc7rQAirlYmAiPTYAXUMQ/erwdE7qP3GqE4ojE
oOMVLATM6P8QKb1NXug/L4OUeOwloqkOT0f7AUxCCPOnHUNMzMJ+drG3DJdSXdd8r5VCWN8p
7/dLs9dmLQArYRkdtlxPP/fzRx7AsUPjfRrLJqStKqQ0hZzNnYPCiicD+CRwO1d6NvKM+CcX
CvCQgnOP1SchBOn6HUG9WC8QHEB6Lcn260l4hzE+SJj4oKgz5pIdV1n4LHvpnw7qiw4BbDzA
MqP2XHjZroHI7PRLVB1brRRZyDKQOnEQWIr/8fUcZqTylaliVJRvLW1cJcbDuQi6mcQ4ihIU
SoTY7M6G6MmYb/nt9c7bwCnQch/e4uAJ70P0AunDE3m6mnLOkaRQYqZS2vOi3baaSwc5te3Y
vAMSJtwLoJ7LvKYERYK6G3O7zQ5ZP65130KFmZKVvdgOsY7kuIPwmmEqDvfoVMAiN/Nrro2Y
eaO6nByuqk7Z+dFrOkiym7qV8ADkgcYsJOQzsdgYprynOjHNqARe29eHNgAAAAAAAA==
--------------ms080908090704060903090802--
