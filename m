From: Andrej Podzimek <andrej@podzimek.org>
Subject: Re: parent transid verify failures on 2.6.39
Date: Thu, 23 Jun 2011 00:42:28 +0200
Message-ID: <4E026FD4.7020606@podzimek.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="=_charon-16626-1308782548-0001-2"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_charon-16626-1308782548-0001-2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

>> After doing an upgrade to 2.6.39 from 2.6.39-rc7, I am unable to mount=

>> my 3 disk btrfs volume.  It was a clean reboot, which makes it all the=

>> more puzzling.  This is what I'm getting:
>>
>>
>> [68808.339109] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 2
>> transid 339584 /dev/sdc1
>> [68808.340354] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 1
>> transid 339584 /dev/sda1
>> [68808.340774] device fsid a941511a96bcbfb8-8c123cb07aa6aaa1 devid 3
>> transid 339584 /dev/sdb1
>>
>> [70106.913668] btrfs: disk space caching is enabled
>> [70106.968648] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969031] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969403] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969671] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969691] parent transid verify failed on 6038227976192 wanted
>> 337418 found 337853
>> [70106.969704] Failed to read block groups: -5
>> [70107.050658] btrfs: open_ctree failed
>>
>> I went to run a btrfsck, but found out that I needed to compile with
>> the tmp branch or I would get an unsupported features message (lzo and=

>> space_cache).  After compiling that, when I run btrfsck, I get this:
>>
>> parent transid verify failed on 6038227976192 wanted 337418 found 3378=
53
>> parent transid verify failed on 6038227976192 wanted 337418 found 3378=
53
>> parent transid verify failed on 6038227976192 wanted 337418 found 3378=
53
>>
>> And then it stops.  This happens with btrfs-debug-tree, or
>> btrfs-select-super.  I've tried it on sda1, sdb1, and sdc1 and also
>> with -s 0, -s 1, and -s 2.  Dmesg shows a segfault:
>>
>> [71775.589462] btrfsck[14453]: segfault at c4 ip 000000000040e477 sp
>> 00007fffa9eb4d30 error 4 in btrfsck[400000+21000]
>>
>> For fun, I ran it through gdb and I got this:
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> find_first_block_group (root=3D0x61d1b0, path=3D0x61ef10, key=3D0x7fff=
ffffe240)
>>     at extent-tree.c:3028
>> 3028                    if (slot >=3D btrfs_header_nritems(leaf)) {
>>
>>
>>
>> Is there any hope of recovery here?  Not the end of the world if the
>> volume is lost, but it would be a bit of a pain and I'm at a loss as
>> to why it happened.  I tried mounting with the new integration-test
>> branch just for fun, but there's no difference on the mounting.  Any
>> help that could be provided would be immensely appreciated.  Thanks!
>>
>
> So I have a patch I can give you that will possibly help you recover
> your data if you don't have backups, or you can wait a couple of days
> (hopefully) for the new btrfsck tool that will be much better than the
> hack I can give you.  Thanks,
>
> Josef

Could I try your hack, pretty please? If there's any chance it could eith=
er resolve this problem

	http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10683.html ,

or at least restore the data from the filesystem, then I'd like to give i=
t a go. Waiting for the new btrfsck is currently not an option for me :-)=


Andrej


