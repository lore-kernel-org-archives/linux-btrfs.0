Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36775 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751902AbdGDNYj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 09:24:39 -0400
Received: by mail-lf0-f65.google.com with SMTP id f28so17850809lfi.3
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jul 2017 06:24:38 -0700 (PDT)
From: Filippe LeMarchand <gasinvein@gmail.com>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: Btrfs check reports errors, filesystem seems fine
Date: Tue, 04 Jul 2017 16:24:30 +0300
Message-ID: <1805399.0XWA7WrQjV@carbide>
In-Reply-To: <20170704131636.GC2114@fnst>
References: <2049018.boNrIqZ5uI@carbide> <83ad37c7-7c86-1c8f-e575-78ebbc1749b9@cn.fujitsu.com> <20170704131636.GC2114@fnst>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2985585.NeOFnAV0XL"; micalg="sha256"; protocol="application/pkcs7-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart2985585.NeOFnAV0XL
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Sure, here it is:
https://drive.google.com/drive/folders/0B1ax9Am81gx9YjJBVVA0LXRHeGc

In a letter dated Tuesday, July 4, 2017 16:16:36 MSK user Lu Fengqi wrote:
> On Mon, Jul 03, 2017 at 08:34:52AM +0800, Qu Wenruo wrote:
> >
> >
> >At 07/01/2017 07:59 PM, Filippe LeMarchand wrote:
> >> Hello everyone.
> >> 
> >> I have an btrfs root partition on Intel 530 ssd, which mounts without errors and seem to work fine,
> >> but `btrfs check` gives me foloowing output (and --repair doesn't remove errors):
> >> 
> >> enabling repair mode
> >> Checking filesystem on /dev/sda2
> >> UUID: 12c84aa3-ce65-4390-807e-a72cc8a7445e
> >> checking extents
> >> Fixed 0 roots.
> >> checking free space cache
> >> cache and super generation don't match, space cache will be invalidated
> >> checking fs roots
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >
> >This means that in dir whose inode number is 79177, it has a child inode
> >pointer pointing to depercated.sxt.
> >
> >But it doesn't have dir index and corresponding inode ref, which is breaking
> >the cross reference rule of btrfs.
> >
> >Would you please run the following command to dump needed info for us to
> >debug?
> >
> ># btrfs-debug-tree /dev/sda2 | grep 79177 -C 10
> >
> >and
> >
> ># btrfs-debug-tree /dev/sda2 | grep deprecated.sxt -C 10
> >
> >and
> >
> ># btrfs-debug-tree /dev/sda2 | grep deprecated.txt -C 10
> >
> >
> >Considering the output has both .txt and .sxt, I think that's the problem.
> >But such bit-flip should be detected by tree block csum.
> >I'm not sure what's wrong with it.
> >
> >Thanks,
> >Qu
> >
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> 	unresolved ref dir 79177 index 0 namelen 14 name deprecated.sxt filetype 1 errors 6, no dir index, no inode ref
> >> 	unresolved ref dir 79177 index 417 namelen 14 name deprecated.txt filetype 1 errors 1, no dir item
> >> checking csums
> >> checking root refs
> >> found 23421812736 bytes used err is 0
> >> total csum bytes: 21531608
> >> total tree bytes: 776650752
> >> total fs tree bytes: 711278592
> >> total extent tree bytes: 36798464
> >> btree space waste bytes: 116002036
> >> file data blocks allocated: 850546470912
> >>   referenced 27611987968
> >> 
> >> Is it dangerous and what should I do about it?
> >> 
> >> I also tried --clear-space-cache, but it just removes the line about space cache.
> >> 
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> I'm afraid that your mail may be rejected because the attachment size
> exceeds the allowable limit(100kB) of btrfs mailing list. Could you
> share the attachment by google drive? 
> 
> Lastly, while Qu's timing is too tight, I will assist you on this issue.
> 
> 
--nextPart2985585.NeOFnAV0XL
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEPww
ggXYMIIDwKADAgECAhBMqvnK22Nv4B/3TthbA4adMA0GCSqGSIb3DQEBDAUAMIGFMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYD
VQQKExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9u
IEF1dGhvcml0eTAeFw0xMDAxMTkwMDAwMDBaFw0zODAxMTgyMzU5NTlaMIGFMQswCQYDVQQGEwJH
QjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQK
ExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1
dGhvcml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJHoVJLSClaxrA0k3cXPRGd0
mSs3o30jcABxvFPfxPoqEo9LfxBWvZ9wcrdhf8lLDxenPeOwBGHu/xGXx/SGPgr6Plz5k+Y0etkU
a+ecs4Wggnp2r3GQ1+z9DfqcbPrfsIL0FH75vsSmL09/mX+1/GdDcr0MANaJ62ss0+2PmBwUq37l
42782KjkkiTaQ2tiuFX96sG8bLaL8w6NmuSbbGmZ+HhIMEXVreENPEVg/DKWUSe8Z8PKLrZr6kbH
xyCgsR9l3kgIuqROqfKDRjeE6+jMgUhDZ05yKptcvUwbKIpcInu0q5jZ7uBRg8MJRk5tPpn6lRfa
fDNXQTyNUe0LtlyvLGMa31fIP7zpXcSbr0WZ4qNaJLS6qVY9z2+q/0lYvvCo//S4rek3+7q49As6
+ehDQh6J2ITLE/HZu+GJYLiMKFasFB2cCudx688O3T2plqFIvTz3r7UNIkzAEYHsVjv206LiW7ey
BCJSlYCTaeiOTGXxkQMtcHQC6otnFSlpUgK7199QalVGv6CjKGF/cNDDoqosIapHziicBkV2v4IY
J7TVrrTLUOZr9EyGcTDppt8WhuDY/0Dd+9BCiH+jMzouXB5BEYFjzhhxayvspoq3MVw6akfgw3lZ
1iAar/JqmKpyvFdK0kuduxD8sExB5e0dPV4onZzMv7NR2qdH5YRTAgMBAAGjQjBAMB0GA1UdDgQW
BBS7r34CPfqm8TyEjq3uOJjs2TIy1DAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAN
BgkqhkiG9w0BAQwFAAOCAgEACvHVRoS3rlG7bLJNQRQAk0ycy+XAVM+gJY4C+f2wog31IJg8Ey2s
VqKw1n4Rkukuup4umnKxvRlEbGE1opq0FhJpWozh1z6kGugvA/SuYR0QGyqki3rF/gWm4cDWyP6e
ro8ruj2Z+NhzCVhGbqac9Ncn05XaN4NyHNNz4KJHmQM4XdVJeQApHMfsmyAcByRpV3iyOfw6hKC1
nHyNvy6TYie3OdoXGK69PAlo/4SbPNXWCwPjV54U99HrT8i9hyO3tklDeYVcuuuSC6HG6GioTBax
GpkK6FMskruhCRh1DGWoe8sjtxrCKIXDG//QK2LvpHsJkZhnjBQBzWgGamMhdQOAiIpugcaF8qmk
Lef0pSQQR4PKzfSNeVixBpvnGirZnQHXlH3tA0rK8NvoqQE+9VaZyR6OST275Qm54E9Jkj0WgkDM
zFnG5jrtEi5pPGyVsf2qHXt/hr4eDjJG+/sTj3V/TItLRmP+ADRAcMHDuaHdpnDiBLNBvOmAkepk
nHrhIgOpnG5vDmVPbIeHXvNuoPl1pZtA6FOyJ51KucB3IY3/h/LevIzvF9+3SQvR8m4wCxoOTnbt
Efz16Vayfb/HbQqTjKXQwLYdvjpOlKLXbmwLwop8+iDzxOTlzQ2oy5GSsXyF7LUUaWYOgufNzsgt
plF/IcE1U4UGSl2frbsbX3QwggXmMIIDzqADAgECAhBqm+E4O/8ra58B1dm4p1JWMA0GCSqGSIb3
DQEBDAUAMIGFMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RP
IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xMzAxMTAwMDAwMDBaFw0yODAxMDkyMzU5
NTlaMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQH
EwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJT
QSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAL6znlesKHZ1QBbHOAOY08YYdiFQ8yV5C0y1oNF9Olg+nKcxLqf2
NHbZhGra0D00SOTq9bus3/mxgUsg/Wh/eXQ0pnp8tZ8XZWAnlyKMpjL+qUByRjXCA6RQyDMqVaVU
kbIr5SU0RDX/kSsKwer3H1pT/HUrBN0X8sKtPTdGX8XAWt/VdMLBrZBlgvnkCos+KQWWCo63OTTq
Rvaq8aWccm+KOMjTcE6s2mj6RkalweyDI7X+7U5lNo6jzC8RTXtVV4/Vwdax720YpMPJQaDaElmO
upyTf1Qib+cpukNJnQmwygjD8m046DQkLnpXNCAGjuJy1F5NATksUsbfJAr7FLUCAwEAAaOCATww
ggE4MB8GA1UdIwQYMBaAFLuvfgI9+qbxPISOre44mOzZMjLUMB0GA1UdDgQWBBSCr2yM+MX+lmF8
6B89K3FIXsSLwDAOBgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADARBgNVHSAECjAI
MAYGBFUdIAAwTAYDVR0fBEUwQzBBoD+gPYY7aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RP
UlNBQ2VydGlmaWNhdGlvbkF1dGhvcml0eS5jcmwwcQYIKwYBBQUHAQEEZTBjMDsGCCsGAQUFBzAC
hi9odHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FBZGRUcnVzdENBLmNydDAkBggrBgEF
BQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4ICAQB4XLKBKDRP
PO5fVs6fl1bsj6JrF/bz9kkIBtTYLzXN30D+03Hj6OxCDBEaIeNmsBhrJmuubvyE7HtoSmR809Ag
cYboW+rcTNZ/8u/Hv+GTrNI/AhqX2/kiQNxmgUPt/eJPs92Qclj0HnVyy9TnSvGkSDU7I5Px+TbO
+88G4zipA2psZaWeEykgzClZlPz1FjTCkk77ZXp5cQYYexE6zeeN4/0OqqoAloFrjAF4o50YJafX
8mnahjp3I2Y2mkjhk0xQfhNqbzlLWPoT3m7j7U26u7zg6swjOq8hITYc3/np5tM5aVyu6t99p17b
TbY7+1RTWBviN9YJzK8HxzObXYWBf/L+VGOYNsQDTxAk0Hbvb1j6KjUhg7fO294F29QIhhmiNOr8
4JHoy+fNLpfvYc/Q9EtFOI5ISYgOxLk3nD/whbUe9rmEQXLp8MB933Ij474gwwCPUpwv9mj2PMnX
oc7mbrS22XUSeTwxCTP9bcmUdp4jmIoWfhQm7X9w/Zgddg+JZ/YnIHOwsGsaTUgj7fIvxqith7Do
JC91WJ8Lce3CVJqb1XWeKIJ84F7YLXZN0oa7TktYgDdmQVxYkZo1c5noaDKH9Oq9cbm/vOYRUM1c
Wcef20Wkyk5S/GFyyPJwG0fR1nRas3DqAf4cXxMiEKcff7PNa4M3RGTqH0pWR8p6EjCCBTIwggQa
oAMCAQICEQDXdDjI2wGDsxF6weHvf8mUMA0GCSqGSIb3DQEBCwUAMIGXMQswCQYDVQQGEwJHQjEb
MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xNzA2MDgwMDAwMDBaFw0xODA2MDgyMzU5NTlaMCQx
IjAgBgkqhkiG9w0BCQEWE2dhc2ludmVpbkBnbWFpbC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDIMvvH6x4GgcmPVYk/zAxFsdpSHo9zqW5CnI+fLlGLnEvn5TdcutXr0ToCsfeD
MXPO5c+pmR9bHjQTYIYHb6WPA6xvxjv1ZO/YkGDmSaiA7wxDdOAmsJVgaqV/ijNCZZBRkxoEXNQb
ABYij3fQYbcyoHEmT6lTu+AcBKf0M7yeclqSpwGABfco3/WLs7Dts4aDgsg2xxA/d2ZtU8+Bgw6J
ePSysugO1/xjJFO9g/OZksOTdm1GaEp/XpCmzQp2YNFiBSzLbphowdryOAWj5ypwvm237rfO1vEk
EUdrd/XXKQGs49lAzPcV4bZChnnrTR1BGJdZh3uWi/FO4XG55bA7AgMBAAGjggHpMIIB5TAfBgNV
HSMEGDAWgBSCr2yM+MX+lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUrzUVgwSsp6awdPonAkbSCzmP
LdQwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysG
AQQBsjEBAwUCMBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATAr
MCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+g
TaBLhklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6
Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJl
RW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREE
FzAVgRNnYXNpbnZlaW5AZ21haWwuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQC2YT8zrjNlQIP1roMw
sopvoUtJO/yDAP5M4GPdkS2VQc+gVygV2OhjyHCZcdBBgUwtMpNivjxcqjWtSYh6F5pernYPZXtz
cMn9oYG6S7H9JmKDYObF0w6WadMUAdbpnSJD2MydLsjOTE5timdd42ncTkZq3dVICCHSvXMs5sJG
DaQo3Vha5ECosxs9zC6wmDRlBghLeTppq/d1HHCksSkhUlCHEorNqEFm+hB1FHh/1akSVT8/GdRd
1f2IGsOZDSZCcBdR5c2wLz9RqwEQmuV6MUqeVRLuKRg1C27lhpCPmEeq+Y8LHNOFeT1P/uL0VVDM
skktNX6qc13tni1zDzZAMYICbzCCAmsCAQEwga0wgZcxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJH
cmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
aW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2Vj
dXJlIEVtYWlsIENBAhEA13Q4yNsBg7MResHh73/JlDANBglghkgBZQMEAgEFAKCBkzAYBgkqhkiG
9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNzA3MDQxMzI0MzBaMCgGCSqGSIb3
DQEJDzEbMBkwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMC8GCSqGSIb3DQEJBDEiBCBxBpOpgIlS
BBTShLlHrhgKYgUYabCQIrUXSf3LkgrkGzANBgkqhkiG9w0BAQEFAASCAQBtJR+Mw6WWoKGCUj1c
jhn4TrdqVvaoLKX5BLv9p0GuDC8fjHKJmr2o1witpv1TuXOZxVSByB8hR9woQevjlS79OM1TtXy6
jsEID5j0/3il5+gRnXSUBSVDpCgc1DvQUbSFxfxbeUZOa7GXFyOgxs/L5oaK/dr8Je3olAJ8FNLe
8NJeCmPXSUiZLihC4RssKWFUz2D5r7UTVcL5Ctf03z1PgZAYjX4OHjs6q7EX2IG7qjR56ZEwsxyG
Bs+KBuvn72lexNw5iSNV+Ka9BndwVfxjxiPid5DLvNE8zm3jbAqEGVHWKaYANQmR3Ay5b0uRlMsK
vxPknOyF4kGchKY+LntuAAAAAAAA


--nextPart2985585.NeOFnAV0XL--

