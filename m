Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.no-junkemail.net ([69.65.24.131]:56304 "EHLO
	mx1.no-junkemail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3JOFFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 01:05:25 -0400
Received: from c-67-168-202-12.hsd1.or.comcast.net ([67.168.202.12]:65174 helo=aluminum.mersenne.com)
	by shared24.no-wires.net with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.80.1)
	(envelope-from <dhm@mersenne.com>)
	id 1VVwoq-0001ch-Px
	for linux-btrfs@vger.kernel.org; Tue, 15 Oct 2013 00:05:21 -0500
Message-ID: <525CCD11.3030203@mersenne.com>
Date: Mon, 14 Oct 2013 22:05:21 -0700
From: David Madden <dhm@mersenne.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
References: <525CBF0D.1020609@mersenne.com> <20131015105306.6a74ec5c@natsu>
In-Reply-To: <20131015105306.6a74ec5c@natsu>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070003010507020307040905"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070003010507020307040905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 14-Oct-2013 21:53 , Roman Mamedov wrote:
> Sure, that's one of the more awesome uses of btrfs.
>=20
> But keep in mind that old snapshots on the same FS are not to be
> used instead of a proper backup to external media/servers. If a
> block happened not to change for a year, and it gets damaged on
> disk, it will become damaged in all the snapshots all the way back
> to a year ago, and you lose that data.

I haven't looked at the wiki carefully enough to understand this, but
could one reasonably back up the snapshots of one BTRFS filesystem to
an independent BTRFS filesystem, in a more efficient way than just
dump/restore or cpio or something?

It sounds like you could rely on on-the-fly deduping to save space on
the backup filesystem, but you'd still be reading the whole source
snapshot tree and sending it to be deduped/written.  Seems like you
could improve things by just pulling the changed blocks from the
snapshot to the previous snapshot, which would (I guess) be the only
blocks actually _in_ the snapshot.

I guess what would really help is a "Best Practices Guide for BTRFS
Snapshotting and Backup."  Does anything like that exist?

Thanks,
- --=20
Mersenne Law LLC  =B7  www.mersenne.com  =B7  +1-503-679-1671
- - Small Business, Startup and Intellectual Property Law -
1500 SW First Ave. =B7 Suite 1170 =B7 Portland, Oregon  97201
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.20 (Darwin)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSXM0RAAoJEIQakGgVoKPCbNUP/RppplehqwASZXuIHcVGZBW/
4Q0sKcA19O4VVW8/Byy5Wa1cH3DHf24X4S8IHdZIvdn30EfYNI7q489ldmwQk9h8
To2EdsbpG9VlRWQ6W3zSv1iwqp1i/1W1miB6dkk4hHIEZ64BilaFyKInuCJCdS1T
anQFmFBUMGbMGdMXbIxrLgHhwYr7VSyp4RXxtCspeQHENT1zUiy6tyzEDqoP5vf+
ZDScBXK8G/MFijQTr6BWfCyiuS3OFostCp9dITmwNtLc194Ae/TDF7+ZNo/CzpOy
uP4pEZDPBYraEEcZBeRm5Jefa6VPkr16aoiJKjEH0StHimuHDNX17epgLTqSJx+J
JN0AJoxLxHQa7A8ny3aOzIjibKGP0Aa8KBfl6saRD8DMFtILHLMPCUOJ+l16Pcj/
gfipOZEpiBDHY4EIzYJRq/yYMHmw5SrvZeoPKdIPgDjJ7ovB9fteTwmLVSaiccM0
nd7TTMYiqm6PPnh7FEZWopfMEvx35LSxxI5Q6nuNqgQ33EgtYtM5yJC1cISJH1gf
HwQWmr2yqwZ/xgEQc0jI4LO6ISTx4xsY0NKM5aUr6ayzbmE5kRRfnNkUKpDd8by9
CpuFg898XIO+9Cd9do0MvLjVxg62WU8YxPiC+bcwc5tGKAiVjQaTeTyfYrLDmGaj
sGCmWIXC8dGrrqsaGthw
=3DioaG
-----END PGP SIGNATURE-----


