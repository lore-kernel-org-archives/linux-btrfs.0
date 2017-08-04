Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:43842 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdHDTiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 15:38:46 -0400
Message-ID: <1501874946.5098.3.camel@christoph.anton.mitterer.name>
Subject: Re: FAILED: patch "[PATCH] Btrfs: fix early ENOSPC due to delalloc"
 failed to apply to 4.12-stable tree
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: linux-btrfs@vger.kernel.org
Cc: osandov@fb.com
Date: Fri, 04 Aug 2017 21:29:06 +0200
In-Reply-To: <15015495878144@kroah.com>
References: <15015495878144@kroah.com>
Content-Type: multipart/signed; micalg="sha-512";
        protocol="application/x-pkcs7-signature";
        boundary="=-5Db/8/CcVO/pTiYlI+pZ"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--=-5Db/8/CcVO/pTiYlI+pZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey.

Could someone of the devs put some attention on this...?

Thanks,
Chris :-)


On Mon, 2017-07-31 at 18:06 -0700, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.12-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git
> commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From 17024ad0a0fdfcfe53043afb969b813d3e020c21 Mon Sep 17 00:00:00
> 2001
> From: Omar Sandoval <osandov@fb.com>
> Date: Thu, 20 Jul 2017 15:10:35 -0700
> Subject: [PATCH] Btrfs: fix early ENOSPC due to delalloc
>=20
> If a lot of metadata is reserved for outstanding delayed allocations,
> we
> rely on shrink_delalloc() to reclaim metadata space in order to
> fulfill
> reservation tickets. However, shrink_delalloc() has a shortcut where
> if
> it determines that space can be overcommitted, it will stop early.
> This
> made sense before the ticketed enospc system, but now it means that
> shrink_delalloc() will often not reclaim enough space to fulfill any
> tickets, leading to an early ENOSPC. (Reservation tickets don't care
> about being able to overcommit, they need every byte accounted for.)
>=20
> Fix it by getting rid of the shortcut so that shrink_delalloc()
> reclaims
> all of the metadata it is supposed to. This fixes early ENOSPCs we
> were
> seeing when doing a btrfs receive to populate a new filesystem, as
> well
> as early ENOSPCs Christoph saw when doing a big cp -r onto Btrfs.
>=20
> Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc
> infrastructure")
> Tested-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.na
> me>
> Cc: stable@vger.kernel.org
> Reviewed-by: Josef Bacik <jbacik@fb.com>
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
>=20
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a6635f07b8f1..e3b0b4196d3d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4825,10 +4825,6 @@ static void shrink_delalloc(struct
> btrfs_fs_info *fs_info, u64 to_reclaim,
> =C2=A0		else
> =C2=A0			flush =3D BTRFS_RESERVE_NO_FLUSH;
> =C2=A0		spin_lock(&space_info->lock);
> -		if (can_overcommit(fs_info, space_info, orig, flush,
> false)) {
> -			spin_unlock(&space_info->lock);
> -			break;
> -		}
> =C2=A0		if (list_empty(&space_info->tickets) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0list_empty(&space_info->priority_tickets)=
) {
> =C2=A0			spin_unlock(&space_info->lock);
>=20
--=-5Db/8/CcVO/pTiYlI+pZ
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCCEqAw
ggXiMIIDyqADAgECAhBctkhuRwyYxn/2gNtkSuKNMA0GCSqGSIb3DQEBCwUAMH0xCzAJBgNVBAYT
AklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0
aWZpY2F0ZSBTaWduaW5nMSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xNTEyMTYwMTAwMDVaFw0zMDEyMTYwMTAwMDVaMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDuD1CMlQkjhKz1UGqP1jeiTiH9MgllRz6vOPrVG/eE0H/J4QQLV/PeL8RT
4xc44bEzsoJu0IhwnEchb+TxE/qw88w7hxODuw3N8Faxix6a1jp83+RWvZHZf78+O+3GYBpekZfT
Oe9A/FoTXbcgwZfLTMQodn+ckNnX31M/1M2f2/7VA7QBlvihontyHQOlIlryQXnGI0UMCD21oopK
tW48ckv0wUVg8irBKGMeD65gTON/Fsw/ZBbBqadoD1jt85FIM1ql24WUBEBwO1d0ykCKOIbgcqes
3fbcjQpruUNMBbIu1MMIRMqwjx/M7IvSKcS7VYRWl0/K2byzWvBAHh/1AgMBAAGjggFkMIIBYDAO
BgNVHQ8BAf8EBAMCAQYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQI
MAYBAf8CAQAwMgYDVR0fBCswKTAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20vc2ZzY2Eu
Y3JsMGYGCCsGAQUFBwEBBFowWDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Auc3RhcnRzc2wuY29t
MDAGCCsGAQUFBzAChiRodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9jYS5jcnQwHQYDVR0O
BBYEFJmXqxg1OotZRUOYsnJxyPT7Cc8WMB8GA1UdIwQYMBaAFE4L7xqkQFulF2mHMMo0aEPQQa7y
MD8GA1UdIAQ4MDYwNAYEVR0gADAsMCoGCCsGAQUFBwIBFh5odHRwOi8vd3d3LnN0YXJ0c3NsLmNv
bS9wb2xpY3kwDQYJKoZIhvcNAQELBQADggIBAJlBQQTO9iT1TjA0eEO7V/1AbBvMAfibjAgofxmJ
01jBmHKg0pbTjWInTTYoxb3LBgz3mfjvvS1PjnIfb29MyVm0G/PSHjgq7Ews1dEJMPC9XTuxPf2c
+MWLkynBlotW542JprW+iTWfZafyUtzIKW1hk0YASJ8zSSj8D++9yR+0UhkbvlECJkdi1+et0EaI
7HIX6ccj1rfcFFflWX/fPT64dn9jpg9s0nuJug4WsVkEK236WndZoMHrZmgF7CIyZ3T0muqYwkAS
DDcRt9A21o/Mc+D8Q6GVmKRGB3gEKvOtsioHZEqJv6CdAm3a6gloo5pX3RL1eCzc8Lzfs4T0ISZj
r8xNMbTGlsuHaFH+stDewKsfnpo4N64OtAGrzmVfFFsMIRENRHsVlSEe/6LVpBpjn00+7bqEN3qe
qSxIOraYJ12mJ08G4YnP2U1fadHIaS50O5ZXqAivoBl9pi/6CBNc5wIMlkXMyFZ0sLsI+9ErFDu9
OJhX7iWCo69X0ydlzXj08+2K1PKyr+g6/vTPHur63JotNrhyoWEJyWEjBLA4QmJXfGpB5u+bCwNf
sFpcYAlkiFt1Rs2vemgSBy3q4DHDbPKvr1YImZNRSHP+TX9NP94JRkmqcyD/qaN7u2JV1pRAlwG0
npyrn6ZQM1QHV+iFbwQ4VqLMWk//QVo/rZy1MIIGWTCCBUGgAwIBAgIQKvqyG4l1a4QpZQdDTt4S
WTANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEp
MCcGA1UECxMgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0
Q29tIENsYXNzIDIgQ2xpZW50IENBMB4XDTE2MDEwMjAyMTczNloXDTE4MDEwMjAyMTczNlowgYcx
CzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE3DvG5jaGVuMSEwHwYDVQQD
DBhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIxMTAvBgkqhkiG9w0BCQEWIm1haWxAY2hyaXN0b3Bo
LmFudG9uLm1pdHRlcmVyLm5hbWUwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDEiGUn
CUnFtl/6w+dAlOJAQeqVfAiJ0s426/fbCTV4TGEPGv2BS0ReV7RKAYgpJ7fmpXXIs3QRrItnAHvH
0SYjJ+ozwjPQ7WOc2W8x3N30J6zOzOicqQWAiweW0h60/4qpLTkouZAIfve4mLenNDN/SL9ihLTQ
DpYyMunRijPHB1I0qi95lIYiqsGQTDCx+TPSLMn07DZ7qBL2B9r5tIEG2GGknu0xaBrTjjGtN/Bk
FsWxu8Vw1rjnegzbYwiT8W6+TDDM4bMzXDcBrlXPou3J2mn1g5ybDS8rptb9A5VrkpdfJW6sWsFx
s/EHpd/RsPXy9rs4stiiF1bCKJDRvPwNIttEKWi3DL6u8BFXPfEpUp0+7DA3FErkic5SA8JciOEw
ei1jvm3BkOCsO7FGCtKfjVFmYgnW5AVLhqhbDIhsvggmuE6POUE5nSLTDuM/ALan3EuSlQnRbPRG
lB82sJuXd7CE4kiLyKPYBiU37FbIPUIxWTuxP9R936fTbOZGT1hAVC84Z1SDf6BUUj8yiACIrqVP
/r/fA0gcHi9XYJrKriipRhLgwtZt9s0pxdQE8SvtA1UGbo6yEJobDIr7E3iJKFFJFRP7KOU7qx3X
eaTa/v40/AGJmExzkEZtfCWmnu7e6M3YEQxm5TRGBDw18j+0wr+BCF8Pa/JcP9D7iESWUwIDAQAB
o4IB0DCCAcwwCwYDVR0PBAQDAgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNV
HRMEAjAAMB0GA1UdDgQWBBRT6rU95fwP8Tzp85YALNYMIInSbDAfBgNVHSMEGDAWgBSZl6sYNTqL
WUVDmLJyccj0+wnPFjBvBggrBgEFBQcBAQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0
YXJ0c3NsLmNvbTA5BggrBgEFBQcwAoYtaHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2Nh
LmNsaWVudDIuY3J0MDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3Nj
YS1jbGllbnQyLmNybDAtBgNVHREEJjAkgSJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5u
YW1lMCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisG
AQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQwLDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNz
bC5jb20vcG9saWN5MA0GCSqGSIb3DQEBCwUAA4IBAQANu9XxKSM0fXm1Lrao/L1wVaa5wQl4ZhwK
VJFc26u+C60K1DuOUJ/VOWRbTKRgrxETowyyG0vNaKCx+Rww8uF6+a1i5XKV1XnJY5Kfm2OCEawW
FEPBrhEQlUyUhQLm4ArCRP3Jm2Lk2rtrAm72/6Tn0XiM+Iv0mo7peoR5RZMJlMtraKWbIE1cBfH7
qD75VLqlUDoV/Dov70xPGRHl4pjGxSe4A2ix6MeOhITmAl7Uh34OjyzPMIoleyZ1RMO4YRMAazDy
VysjvpOkHPtHsq2Kfux42XKOe20X3UneXfcybBO4Cx/paZmX1GhIrRwlU0GmHikRG0/HPA7M6rQc
kLLZMIIGWTCCBUGgAwIBAgIQKvqyG4l1a4QpZQdDTt4SWTANBgkqhkiG9w0BAQsFADB1MQswCQYD
VQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjEpMCcGA1UECxMgU3RhcnRDb20gQ2VydGlm
aWNhdGlvbiBBdXRob3JpdHkxIzAhBgNVBAMTGlN0YXJ0Q29tIENsYXNzIDIgQ2xpZW50IENBMB4X
DTE2MDEwMjAyMTczNloXDTE4MDEwMjAyMTczNlowgYcxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZC
YXllcm4xETAPBgNVBAcMCE3DvG5jaGVuMSEwHwYDVQQDDBhDaHJpc3RvcGggQW50b24gTWl0dGVy
ZXIxMTAvBgkqhkiG9w0BCQEWIm1haWxAY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyLm5hbWUwggIi
MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDEiGUnCUnFtl/6w+dAlOJAQeqVfAiJ0s426/fb
CTV4TGEPGv2BS0ReV7RKAYgpJ7fmpXXIs3QRrItnAHvH0SYjJ+ozwjPQ7WOc2W8x3N30J6zOzOic
qQWAiweW0h60/4qpLTkouZAIfve4mLenNDN/SL9ihLTQDpYyMunRijPHB1I0qi95lIYiqsGQTDCx
+TPSLMn07DZ7qBL2B9r5tIEG2GGknu0xaBrTjjGtN/BkFsWxu8Vw1rjnegzbYwiT8W6+TDDM4bMz
XDcBrlXPou3J2mn1g5ybDS8rptb9A5VrkpdfJW6sWsFxs/EHpd/RsPXy9rs4stiiF1bCKJDRvPwN
IttEKWi3DL6u8BFXPfEpUp0+7DA3FErkic5SA8JciOEwei1jvm3BkOCsO7FGCtKfjVFmYgnW5AVL
hqhbDIhsvggmuE6POUE5nSLTDuM/ALan3EuSlQnRbPRGlB82sJuXd7CE4kiLyKPYBiU37FbIPUIx
WTuxP9R936fTbOZGT1hAVC84Z1SDf6BUUj8yiACIrqVP/r/fA0gcHi9XYJrKriipRhLgwtZt9s0p
xdQE8SvtA1UGbo6yEJobDIr7E3iJKFFJFRP7KOU7qx3XeaTa/v40/AGJmExzkEZtfCWmnu7e6M3Y
EQxm5TRGBDw18j+0wr+BCF8Pa/JcP9D7iESWUwIDAQABo4IB0DCCAcwwCwYDVR0PBAQDAgSwMB0G
A1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAJBgNVHRMEAjAAMB0GA1UdDgQWBBRT6rU95fwP
8Tzp85YALNYMIInSbDAfBgNVHSMEGDAWgBSZl6sYNTqLWUVDmLJyccj0+wnPFjBvBggrBgEFBQcB
AQRjMGEwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbTA5BggrBgEFBQcwAoYt
aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc2NhLmNsaWVudDIuY3J0MDgGA1UdHwQxMC8w
LaAroCmGJ2h0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3NjYS1jbGllbnQyLmNybDAtBgNVHREEJjAk
gSJtYWlsQGNocmlzdG9waC5hbnRvbi5taXR0ZXJlci5uYW1lMCMGA1UdEgQcMBqGGGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tLzBUBgNVHSAETTBLMAwGCisGAQQBgbU3BgEwOwYLKwYBBAGBtTcBAgQw
LDAqBggrBgEFBQcCARYeaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5MA0GCSqGSIb3DQEB
CwUAA4IBAQANu9XxKSM0fXm1Lrao/L1wVaa5wQl4ZhwKVJFc26u+C60K1DuOUJ/VOWRbTKRgrxET
owyyG0vNaKCx+Rww8uF6+a1i5XKV1XnJY5Kfm2OCEawWFEPBrhEQlUyUhQLm4ArCRP3Jm2Lk2rtr
Am72/6Tn0XiM+Iv0mo7peoR5RZMJlMtraKWbIE1cBfH7qD75VLqlUDoV/Dov70xPGRHl4pjGxSe4
A2ix6MeOhITmAl7Uh34OjyzPMIoleyZ1RMO4YRMAazDyVysjvpOkHPtHsq2Kfux42XKOe20X3Une
XfcybBO4Cx/paZmX1GhIrRwlU0GmHikRG0/HPA7M6rQckLLZMYIEfjCCBHoCAQEwgYkwdTELMAkG
A1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKTAnBgNVBAsTIFN0YXJ0Q29tIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5MSMwIQYDVQQDExpTdGFydENvbSBDbGFzcyAyIENsaWVudCBDQQIQ
KvqyG4l1a4QpZQdDTt4SWTANBglghkgBZQMEAgMFAKCCAcUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwODA0MTkyOTA2WjBPBgkqhkiG9w0BCQQxQgRAJDNi8vCI
lf2Ls/q1gtoidv5S9fcO2AlT3aZVCpENhWsbkZpvvStUrEoSyHHv36NGy/F1CMDZbhuiGYfcqibt
vjCBmgYJKwYBBAGCNxAEMYGMMIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBM
dGQuMSkwJwYDVQQLEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMa
U3RhcnRDb20gQ2xhc3MgMiBDbGllbnQgQ0ECECr6shuJdWuEKWUHQ07eElkwgZwGCyqGSIb3DQEJ
EAILMYGMoIGJMHUxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSkwJwYDVQQL
EyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEjMCEGA1UEAxMaU3RhcnRDb20gQ2xh
c3MgMiBDbGllbnQgQ0ECECr6shuJdWuEKWUHQ07eElkwDQYJKoZIhvcNAQEBBQAEggIARY3HyYUe
f+UBIm/LnSCJyngRInLj2qJRScwBt8LFp27jzLC8JscZvaXKNHw1k1iyAlhM6rgDdtYiFeW6CeOS
nPG6gV2pEeu+Zo+L2MaBA+y3u2n78axGnJMNyTkIIrE5gc1VzhMkRYAezVjEBtX/o85B1u0vRmqq
UZyI9ju6jII7ea/IaQlaLqmfCCap45usrbGqnlCPfiBZng0i4CtvHutz3O2h1/K5FQDczWx1BHHO
/ill3XAMOwXje3BIHrDjBfOHcEc2y2Yr+jSOY+Sqgni4ZAEdp0/UnPf9tY4VjIjpUfufeJCw/kYL
eP8K6jAh9E+Z5Fhvz9JNRElO4WzgzjyB3Pmkg6LXYrz84kBBynzUdvIpVxch6xBZK/dAHg1qO3bB
pnuED9I8EHmJiF+MNrSGhleTkbisKqlz9HQsZvo2PFeu+FYqMi2psaS4e4r32xYzxuZzyAqa71pW
ZiyH8fB5fH9Jb7FlXnp1rbtSIYxANotwJST1vWXdrDnxROqzJFFYNoZgVqBtFVQOA/XaP3tKeqR7
VIjaOZISTXvZmPiyaQADx+AmWX1NGroHf9N5KEa1fhOSJGraxiGUyPwMyTTWsoMq8DG7r7PSpJpE
/RMZnIDANOkod4Lk0taS2yzc/LfRaK/OKLno8hahCBCl7mBPrEy1HaxA2cOH7jl7SrsAAAAAAAA=


--=-5Db/8/CcVO/pTiYlI+pZ--

