Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60802 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaLAMxN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 07:53:13 -0500
Received: by mail-ie0-f175.google.com with SMTP id x19so4067100ier.6
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 04:53:12 -0800 (PST)
Message-ID: <547C64B4.2050802@gmail.com>
Date: Mon, 01 Dec 2014 07:53:08 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
References: <547BCB43.5020505@cn.fujitsu.com>
In-Reply-To: <547BCB43.5020505@cn.fujitsu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050607050308040709040207"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050607050308040709040207
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-30 20:58, Qu Wenruo wrote:
> [BACKGROUND]
> I'm trying to implement the function to repair missing inode item.
> Under that case, inode type must be salvaged(although it can be fallbac=
k to
> FILE).
>
> One case should be, if there is any dir_item/index or inode_ref refers =
the
> inode as parent, the type of that inode must be DIR.
>
> However, currently btrfsck implement (inode_record only records
> backref), we
> are unable to search the inode_backref whose parent is given inode numb=
er.
>
> [FIRST IMPLEMENT DESIGN]
> My first thought is to implement an generic inode-relation structure,
> recording parent ino, child ino, name and namelen, and restore the
> structure
> in a rbtree, not in the child/parent's list.
>
> But I soon recognize that this is a perfect use case for relational
> database,
> as 'ino' as the primary key for INODE table,
> ('parent_ino', 'child_ino', 'name') as the primary key for INODE_REF ta=
ble.
>
> [CRAZY IDEA]
> So why not using SQL to implement the btrfsck inode-record things?
>
> With such crazy idea, it will be much much easier to do any iteration
> from a
> given ino, and with the already mature RDB implement, like sqlite3, we =
can
> save hundreds of lines of codes implementing the rb-tree or list.
>
> [PROS]
> 1. Easy to maintain
>     Now we don't need to maintain the rbtree searching or list
> iteration, but
>     easy SQL lines and its wrapper.
>
> 2. Easy to extend
>     If we need to record something more, like extents and its relation =
to
>     inode, we only need to create 2 tables and several SQL and wrappers=
=2E
>
> 3. Reduced memory usage for HUGE fs.
>     When metadata grows to several TB or even more, current rb-tree bas=
ed
>     implement may run short of memory since they are all stored in memo=
ry.
>     But if use SQL, RDBMS like sqlite3 can restore things in either
> memory or
>     disk, which may hugely reduce the memory usage for huge btrfs.
>
>     If not use existing RDBMS, we need to implement complicated memory
> control
>     system to manage memory in userland.
>
> [CONS]
> 1. Heavy implement
>     SQL hide the rb-tree or B+ tree implement but costs more memory(if =
not
>     compressed) and CPU cycles, which will be slower than the simple
> rb-tree
>     implement even using lightweight RDBMS like sqlite3.
>
> 2. Heavy dependency
>     If use it, btrfs-progs will include RDBMS as the make and runtime
>     dependency.
>     Such low level progs depend on high level programs like sqlite3 may=

> be very
>     strange.
>
> 3. A lot of rework on existing codes.
>     Even SQL is easier to maintain and extend, if we use it, we still
> need to
>     reimplement several hundreds or even thousands lines of code to
> implement
>     it, not to mention the regression tests.
>
> 4. Copyright
>     Will it cause any copyright problem if using non-GPL RDBMS like
> sqlite3 in
>     GPLv2 btrfs-progs?
>
> [NEED FEEDBACK]
> Any feedback or discussion on the crazy idea is welcomed, since this ma=
y
> needs
> a lot of work, it definitely needs a lot review on the idea before it
> comes to
> codes.
>
So, I think this does a good job of highlighting one of the bigger=20
issues with btrfsck when it is compared to ext* and/or xfs.  Despite=20
this being a problem, I really don't think using a rdbms is the way to=20
fix it, both for reasons outlined in other responses, and because fsck=20
should be as fast as possible when nothing is wrong with the fs.



--------------ms050607050308040709040207
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAxMTI1MzA4
WjAjBgkqhkiG9w0BCQQxFgQUD6o40Mjc58IxmmRjPSB+HjbaAAIwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAaS9DMMqsoDT9z7iBKq9MnaGEG1tW
aZAk5Bqu1dAMfwQsqqPega/jN1leEJJEdifLWao2cLanuDSB+S53/16USSZuP19te65+Oyhr
nVviCkLb3P2NKINvzXcMOVltZP2yInwOMJcQRyMAF973SZJ5eYZOeLetE2K1jYvHhFLl6s/5
agyK9IK2lhjjCB1OlzH4myErMM1LD995jU2rCOwRIkJFHYhte8Ke4ZXG2bqJ8nPd0a6qb0Yt
HzMgHGNFMfK4GGetOZnvBunr7tTicyR6RwegWl8x0vLewszvKvW/9wJUW/HviOKcZbK/bWIl
HEFOH+ypqEt/XegF73e9UAeKKQAAAAAAAA==
--------------ms050607050308040709040207--
