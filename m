Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:41447 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751626AbeBWQrd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 11:47:33 -0500
From: =?UTF-8?Q?Andr=c3=a9_Weidemann?= <Andre.Weidemann@web.de>
Subject: Re: lots of data written, but no space occupied
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <ef59f4ee-f54d-81ea-c218-1dd4378e1ceb@web.de>
 <CAJCQCtT_5+NiULdJh_7qMff6U=VQGsj-bBS-Fg5W7v=dGbWs5Q@mail.gmail.com>
Message-ID: <b324d8f6-4456-7088-55d3-09b50722ea7d@web.de>
Date: Fri, 23 Feb 2018 17:47:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT_5+NiULdJh_7qMff6U=VQGsj-bBS-Fg5W7v=dGbWs5Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050708000809080407040509"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050708000809080407040509
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 23.02.2018 00:50, Chris Murphy wrote:
> The only thing I can think of is something's updating metadata due to
> relatime mount option. Maybe try noatime? At 9GiB, really it's 4.5GiB
> because whatever is being written is being doubled by raid1 profile
> and multiple devices. There is a case of wandering trees where a
> little bit of change can get amplified, but this requires an
> instigator, the file system won't do it on its own.
>
> What were the mkfs options? Are you using the default 16KiB nodesize?

I found the cause...  And "pebkac" is the only way to describe it.

As I wrote in my initial email, I installed collectd. And I was sure to=20
have disabled the rrdtool plugin, which apparently I hadn't. So there=20
was no additional space occupied, because collectd only updated already=20
existing files.

In the end it only took a small effort to figure it out.
I knew that calling "echo 1 > /proc/sys/vm/block_dump" would dump all=20
file access to syslog.
Since /var/log/syslog was on the effected drives, I created a ram-disk=20
and had rsyslog log to the RAM-disk. I did this so I wouldn't see my own =

writes to the log while running "grep sda".
I then grep inside the syslog using:
"tail -f /var/log-ram/syslog|egrep -v "btrfs-transacti|kwork"|grep sda"
until something like this fell out:
Feb 23 15:05:35 server2 kernel: [496223.186943] collectd(604): dirtied=20
inode 870979 (smart_attribute-temperature-celsius-2.rrd) on sda2



Thanks anyway.
   Andr=C3=A9



--------------ms050708000809080407040509
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CyUwggU3MIIEH6ADAgECAhBBzsM6DwXuBEHbuD+6KnX/MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xNzExMTgwMDAw
MDBaFw0xODExMTgyMzU5NTlaMCcxJTAjBgkqhkiG9w0BCQEWFmFuZHJlLndlaWRlbWFubkB3
ZWIuZGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQD3wXLZmXB1qLlUCibJFTuT
NrUNUjW2DoIc7qXndR9HJb5XjBqonnFV5P1fgFhpcJL4tD2cGK1IC9I0EeASP6OFBU7OV85x
SDn+X7VZ3UZs24mGirFw7qa6KPtU2UyADH82T316pVM5uCHAssmw/y1d+zvk2DZCjNXTlnpZ
czxdEdH7cqpUDxechUGlA3DwOQWFQZdMsR3bpKKWBNtfUzt0iHjsmMdzpYruQxeFbsIZpbmj
bRKq8SUi7/ueRV53pVcz79eVyJRuqvxn6R3ECah1GmCQS58Yy74ZW9LC/JA2gbDFeJKJUeJL
/dmcR3LP+Nm1vcM29rsnjt8d/0estnexAgMBAAGjggHsMIIB6DAfBgNVHSMEGDAWgBSCr2yM
+MX+lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQU28GT8ydaZH9qFyxhGvIbzshcqvwwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEB
AwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkG
CCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+g
TaBLhklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNh
dGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKG
SWh0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9u
YW5kU2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2Nh
LmNvbTAhBgNVHREEGjAYgRZhbmRyZS53ZWlkZW1hbm5Ad2ViLmRlMA0GCSqGSIb3DQEBCwUA
A4IBAQB4EtTh6tMgIeEc+shenBUoOihmeAH31eEO4tsKH53w4INWlFJg+aXL09LF+OUtMg/l
rKFtBSZmyJ0Vw5Y1VE5mS3q7Vq9+qb8SQNpTvbwqObr07h1gkaMqAeV9DvQRi5ToFiHFeUIF
L2/5x8gwExgOQYkfGjbSE2yOmYUCGpqgOfizbL6Vcbi4CAX+kopW6CY8WoCcWKuFpFapfHfX
oIT+vNpi1DxkaaNjQ8vdNYdBmkfIIIK7sCtk8oxhFRJzqy9zHoUb32zmu2CgNhhqwk2PrAfB
7/8cpcZBorHmNlh19gW/ipNOw+mYYk1RUnsLv6hrRAS3uW3fCcFGrbDWlpGiMIIF5jCCA86g
AwIBAgIQapvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEa
MBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50
IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR2
2YRq2tA9NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWl
VJGyK+UlNEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqO
tzk06kb2qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTD
yUGg2hJZjrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1
AgMBAAGjggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4E
FgQUgq9sjPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYB
Af8CAQAwEQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwu
Y29tb2RvY2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsG
AQUFBwEBBGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RP
UlNBQWRkVHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTANBgkqhkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A
/tNx4+jsQgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5
IkDcZoFD7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT8
9RY0wpJO+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4T
am85S1j6E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyv
B8czm12FgX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP
0PRLRTiOSEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1
Enk8MQkz/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVif
C3HtwlSam9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnH
n9tFpMpOUvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIE
MQIBATCBrDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
MA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMT
NENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EC
EEHOwzoPBe4EQdu4P7oqdf8wDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE4MDIyMzE2NDcxOVowLwYJKoZIhvcNAQkEMSIE
IBZBFEcEdyifm0kL3ZafkK4y7RMVgOdHW9ZJphY/5AXnMGwGCSqGSIb3DQEJDzFfMF0wCwYJ
YIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEEHOwzoP
Be4EQdu4P7oqdf8wgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkG
A1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGlj
YXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIQQc7DOg8F7gRB27g/uip1/zANBgkqhkiG9w0B
AQEFAASCAQB9cC5ok+kdM8XFtTkEqTV48pzXQjaRDleUzugGutGn5ZB72hjJwgTYUjO8/F3h
z9XZi3JTjxq/MTjVQZ0CDhqChLLX2wUSqzcjo171nSxHk6mkFm3+0R6Ojc4NVn4wxl0M0Zqo
bK9DGUQR6iK11fQE1oBcHeA7jTZsgDHp7voaH7HG4A68ecov+pSgb968Ld5VNo41xMjCq3Mu
XF2LtbR4CVt4apLt6xxof6UYYviRg6eI410hCZwBbf1c5lUACSKr/+XXKtRZ9kKkh0YMVtU8
BUGcoongRGIi0hPXICyH39Inek3/vG/kxwaD80ehL9u+Q4HOIbgF3UPd4xYc72ixAAAAAAAA

--------------ms050708000809080407040509--