--=_charon-16626-1308782548-0001-2
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIISszCC
BakwggSRoAMCAQICAT0wDQYJKoZIhvcNAQEFBQAwgYQxFDASBgNVBAMMC1BvZHppbWVrIENB
MQswCQYDVQQGEwJDWjEOMAwGA1UEBwwFWmzDrW4xFTATBgNVBAoMDHBvZHppbWVrLm9yZzEV
MBMGA1UECwwMcG9kemltZWsub3JnMSEwHwYJKoZIhvcNAQkBFhJhZG1pbkBwb2R6aW1lay5v
cmcwHhcNMTEwMzMwMTYwNzM3WhcNMTIwMzI5MTYwNzM3WjCBiTELMAkGA1UEBhMCQ1oxDjAM
BgNVBAcMBVpsw61uMRUwEwYDVQQKDAxwb2R6aW1lay5vcmcxFTATBgNVBAsMDHBvZHppbWVr
Lm9yZzEYMBYGA1UEAwwPQW5kcmVqIFBvZHppbWVrMSIwIAYJKoZIhvcNAQkBFhNhbmRyZWpA
cG9kemltZWsub3JnMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAqxdSN8GoC0Ny
yPVoc9uZhuN+ezgtvKodMPunwlZCqaV4p7g3rgzDe3rrQ+Afkj05R+7WqLStjPn1lr9KINtn
mxqjUF07U4CqGZgKCruKxWiTI1pvpTljTKssoa/sbEf0UgjQvO0UNhjYF1iHE1VBVWALKgI0
Kbb+zCftvdwtnKVh9ncQushra5MZLEeMTcXisyzasFgDb8teLn8MtDQuJb0QzHkqhwRBzj7u
pKTGKcZxGhxzZdmcqfvZdjLAcxQApLyMq7O8Y+0FHgZHW5peeuHSgeC+kScffJvGloHGPzVt
CqODxDOHtjS8ZfkAKKt7PKdTfqiF8/+/zZ8pT98GlLXZtrz5IXlt8YQRh3ugE+o76vikx6ho
SZQZsVFsc0KT/S7PA5fwkorUyhhuYcs53rTDO2IN4kPVoU2Tq6iyV6D8zF5/OiMxJ5lhYUGu
RjAHM4hAFJ1ROp3LRn5VwYotogdj81xucd/hW7tc1HUN7lHnd51WK4xXjJ5o1gF0wUUYlxMc
wpXqv9ZW1P+zD28Wj7BxmiAtll5oAButMBjLVWgJYlpOY3Ikh6rx+TVAwfDD5oVmOzc8NAYI
pJCSmrX4MDahymq+ayjOhIw2OPXaFBbGP7YTgp68e86p+I2JTQ/tXCH08MZYFpRB11M3dI2L
IkDlcWOm4Ptc3794p8yS0T8CAwEAAaOCAR0wggEZMAkGA1UdEwQCMAAwHQYDVR0OBBYEFBas
PXfIN+SpJaWzrihb8DnOUJGZMIG5BgNVHSMEgbEwga6AFE6juEwI0K5X6Rv/eMJTk7Q8cg65
oYGKpIGHMIGEMRQwEgYDVQQDDAtQb2R6aW1layBDQTELMAkGA1UEBhMCQ1oxDjAMBgNVBAcM
BVpsw61uMRUwEwYDVQQKDAxwb2R6aW1lay5vcmcxFTATBgNVBAsMDHBvZHppbWVrLm9yZzEh
MB8GCSqGSIb3DQEJARYSYWRtaW5AcG9kemltZWsub3JnggkAkctHSQfLqowwMQYJYIZIAYb4
QgEEBCQWImh0dHBzOi8vY2EucG9kemltZWsub3JnL2NhLWNybC5wZW0wDQYJKoZIhvcNAQEF
BQADggEBAH5XwT/0jYayTafRvAcJfRAm5E6z6wqX0x5OYNdO6JQ9JcCYQeFa1XD80Yu/VHy8
NmaF+p2iAaCZWcTbIeAzidSozgbDJlVYcMdUjer0WHbBpyIBcVJZY4im/ygyVTACOIlLnfXM
ZaNfdsCBP/minHHonm5e8DU8Go2/viAKPfXxsCOzl0bZFnU2b2D5Ii6Gk4n6kyduzQWYVUqA
fNQjQIKZDSIMPzh119QsbR+6vNQ5t46qpHVMUkn1JLf+MIJQSBjxoXXt9ORnpTRstVw1ATPz
RxDYYltHxaqKUY07bSo5czyWyUN5Rd35SP1mlQSHJhmNVUuOHQ58yDEADUEqkSkwggY0MIIE
HKADAgECAgEgMA0GCSqGSIb3DQEBBQUAMH0xCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFy
dENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5n
MSkwJwYDVQQDEyBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0wNzEwMjQy
MTAyNTVaFw0xNzEwMjQyMTAyNTVaMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDLKIVFnAEs+xnyq6UzjCqgDcvQ
Ve1dIoFnRsQPCFO+y92k8RK0Pn3MbQ2Gd+mehh9GBZ+36uUQA7Xj9AGM6wgPhEE34vKtfpAN
5tJ8LcFxveDObCKrL7O5UT9WsnAZHv7OYPYSR68mdmnEnJ83M4wQgKO19b+Rt8sPDAz9ptkQ
sntCn4GeJzg3q2SVc4QJTg/WHo7wF2ah5LMOeh8xJVSKGEmd6uPkSbj113yKMm8vmNptRPmM
1+YgmVwcdOYJOjCgFtb2sOP79jji8uhWR91xx7TpM1K3hv/wrBZwffrmmEpUeuXHRs07JqCC
vFh9coKF4UQZvfEg+x3/69xRCzb1AgMBAAGjggGtMIIBqTAPBgNVHRMBAf8EBTADAQH/MA4G
A1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUrlWDb+wxyrn3HfqvazHzyB3jrLswHwYDVR0jBBgw
FoAUTgvvGqRAW6UXaYcwyjRoQ9BBrvIwZgYIKwYBBQUHAQEEWjBYMCcGCCsGAQUFBzABhhto
dHRwOi8vb2NzcC5zdGFydHNzbC5jb20vY2EwLQYIKwYBBQUHMAKGIWh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tL3Nmc2NhLmNydDBbBgNVHR8EVDBSMCegJaAjhiFodHRwOi8vd3d3LnN0YXJ0
c3NsLmNvbS9zZnNjYS5jcmwwJ6AloCOGIWh0dHA6Ly9jcmwuc3RhcnRzc2wuY29tL3Nmc2Nh
LmNybDCBgAYDVR0gBHkwdzB1BgsrBgEEAYG1NwECATBmMC4GCCsGAQUFBwIBFiJodHRwOi8v
d3d3LnN0YXJ0c3NsLmNvbS9wb2xpY3kucGRmMDQGCCsGAQUFBwIBFihodHRwOi8vd3d3LnN0
YXJ0c3NsLmNvbS9pbnRlcm1lZGlhdGUucGRmMA0GCSqGSIb3DQEBBQUAA4ICAQA6qScNyNO0
FpHvaZTQacVMXH33O51KyEKSRw3IvdQxRu31YR0ZDGdSfgSoOVDVMSBSdmfQfdDInHPzV3LO
5DwUXZ+lxjv7z3PO2OkfnFkvTXPfn6dxJ5rJveDsTsCPcJ/Kp6/+qN5g+J6D/SaYcFD018B6
L42r0Z4VEBy36P4tjRtF14Ex10tl5tJFVKM16qWKQHbpjIgf73s49UB0CQ5lHT2DHKfq3oPf
dNc5Mk93w1v4ryVb+qVrZIej8NsrWU+5r4O2IV91edDb/OtHFddZqHFFXKgS79IHE/hwQ2LW
7r3sTX7cDUCg+dfdwO8zeLxuwk2JF8crUoyrl66RGrRIhT8VoG/OJ1Y9uUlOav69V4cG8upi
4ZG2l7JZFbcBFk91Wp+Payo5SuF61CmGFrZ386umkmpObtFacXda2O/bVoQ9xHQrzoTc/0KZ
TWvlZCLK3Ke/vGYT9ZdW9lOjGsSFbXrlTA919L84iMK+48WGnvRWY28ZaVHpql43AtEGhXze
6iNCbEDACy+4hkQYOytAqDgcxAnQ937mYpeZFPyz/XK9QSt9VNFMuudWxZwDDDJKoQAoSG59
Hou9lZ26UrK60nRdAQBmEPL8h2nuWgoPh++XVQld9yuhbsWa39Pck8/lcfz5HUVGJF5mc/zk
38iV7FDlF68puiryNq2KXHEpOTCCBsowggWyoAMCAQICAgtGMA0GCSqGSIb3DQEBBQUAMIGM
MQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJl
IERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3Mg
MiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0EwHhcNMTAwOTI3MDA0ODU2WhcNMTIw
OTI3MDk1NjI4WjCBwjEgMB4GA1UEDRMXMjY0MzU2LVV6cDI4MnFISHRiQ2I1ZDMxCzAJBgNV
BAYTAkNaMRUwEwYDVQQIEwxabGluc2t5IEtyYWoxDTALBgNVBAcTBFpsaW4xLTArBgNVBAsT
JFN0YXJ0Q29tIFZlcmlmaWVkIENlcnRpZmljYXRlIE1lbWJlcjEYMBYGA1UEAxMPQW5kcmVq
IFBvZHppbWVrMSIwIAYJKoZIhvcNAQkBFhNhbmRyZWpAcG9kemltZWsub3JnMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArldROEvlaSy4OX9PPg22Xl7GCivziuBcbrkH+St9
vIAyefDb3kfdtHT/J1NRlQDYTrDFQ3cZM2J7vicm4/uu67KzdAF/14mdml1b1prWRiUT3IRw
Cwbt8wuNhZfa6dGkQ374EuOWDVX+5YCEufr5GMHrkkZy5RYtO9r3avglOI1ZB2F9Z56Zb42k
S7N2ebEE7Oj+pFeQwaj2pz/B4d3gu6wX+c7GwDiy26iN/33Cl+spa5uFWITb8XD6P6aob9Ep
yDxn90KEr5+9ug1tmh833Kdll4mmjzAv5ZK0iVFnxsBq+V1TN/2NW6oiIvOLxTIHCfC1MdYi
88HMC1PaQZF4ywIDAQABo4IC/DCCAvgwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBT3GSEvnmmKZPBGzpElp7HtmoV7
FzAfBgNVHSMEGDAWgBSuVYNv7DHKufcd+q9rMfPIHeOsuzAeBgNVHREEFzAVgRNhbmRyZWpA
cG9kemltZWsub3JnMIIBQgYDVR0gBIIBOTCCATUwggExBgsrBgEEAYG1NwECAjCCASAwLgYI
KwYBBQUHAgEWImh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUH
AgEWKGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwgbcGCCsGAQUF
BwICMIGqMBQWDVN0YXJ0Q29tIEx0ZC4wAwIBARqBkUxpbWl0ZWQgTGlhYmlsaXR5LCBzZWUg
c2VjdGlvbiAqTGVnYWwgTGltaXRhdGlvbnMqIG9mIHRoZSBTdGFydENvbSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eSBQb2xpY3kgYXZhaWxhYmxlIGF0IGh0dHA6Ly93d3cuc3RhcnRzc2wu
Y29tL3BvbGljeS5wZGYwYwYDVR0fBFwwWjAroCmgJ4YlaHR0cDovL3d3dy5zdGFydHNzbC5j
b20vY3J0dTItY3JsLmNybDAroCmgJ4YlaHR0cDovL2NybC5zdGFydHNzbC5jb20vY3J0dTIt
Y3JsLmNybDCBjgYIKwYBBQUHAQEEgYEwfzA5BggrBgEFBQcwAYYtaHR0cDovL29jc3Auc3Rh
cnRzc2wuY29tL3N1Yi9jbGFzczIvY2xpZW50L2NhMEIGCCsGAQUFBzAChjZodHRwOi8vd3d3
LnN0YXJ0c3NsLmNvbS9jZXJ0cy9zdWIuY2xhc3MyLmNsaWVudC5jYS5jcnQwIwYDVR0SBBww
GoYYaHR0cDovL3d3dy5zdGFydHNzbC5jb20vMA0GCSqGSIb3DQEBBQUAA4IBAQCEI21EOM71
hKXRNFHbWFaemV86fxAs1yMl6SohZhNRea/Pc5hMpoFoUZBf0qJ3AvFy2PzsyspTsqZhBOwo
I3rVJlgZapKi4x4k7FXM43xFmU/koQLdQPDS1Jfbr8zFTVBx+K6xD+L9y+M1M7JX+EcQgTIu
CZn80YjSxEpAGND09NUPrgwJ/v9Nn5zqbEraf5MRSAun11fhkqIORlqkAi393N+kvXEsAtRJ
A0CizQzFfmLFNY4xWtWtRYJGatOIzDO8s8gA8kfC99CcygpRQbrMBaBZ3fzMgoNXhP7A6801
XYg+flS0kxPSubBbEfEUCVOHNcm4TAdyKwYehI9N8PD+MYIDuzCCA7cCAQEwgZMwgYwxCzAJ
BgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGln
aXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFBy
aW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICC0YwCQYFKw4DAhoFAKCCAfwwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTEwNjIyMjI0MjI4WjAjBgkq
hkiG9w0BCQQxFgQUlgjz0dRFvck46c5C8Cq57FbUABUwXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGbBgkrBgEEAYI3EAQxgY0wgYowgYQxFDASBgNVBAMM
C1BvZHppbWVrIENBMQswCQYDVQQGEwJDWjEOMAwGA1UEBwwFWmzDrW4xFTATBgNVBAoMDHBv
ZHppbWVrLm9yZzEVMBMGA1UECwwMcG9kemltZWsub3JnMSEwHwYJKoZIhvcNAQkBFhJhZG1p
bkBwb2R6aW1lay5vcmcCAT0wgZ0GCyqGSIb3DQEJEAILMYGNoIGKMIGEMRQwEgYDVQQDDAtQ
b2R6aW1layBDQTELMAkGA1UEBhMCQ1oxDjAMBgNVBAcMBVpsw61uMRUwEwYDVQQKDAxwb2R6
aW1lay5vcmcxFTATBgNVBAsMDHBvZHppbWVrLm9yZzEhMB8GCSqGSIb3DQEJARYSYWRtaW5A
cG9kemltZWsub3JnAgE9MA0GCSqGSIb3DQEBAQUABIIBAHStPrGIq2Z6+cHDD0iJSB25e9gG
8l9rBOrkDoU35GVF7bXP7Irnj10iBgSELgrdZQCZIBgQQw1xQ/W1vOnXapV4SMpDZlt0IpQs
+39nBdZ7blQzczJ6YAfb36S9L5cBnhrL9t3J/wp1MB83uRZnmTIEXLYGOwQO5wgjJJ6m1SsW
xAPhmSnK52HNmBLa2aVhbiEhz/YGEX1dMXBxa7lsYbZq+5Lp3lTWfgpcXgUr9YFZMG8lQx94
DhpX24OOatLvbUOVUtJk7h37zcEkp+BXzITE4R6CNzFTnS8Pr1vsTW0HSkabQ4DQaJ7Fb62f
9fPDzz4p7hLlZfxwXOgttQdOlfoAAAAAAAA=
--=_charon-16626-1308782548-0001-2--
