Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33812 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbbJTMqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 08:46:09 -0400
Received: by iow1 with SMTP id 1so20280008iow.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 05:46:08 -0700 (PDT)
Subject: Re: N-Way (traditional) RAID-1 development status
To: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn7C-0O5TRn6fpBFdst6=-cJ2zdn0RPQD3n97MR7NrZxsg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56263769.3030903@gmail.com>
Date: Tue, 20 Oct 2015 08:45:29 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7C-0O5TRn6fpBFdst6=-cJ2zdn0RPQD3n97MR7NrZxsg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070409010700000709040405"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070409010700000709040405
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 23:13, james harvey wrote:
> Wanted to see if there's active development on N-Way (traditional) RAID=
-1.
>
> By this, I mean that RAID-1 across "n" disks traditionally means "n"
> copies of data, but btrfs currently implements RAID-1 as "2" copies of
> data.  So, unlike traditional RAID-1, losing 2 drives in a many drive
> array might cause data loss.  It's been mentioned before that N-Way
> (traditional) RAID-1 should eventually be implemented through btrfs.
Before I go any further, I would like to point out that most traditional =

hardware RAID controllers only support two disks for RAID-1=20
configurations, and the only one I've seen that doesn't does RAID-1 like =

BTRFS (two copies total of each block).  The whole 'RAID-1 on n disks is =

n copies' thing actually started with Linux's MD-RAID subsystem, and=20
just happens to have been popular enough that other software RAID=20
implementations adopted those semantics as well.

OK, with that historical rant out of the way, back to your actual=20
question:  Based on what has been said in the past, N-way replication is =

planned for development after the raid56 code is considered stable.=20
Based on that and past experience, I'd say to expect it no sooner than=20
4.8, or if we're _really_ lucky, 4.7.  On top of that, based on past=20
experience with BTRFS\, I would not suggest actually trying it for=20
anything other than testing until at least one release after the initial =

release.


--------------ms070409010700000709040405
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTI0NTI5WjBPBgkq
hkiG9w0BCQQxQgRAuvrDYgk8IY3uACZUAoPxmfNayEGoOdDmdIJtdN5skvU88k4OCQ01ojbX
7N4XPSPhawvOZeceoLhmu424daK6cDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAYm3jH+qACbxCoQZyYx3UKJbxIjETAruQ+Fn/VGSBOBR87+tX5
0kBj8xLjk9U+zSFBeqtuUZq8ErYfHAWKdNuTJg9AB6mbSSKr7f5vwYWSALDxx94tcGKP/129
eSbHP8FKNxyoZPnAiG1fuqMVqAqYA0q+PeohYIJUDDDeZ8yDE9wYz2GeyUp0bvmLFhCkS+82
d5SUDQ7RVWI+sVf6E9ho0lb5R7s/3sCnYU+wwku/vQhUZUxQd528L4Ab4Sf52+KhRJlAuejJ
Atmklald0ivu6itf/odS32HX6K1Pw1ZvjRq4ElTu491P+sVFyOz/7nVvESOu5m21OjGiGWuZ
JvuCNhkKQFIF0zzogrJzyuRP2mIs7Obvf+IgSugabem/QWvDPgcLIu38Pbza0LoYif/D+mLN
kVDYkf+S0zPCgHi45SwthOhrFBOi1ZczFq/nZQF/rSn/opzwi6IUt8ErDegGv6prUr7Vbxoy
XL7/qEww35t5/mCahpIR0exWSIgYzgI3F8PnVsnx846eEnl1xdSahOrN28rt4ChiIeI4ZhR0
kOsbsT1CqwvvtFq68UKhc1CATM1XAu8UOelVuDt40tMktHwCui8cdsVNl9C8lGxJhLmgSjCX
dXyDI0iKshuU3+dFbXk0ivAjwE3cOdN1KunlLIvV2yTflkqImR4QJZq9ugAAAAAAAA==
--------------ms070409010700000709040405--
