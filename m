Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hermes15.it.auth.gr ([155.207.1.232]:48436 "EHLO
	hermes15.it.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbcB1IRq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 03:17:46 -0500
Subject: Re: btrfs equivalent for zfs send -R
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <56D18C3F.9000105@it.auth.gr>
 <pan$e2074$912b63a0$272af732$4acdc80a@cox.net>
From: =?UTF-8?B?zpPOuc+Oz4HOs86/z4IgzqDOrM67zrvOsc+C?= <gpall@it.auth.gr>
Message-ID: <56D2AD22.1030404@it.auth.gr>
Date: Sun, 28 Feb 2016 10:17:38 +0200
MIME-Version: 1.0
In-Reply-To: <pan$e2074$912b63a0$272af732$4acdc80a@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020202000601040101060206"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020202000601040101060206
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 28/02/16 05:45, Duncan wrote:
> =CE=93=CE=B9=CF=8E=CF=81=CE=B3=CE=BF=CF=82 =CE=A0=CE=AC=CE=BB=CE=BB=CE=B1=
=CF=82 posted on Sat, 27 Feb 2016 13:45:03 +0200
> as excerpted:
>
>> Hi all.
>>
>> If I have a btrfs subvolume 'subv' and then subvolumes subv/sub1,
>> subv/sub2, subv/sub3, is there a way to snapshot all the subv tree and=

>> then recursively send it remotely?
>>
>> I think this would be the analogous of zfs snapshot -r, and then zfs
>> send -R.
> As a list regular and btrfs user myself, but not a dev...
>
> No idea about zfs and my own btrfs use-case doesn't use btrfs send/
> receive either, so this is primarily from previous list posts, with a
> quick look at the (v4.4.1) btrfs-send manpage as well...
>
> Recursive send isn't yet supported, only one at a time.
>
> Based on a previous comment from someone who apparently looked at the
> code (but isn't a btrfs dev either), there's possibly some code for -r
> (recursive) already in the repo (or maybe it's simply a comment reservi=
ng
> the -r option?), but it doesn't work yet.
>
> However, it shouldn't be horribly difficult to hack up scripts that
> automate the otherwise manual recursive-send/receive for you, as I'd ve=
ry
> likely do myself if I needed that functionality. =3D:^)
>

Thanks for the reply Duncan.

The problem with scripting the recursive process, as I understand it, is =

that in the case of e.g. adding an identical file inside each one sub=20
subvolume, this file would have to be transmitted during send, so many=20
times as the number of the sub subvolumes, which of course is not=20
viable. Am I right?

Giorgos



--------------ms020202000601040101060206
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DRQwggY6MIIFIqADAgECAggY3YeuH0u2bTANBgkqhkiG9w0BAQUFADCBlTELMAkGA1UEBhMC
R1IxRDBCBgNVBAoTO0hlbGxlbmljIEFjYWRlbWljIGFuZCBSZXNlYXJjaCBJbnN0aXR1dGlv
bnMgQ2VydC4gQXV0aG9yaXR5MUAwPgYDVQQDEzdIZWxsZW5pYyBBY2FkZW1pYyBhbmQgUmVz
ZWFyY2ggSW5zdGl0dXRpb25zIFJvb3RDQSAyMDExMB4XDTE0MDEwOTEyNDQzOVoXDTIyMDEw
NzEyNDQzOVowgZAxCzAJBgNVBAYTAkdSMUQwQgYDVQQKEztIZWxsZW5pYyBBY2FkZW1pYyBh
bmQgUmVzZWFyY2ggSW5zdGl0dXRpb25zIENlcnQuIEF1dGhvcml0eTE7MDkGA1UEAxMyQXJp
c3RvdGxlIFVuaXZlcnNpdHkgb2YgVGhlc3NhbG9uaWtpIENlbnRyYWwgQ0EgUjQwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCb+M8pkmGOZjlS5eF/D+FBOZByYgMp/3cPzfPJ
4HJdLwVaE3O7FQ13zZb/PZ0NwoDP37V79IU44TX3gQ9Eryw2qJjZYot2phVYpu2KIao2RaUE
MKf1/D+n36TtlE8cCFY6nFfZ0w22TkNKQDRuIiTP0yVoWwNq6gKjQqGfCUOqMVbtivQAudKC
aiiC0dJE0BX/pye6+xmZlHzP/ej0gbCAhoThIpXkXZAzhjX5GubdSumvCglfk/baTX8rCgry
qWr9E30GkK04t4mFqJiT7ir/bMxGCwpTOzxSAU2dkVxKTjrw13fCGz2TqmbptCiWWCi7UQT+
3t/qow/JzSqo8YsjAgMBAAGjggKPMIICizAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQE
AwIBBjAdBgNVHQ4EFgQU9ZMXSh1ztn9/ILKlFJRXchkzNtIwRgYDVR0fBD8wPTA7oDmgN4Y1
aHR0cDovL2NybHYxLmhhcmljYS5nci9IYXJpY2FSb290Q0EyMDExL2NybHYxLmRlci5jcmww
HwYDVR0jBBgwFoAUppFC/RNhSiOeCKQp5dgTBCPuQSUwbgYIKwYBBQUHAQEEYjBgMCEGCCsG
AQUFBzABhhVodHRwOi8vb2NzcC5oYXJpY2EuZ3IwOwYIKwYBBQUHMAKGL2h0dHA6Ly93d3cu
aGFyaWNhLmdyL2NlcnRzL0hhcmljYVJvb3RDQTIwMTEucGVtMIIBPwYDVR0gBIIBNjCCATIw
ggEuBgwrBgEEAYHPEQEAAgcwggEcMDIGCCsGAQUFBwIBFiZodHRwOi8vd3d3LmhhcmljYS5n
ci9kb2N1bWVudHMvQ1BTLnBocDCB5QYIKwYBBQUHAgIwgdgwShZDSGVsbGVuaWMgQWNhZGVt
aWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAD
AgEBGoGJVGhpcyBjZXJ0aWZpY2F0ZSBpcyBzdWJqZWN0IHRvIEdyZWVrIGxhd3MgYW5kIG91
ciBDUFMuIFRoaXMgQ2VydGlmaWNhdGUgbXVzdCBvbmx5IGJlIHVzZWQgZm9yIGFjYWRlbWlj
LCByZXNlYXJjaCBvciBlZHVjYXRpb25hbCBwdXJwb3Nlcy4wLQYDVR0eBCYwJKAiMAmCB2F1
dGguZ3IwCYEHYXV0aC5ncjAKgQguYXV0aC5ncjANBgkqhkiG9w0BAQUFAAOCAQEAV1Co0/M+
tv0u2woCgPaGR9bsenVJ5z39hs2J64UFQHN7dZ4xlmJEPkZ0NwmH/bLjLTN7E8X/4/wdmN9N
eTx4Y2cpJBurcIo5xx4k6KQ+M0gD0LrVD6thwR0qT+7u0F0kSc5KBLanbtqrlQYd8WojcBjQ
7E7hkpwhXSzu79X7lp/PUrmVkREOnfXV8QW/Y3lymHc34c+x5dEd5gcpn788Zy4k33+XLOz0
GefDInwoUnSHuECDi8vgG2XeeilAto7a+auoYuuBugJ70CaYyyPJFJRi0YuWBj3oXKRdtYlS
U5+HmDT/Z2lu9k5dzoBm5EZZv38zKJd/Ets9CEsAKJUMpDCCBtIwggW6oAMCAQICCBfZcnrd
H0ARMA0GCSqGSIb3DQEBBQUAMIGQMQswCQYDVQQGEwJHUjFEMEIGA1UEChM7SGVsbGVuaWMg
QWNhZGVtaWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBDZXJ0LiBBdXRob3JpdHkxOzA5
BgNVBAMTMkFyaXN0b3RsZSBVbml2ZXJzaXR5IG9mIFRoZXNzYWxvbmlraSBDZW50cmFsIENB
IFI0MB4XDTE0MDUwNTAwMDAwMFoXDTE2MDUwNDE1MDk1MFowgc4xCzAJBgNVBAYTAkdSMS0w
KwYDVQQKDCRBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kxEjAQBgNVBAsM
CUlUIENlbnRlcjFBMD8GA1UECww4Q2xhc3MgQiAtIFByaXZhdGUgS2V5IGNyZWF0ZWQgYW5k
IHN0b3JlZCBpbiBzb2Z0d2FyZSBDU1AxGDAWBgNVBAMMD0dlb3JnaW9zIFBhbGxhczEfMB0G
CSqGSIb3DQEJARYQZ3BhbGxAaXQuYXV0aC5ncjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAOOu8ThgnvLj583DUWcxv6DuGXoCvynUrh61Aw4ZkqYe6fUW4zdHpaxAWyZgkF2R
zHBs8hI2qm/VeMh5cFdWl6MWq+km4tA9GLsvCPoZMnEAWUmAS55ipUXxemA39lxcJoN+q5vj
vjtyO1hy7k9GB2ZcAnN5YQTtDp34Y06JMvvvrYK1f4SbHZb5n2+tBB8FabFx6mNVQH1tnU2l
1LAxmuKrWFXDh4lNyI43x9HyWc6zw4qkEzsLoVJQQBDq39Oyd7UC/I9cpmMNtRLHSGE7QHAm
wRYXTFz5Ij1smxevgPjPSLDbOSU3dxWR31ksH116v3OBfdMkuWPp+jrOL+wDQicCAwEAAaOC
Au4wggLqMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisG
AQQBgjcUAgIwKQYJKwYBBAGCNxQCBBweGgBTAG0AYQByAHQAYwBhAHIAZABVAHMAZQByMB0G
A1UdDgQWBBQOna1BqtNs9a+DRzcbXq3b5sFYgzAfBgNVHSMEGDAWgBT1kxdKHXO2f38gsqUU
lFdyGTM20jBxBggrBgEFBQcBAQRlMGMwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLnBraS5h
dXRoLmdyMDwGCCsGAQUFBzAChjBodHRwOi8vd3d3LnBraS5hdXRoLmdyL2NlcnRzL0F1dGhD
ZW50cmFsQ0FSNC5wZW0wRwYDVR0fBEAwPjA8oDqgOIY2aHR0cDovL2NybHYxLnBraS5hdXRo
LmdyL0F1dGhDZW50cmFsQ0FSNC9jcmx2MS5kZXIuY3JsMIIBIAYDVR0gBIIBFzCCARMwggEP
BgsrBgEEAbwdAgADBTCB/zA0BggrBgEFBQcCARYoaHR0cDovL3d3dy5wa2kuYXV0aC5nci9k
b2N1bWVudHMvQ1BTLnBocDCBxgYIKwYBBQUHAgIwgbkwKxYkQXJpc3RvdGxlIFVuaXZlcnNp
dHkgb2YgVGhlc3NhbG9uaWtpMAMCAQEagYlUaGlzIGNlcnRpZmljYXRlIGlzIHN1YmplY3Qg
dG8gR3JlZWsgbGF3cyBhbmQgb3VyIENQUy4gVGhpcyBDZXJ0aWZpY2F0ZSBtdXN0IG9ubHkg
YmUgdXNlZCBmb3IgYWNhZGVtaWMsIHJlc2VhcmNoIG9yIGVkdWNhdGlvbmFsIHB1cnBvc2Vz
LjBVBgNVHREETjBMgQ1ncGFsbEBhdXRoLmdygRFncGFsbEBjY2YuYXV0aC5ncqAoBgorBgEE
AYI3FAIDoBoMGGdwYWxsQHBjbGFicy5pdGMuYXV0aC5ncjAOBgorBgEEAYI3AgEVBAAwDQYJ
KoZIhvcNAQEFBQADggEBAI/cXQ7d9zkTcKHTL/VMR311CmiFD7tmMhaXbBudBLAeqwyNQtuP
jm1a1mXK8xVeIJ3wcim2syt3CkL9siIaBouoRDnmEqYORUXC/grdXPBAVKGYyfe4Y5PriUoA
KZ/8WbyPXX0TsaPBjZJ6UVKhQzCHtoq/af1qfi672KZH0Lug1iOCgQ8NJpkQHeTRfoPVDRLX
T0XSoBszzcwh5gD1TbO2ITtA+8lAIyJVgTccIclPxRkdGtgqMPdvwXMtNgMiSJ9V11jAseOv
pGUbg5BRwvvrAGoSyIchPNlgborTF6+ntONME6CBRt9gQGGfiLfCI6iUqQm4U5ex0IEY3jQx
GbUxggQIMIIEBAIBATCBnTCBkDELMAkGA1UEBhMCR1IxRDBCBgNVBAoTO0hlbGxlbmljIEFj
YWRlbWljIGFuZCBSZXNlYXJjaCBJbnN0aXR1dGlvbnMgQ2VydC4gQXV0aG9yaXR5MTswOQYD
VQQDEzJBcmlzdG90bGUgVW5pdmVyc2l0eSBvZiBUaGVzc2Fsb25pa2kgQ2VudHJhbCBDQSBS
NAIIF9lyet0fQBEwDQYJYIZIAWUDBAIBBQCgggI7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDIyODA4MTczOFowLwYJKoZIhvcNAQkEMSIEIKLGzCWF
3kPHUMfNKmPto4rem/s1bAKb+tKntdB8rBZZMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwga4GCSsGAQQBgjcQBDGBoDCBnTCBkDEL
MAkGA1UEBhMCR1IxRDBCBgNVBAoTO0hlbGxlbmljIEFjYWRlbWljIGFuZCBSZXNlYXJjaCBJ
bnN0aXR1dGlvbnMgQ2VydC4gQXV0aG9yaXR5MTswOQYDVQQDEzJBcmlzdG90bGUgVW5pdmVy
c2l0eSBvZiBUaGVzc2Fsb25pa2kgQ2VudHJhbCBDQSBSNAIIF9lyet0fQBEwgbAGCyqGSIb3
DQEJEAILMYGgoIGdMIGQMQswCQYDVQQGEwJHUjFEMEIGA1UEChM7SGVsbGVuaWMgQWNhZGVt
aWMgYW5kIFJlc2VhcmNoIEluc3RpdHV0aW9ucyBDZXJ0LiBBdXRob3JpdHkxOzA5BgNVBAMT
MkFyaXN0b3RsZSBVbml2ZXJzaXR5IG9mIFRoZXNzYWxvbmlraSBDZW50cmFsIENBIFI0AggX
2XJ63R9AETANBgkqhkiG9w0BAQEFAASCAQA+IL5JDR9mAyivZzs5tRXFbxQh94e5ybx6eLh2
dNJg6b+OusMXg5mukg89a4C5melyCB3Kn4sGnAvdvSQLbheP1Asg+K9h/Fc2+62KM3m3TAP7
kDhzcuSNgwTPvU1egkKcSP9InEUXt9c/XcNtJ1URz8vpT1JqKpJyk3Gfb4jgUf4urAhBGcDe
lvFXxLDxnL61lPYdyUD8nTgICFJ5CAdbxe5klYMNhFdy8e5qM+lGu01XALbhrs7Xh8MolcbA
McBJO9tvcq4wgKhqxrevKNf86eJSoLUtykuhY3HF4coRTQjmbXtV0kOZ8a5wEyDBIlJNfWFP
qGfmePcCzNj/3bmXAAAAAAAA
--------------ms020202000601040101060206--
