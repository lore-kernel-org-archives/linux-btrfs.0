Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34758 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbbHYPnQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:43:16 -0400
Received: by igui7 with SMTP id i7so14624423igu.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 08:43:15 -0700 (PDT)
Subject: Re: Btrfs tragedy: lack of space for metadata leads to loss of fs.
To: Marc MERLIN <marc@merlins.org>,
        =?UTF-8?Q?Miguel_Negr=c3=a3o?=
	<miguel.negrao-lists@friendlyvirus.org>
References: <loom.20150825T151154-787@post.gmane.org>
 <20150825145922.GE20179@merlins.org>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DC8D0E.802@gmail.com>
Date: Tue, 25 Aug 2015 11:43:10 -0400
MIME-Version: 1.0
In-Reply-To: <20150825145922.GE20179@merlins.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070805060808070603070702"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070805060808070603070702
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-25 10:59, Marc MERLIN wrote:
> On Tue, Aug 25, 2015 at 01:44:12PM +0000, Miguel Negr=E3o wrote:
>> Hi list,
>>
>> This weekend had my first btrfs horror story.
>>
>> system: 3.13.0-49-lowlatency, btrfs-progs v4.1.2
>
> Sorry to say, but that's a very old kernels with many btrfs bugs, some
> did lead to corruption.
>
>> A disclaimer: I know 3.13 is very out of date, but I the requirement o=
f
>> keeping kernel up to date clashes with my requirement of keeping a sta=
ble
>> system. At the moment I can't disturb my system as I'm doing important=
 work,
>
> Unfortunately you have conflicting goals.
>
>> upgrading kernel requires upgrading ubuntu, which will upgrade a lot o=
f
>> packages and might lead to problems which I don't have time to fix. On=
e
>
> You're doing it wrong :)
> Upgrade/compile your own kernel without upgrading the OS.
>
>> block group 32...... flags 36'). This is a OCZ vertex 3, a quite fast =
SSD.
>
> I've had 5 (yes 5, I replaced my drive 4 times) OCZ Vertex 4 drives, an=
d
> they all gave me corruption with btrfs on unclean power down. The last
> one didn't work any better, I just gave up and went to Samsung EVO 840
> and those have been fine.
Yeah, it's not just unclean power down that can cause this though, one=20
of my friends wouldn't believe me when I told him his Vertex 3 was the=20
cause of his problems till I did the following from a known good copy of =

SystemRescueCD (sda was his SSD):
dd if=3D/dev/urandom of=3D/dev/sda
dd if=3D/dev/zero of=3D/dev/sda
xxd dev/sda

and it returned thousands of blocks of non-zero data in just the first=20
16G.  I wouldn't trust an OCZ drive for anything except scratch space.=20
(Personally I'm a fan of Crucial SSD's due to their lower price point=20
than the Samsung and Intel SSD's but almost equivalent performance and=20
data integrity, but to each his own).


--------------ms070805060808070603070702
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTU0MzEwWjBPBgkq
hkiG9w0BCQQxQgRAtfb6WruFqRqZ7HUY6lP4YEsS/JlTzClxfNufvonE2FN1zuv4DBvsaQUV
WIi7UlLzuUaq21qNW8mfttnXc3t0WzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBaAV5eN2EwbiDUQWbfVDHvD+aRy469e+4QKzaG7VK616iV/M/R
PLAPpNvya5Hrv8p/JbSnv4E1hPjz/TXVjSxIekowEgVpN0jWChChLYaVYMTQ0Fh6gQDfIvwF
bCVwDVreOPr2alDN0lslbzDZ8qRKBTR43bxWjpyvoFv3yH8exB3I94CnSk9tjRG8KKQx6+HN
L/ws1jKnlEy6PeU+vKvkGvEFo85ifBVh5usdbgCBUhOW4BBBDCoaXAnA+CkvEPx5DjkdpL88
64aDi02kpzwGNcpKZLbO9lsL0bujK4iOBAeNImLLexh13gR+c+w9cw81wStrNt3NtpXvS0en
ZptXOb1oSfL7qOZRCMSE+voCD53CVgJrRM7vGi5+hrDVnIuDjIxdbsW0BZnTGdhJ0FJcJwXr
m18kgtnNPsVrYtorbAWpWQ1yuBu9cbl3rwFzvffYRGXEcQG5XXM8I3dNPFlDWNx2/gh8Wwc5
lqTVhrItlKw2qLJVa+72jO2980pv6xuE1uR2v3QeqGK06451Jr8xbfQjGGMC37YSOMFHJIUK
UHTegGa28lkXUNnvbyaHq8Pm1brDrAr1bReXv2gf8H2ECBCBVolpAjatuTQpjBfuKkvzKiFl
4WNNZh/OL1+rXxeUtACPr7BTXQdUJBOA4aThs1x06ceiPMA+DATZJgkF5gAAAAAAAA==
--------------ms070805060808070603070702--
