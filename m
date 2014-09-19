Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63361 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISSo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 14:44:59 -0400
Received: by mail-ie0-f181.google.com with SMTP id tr6so4056234ieb.12
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 11:44:59 -0700 (PDT)
Message-ID: <541C799C.8070809@gmail.com>
Date: Fri, 19 Sep 2014 14:44:44 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with unmountable filesystem.
References: <54184BD2.7000300@gmail.com> <2A2CB71A-7516-43CD-94E1-BCB2198F5FC4@colorremedies.com> <54196F42.4030101@gmail.com> <9D39D5EC-0614-4A7A-8D72-CBC51EFBB26D@colorremedies.com>
In-Reply-To: <9D39D5EC-0614-4A7A-8D72-CBC51EFBB26D@colorremedies.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050607080505000806000400"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050607080505000806000400
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-09-19 13:54, Chris Murphy wrote:
>
> On Sep 17, 2014, at 5:23 AM, Austin S Hemmelgarn <ahferroin7@gmail.com>=
 wrote:
>
> [   30.920536] BTRFS: bad tree block start 0 130402254848
> [   30.924018] BTRFS: bad tree block start 0 130402254848
> [   30.926234] BTRFS: failed to read log tree
> [   30.953055] BTRFS: open_ctree failed
>
> I'm still confused. Btrfs knows this tree root is bad, but it has backu=
p roots. So why wasn't one of those used by -o recovery? I thought that's=
 the whole point of that mount option. Backup tree roots are per superblo=
ck, so conceivably you'd have up to 8 of these with two superblocks, they=
're shown with
> btrfs-show-super -af  ## and -F even if a super is bad
>
> But skipping that, to fix this you need to know which super is pointing=
 to the wrong tree root, since you're using ssd mount option with rotatin=
g supers. I assume mount uses the super with the highest generation numbe=
r. So you'd need to:
> btrfs-show-super -a
> to find out the super with the most recent generation. You'd assume tha=
t one was wrong. And then use btrfs-select-super to pick the right one, a=
nd replace the wrong one. Then you could mount.
>
> I also wonder if btrfs check -sX would show different results in your c=
ase. I'd think it would because it ought to know one of those tree roots =
is bad, seeing as mount knows it. And then it seems (I'm speculating a to=
n) that --repair might try to fix the bad tree root, and then if it fails=
 I'd like to think it can just find the most recent good tree root, ideal=
ly one listed as a backup_tree_root by any good superblock, and then have=
 the next mount use that.
>
> I'm not sure why this persistently fails, and I wonder if there are cas=
es of users giving up and blowing away file systems that could actually b=
e mountable. But it's just really a manual process figuring out what thin=
gs to do in what order to get them to mount.
>
 From what I can tell, btrfs check doesn't do anything about backup=20
superblocks unless you specifically tell it to.  In this case, running=20
btrfs check without specifying a superblock mirror, and with explicitly=20
specifying the primary superblock produced identical results (namely it=20
choked, hard, with an error message similar to that from the kernel.=20
However, running it with -s1 to select the first backup superblock=20
returned no errors at all other than the space_cache being invalid and=20
the count of used blocks being wrong.

Based on my (limited) understanding of the mount code, it does try to=20
use the superblock with the highest generation (regardless of whether we =

are on an ssd or not), but doesn't properly fall back to a secondary=20
superblock after trying to mount using the primary.

As far as btrfs check repair trying to fix this, I don't think that it=20
does so currently, probably for the same reason that mount fails.



--------------ms050607080505000806000400
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTE5MTg0NDQ0
WjAjBgkqhkiG9w0BCQQxFgQUd34vVAqWWJY2u4ZIg9V2MVCQbwQwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAxg8o2uo/KMTZYKI7+0GYyOr6YCja
h10HhmO4Oxhuc7QzEZPj2eyTXCn42as0hxlcYjI7cNGPUzdtR6PqgXhxh9fcz4alov8wuE1V
8UTiNeoUI63wTIiUKOgQB3FScGEoMw6pU77rvTuRcSPeJGTUnKqURmtHqV8KFn4Eny7kF6yS
oQo9OWgZOBPbMwgeK6GsZFATY2ElsKlz4gRH6iQpgsZHC0xt9sgLaBoeT0qj4seIEtNTqXDj
f0J7uHmOxY/7+1fOnIBUE0AWYUE8fDA2dyzEBFPifMiwvNKijTAXD5yy0BBX73m2FeNwf8nA
ku1Hx83dO8JOtGkd5IYFyL2fOwAAAAAAAA==
--------------ms050607080505000806000400--