--------------ms070003010507020307040905
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIILTDCC
BRowggQCoAMCAQICEG0Z6qcZT2ozIuYiMnqqcd4wDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMTEwNDI4MDAwMDAwWhcNMjAwNTMwMTA0ODM4WjCBkzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJKEhFtLV5jUXi+LpOFAyKNTWF9mZfEyTvefMn1V0HhMVbdClOD5J3EHxcZppLkyxPFA
GpDMJ1Zifxe1cWmu5SAb5MtjXmDKokH2auGj/7jfH0htZUOMKi4rYzh337EXrMLaggLW1DJq
1GdvIBOPXDX65VSAr9hxCh03CgJQU2yVHakQFLSZlVkSMf8JotJM3FLb3uJAAVtIaN3FSrTg
7SQfOq9xXwfjrL8UO7AlcWg99A/WF1hGFYE8aIuLgw9teiFX5jSw2zJ+40rhpVJyZCaRTqWS
D//gsWD9Gm9oUZljjRqLpcxCm5t9ImPTqaD8zp6Q30QZ9FxbNboW86eb/8ECAwEAAaOCAUsw
ggFHMB8GA1UdIwQYMBaAFImCZ33EnSZwAEu0UEh83j2uBG59MB0GA1UdDgQWBBR6E04AdFvG
eGNkJ8Ev4qBbvHnFezAOBgNVHQ8BAf8EBAMCAQYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNV
HSAECjAIMAYGBFUdIAAwWAYDVR0fBFEwTzBNoEugSYZHaHR0cDovL2NybC51c2VydHJ1c3Qu
Y29tL1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGljYXRpb25hbmRFbWFpbC5jcmwwdAYI
KwYBBQUHAQEEaDBmMD0GCCsGAQUFBzAChjFodHRwOi8vY3J0LnVzZXJ0cnVzdC5jb20vVVRO
QWRkVHJ1c3RDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1
c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQCF1r54V1VtM39EUv5C1QaoAQOAivsNsv1Kv/av
QUn1G1rF0q0bc24+6SZ85kyYwTAo38v7QjyhJT4KddbQPTmGZtGhm7VNm2+vKGwdr+XqdFqo
2rHA8XV6L566k3nK/uKRHlZ0sviN0+BDchvtj/1gOSBH+4uvOmVIPJg9pSW/ve9g4EnlFsjr
P0OD8ODuDcHTzTNfm9C9YGqzO/761Mk6PB/tm/+bSTO+Qik5g+4zaS6CnUVNqGnagBsePdIa
XXxHmaWbCG0SmYbWXVcHG6cwvktJRLiQfsrReTjrtDP6oDpdJlieYVUYtCHVmdXgQ0BCML7q
peeU0rD+83X5f27nMIIGKjCCBRKgAwIBAgIQe0M2gANgSzQ1kygHi18BPzANBgkqhkiG9w0B
AQUFADCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxOTA3BgNVBAMTMENP
TU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xMzAy
MTEwMDAwMDBaFw0xNjAyMTEyMzU5NTlaMIIBPjELMAkGA1UEBhMCVVMxEzARBgNVBBETCjk3
MjAxLTU4ODExCzAJBgNVBAgTAk9SMREwDwYDVQQHEwhQb3J0bGFuZDETMBEGA1UECRMKU3Vp
dGUgMTE3MDEdMBsGA1UECRMUMTUwMCBTVyBGaXJzdCBBdmVudWUxGTAXBgNVBAoTEE1lcnNl
bm5lIExhdyBMTEMxGjAYBgNVBAsTEUludGVybmV0IFNlY3VyaXR5MTYwNAYDVQQLEy1Jc3N1
ZWQgdGhyb3VnaCBNZXJzZW5uZSBMYXcgTExDIEUtUEtJIE1hbmFnZXIxHzAdBgNVBAsTFkNv
cnBvcmF0ZSBTZWN1cmUgRW1haWwxFTATBgNVBAMTDERhdmlkIE1hZGRlbjEfMB0GCSqGSIb3
DQEJARYQZGhtQG1lcnNlbm5lLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
ALBRjsK5wH1EGDHuuc6l+sDExd5y3NIIUmhCCoLDYm0pmiP2xYUU8+XG+TEfkhKvkD9nGMHI
WQTr77i4lfsT1s7WxEYB98ksJPQdSUsbtwXzsXGxJVnrA+7shMSjFOwK8TgFBY7jYmg0bRSD
JJ3ZGVIXj6yAUquRknYMubEJ0GvrA2NsfzRx2El/YKOEDg7CRRlHhr6Zw6sGm3vK9RSL8x7L
RlJdfCVOOCNyezJSeItpDNELvtBqInKfLe+X5kuNcZNJBG6o9MZE02gxCbToAVdjjmEalKhD
4RlfXDtW+N93cF+ScSH8rr15JQNfZUWNr2TZ0fKLfJsTl6eer0S14S0CAwEAAaOCAcowggHG
MB8GA1UdIwQYMBaAFHoTTgB0W8Z4Y2QnwS/ioFu8ecV7MB0GA1UdDgQWBBQ4x7EXcMqfR73w
dfzsxXb+I8FhfjAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggr
BgEFBQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEF
BQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwVwYDVR0fBFAwTjBMoEqgSIZG
aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPQ2xpZW50QXV0aGVudGljYXRpb25hbmRT
ZWN1cmVFbWFpbENBLmNybDCBiAYIKwYBBQUHAQEEfDB6MFIGCCsGAQUFBzAChkZodHRwOi8v
Y3J0LmNvbW9kb2NhLmNvbS9DT01PRE9DbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVt
YWlsQ0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wGwYDVR0R
BBQwEoEQZGhtQG1lcnNlbm5lLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAaCTdPasyZM2Nevh4
Od8vgcrLRmbPlrcp8HO2IxL+pYGfTS2EoolssAeFy9wbRl4JwZKVcX2P1m0Bi5vHYiI1rH1P
JVjA8eBhbNaDaAHClGGdBQzk9/AA9NluvQLnVEuWc7wkOoWW790A2idu5B+mMiKI0mXDpDYG
xw4mY+YhG77yO9s+O/Kq/xW/wgDCHt3BW5XmppkQtVhzkWoSnaV5d8veOfMrO1sZB1jD7ww9
DKcugjdTw1XzKrJyUjGOz15dGQIQMdbBolsFWHYGRSizmu19OhpcJk1/reB59UctY6ph+f16
5ksbXgV1WgYHOGuU9w1ncYabfrL7q9IkReRJlDGCBBkwggQVAgEBMIGoMIGTMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE5MDcGA1UEAxMwQ09NT0RPIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhB7QzaAA2BLNDWTKAeLXwE/MAkGBSsO
AwIaBQCgggJFMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEz
MTAxNTA1MDUyMVowIwYJKoZIhvcNAQkEMRYEFKryVzTNvGp5h2kBRKYULhtHxusnMGwGCSqG
SIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggq
hkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgbkG
CSsGAQQBgjcQBDGBqzCBqDCBkzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFu
Y2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
OTA3BgNVBAMTMENPTU9ETyBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFp
bCBDQQIQe0M2gANgSzQ1kygHi18BPzCBuwYLKoZIhvcNAQkQAgsxgauggagwgZMxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQx
GjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMTkwNwYDVQQDEzBDT01PRE8gQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEHtDNoADYEs0NZMoB4tfAT8wDQYJ
KoZIhvcNAQEBBQAEggEAmbr6hsiqufm8Wv+dkwnko10pvuZy9xL4Jug2utIX3Sf4RmViBqPo
NMDqL2FpnP8Zbm/PJq7hPcVm9UxCLuuzzUreJ0vNS4gldgE/ZM5v1LMRnnlDHF9Xq77gqoch
nA1FdwWQVxStwbKOR3OAs7ZT5aa3C3f6MoX8+kxYOOOOdkl640PyGL83jqX4D+4gMDovSgjq
sHXkXoiSriSCHgM70nPfh6dfm+Gw+ZE+mTZ5gOcwsftbG/sGDZNZxftGCwSoHFH/p7ArCbwJ
Ao3xOm5uLlAEZ5aWf4n8XSGIMXLi1Oh7wrMzkyIpvMGoYoERiMtmRsVHNELPDSu0A4BN42rA
1gAAAAAAAA==
--------------ms070003010507020307040905--
