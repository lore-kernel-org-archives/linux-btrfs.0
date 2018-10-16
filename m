Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6250C5ACC6
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 22:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C52DA2145D
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 22:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="pKp5GwFK";
	dkim=pass (1024-bit key) header.d=mail.ru header.i=@mail.ru header.b="pKp5GwFK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C52DA2145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=mail.ru
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbeJQGGv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 02:06:51 -0400
Received: from fallback20.mail.ru ([185.5.136.252]:47038 "EHLO
        fallback20.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbeJQGGv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 02:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Content-Type:MIME-Version:Date:Message-ID:Subject:From:To; bh=nlJ19hBd7JagdL93Jgk1AsPMWlL+48VS3rvGXx007u8=;
        b=pKp5GwFKayc0xMUg3texe8EWW9UA9gaZ7Xa0OUNxQpR/TnFP43Ny9FByKl7Zbx45lCiG9vn029KM2rYS4onFSUxLFIWFfpPl/Y0DPTUqUMaMeLDRuShZGdXb3OiOGcnj/MsU489X6FXNqY0Z+FkT/ykhUcF3IhISVxN1uW57Tg0=;
Received: from [10.161.64.48] (port=41484 helo=smtp40.i.mail.ru)
        by fallback20.m.smailru.net with esmtp (envelope-from <dma_k@mail.ru>)
        id 1gCXbW-0001BW-QY
        for linux-btrfs@vger.kernel.org; Wed, 17 Oct 2018 01:14:19 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mail.ru; s=mail2;
        h=Content-Type:MIME-Version:Date:Message-ID:Subject:From:To; bh=nlJ19hBd7JagdL93Jgk1AsPMWlL+48VS3rvGXx007u8=;
        b=pKp5GwFKayc0xMUg3texe8EWW9UA9gaZ7Xa0OUNxQpR/TnFP43Ny9FByKl7Zbx45lCiG9vn029KM2rYS4onFSUxLFIWFfpPl/Y0DPTUqUMaMeLDRuShZGdXb3OiOGcnj/MsU489X6FXNqY0Z+FkT/ykhUcF3IhISVxN1uW57Tg0=;
Received: by smtp40.i.mail.ru with esmtpa (envelope-from <dma_k@mail.ru>)
        id 1gCXbU-0005JI-Rk
        for linux-btrfs@vger.kernel.org; Wed, 17 Oct 2018 01:14:17 +0300
Received: from [192.168.1.46] (Furia.home [192.168.1.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by centurion.home (Postfix) with ESMTPSA id ADF22F126BB
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Oct 2018 00:14:15 +0200 (CEST)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   Dmitry Katsubo <dma_k@mail.ru>
Subject: Failover for unattached USB device
Message-ID: <dac5a4c5-e40d-a332-420f-f5517730a5f4@mail.ru>
Date:   Wed, 17 Oct 2018 00:14:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------09CF967D2415FA036A2B9522"
Content-Language: en-RU
X-7FA49CB5: 0D63561A33F958A5DA177153942E453B157631A39EB64D57515A6AB0B9252FC28941B15DA834481FA18204E546F3947C062BEEFFB5F8EA3EF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B47272755C61AA17BA471835C12D1D977C4224003CC8364767815B9869FA544D8090A508E0FED6299176DF2183F8FC7C003F1AB874ED89028E0C89D67371282C4A18204E546F3947C706E30CA52318619BA3038C0950A5D36581343779C53C132BD4B6F7A4D31EC0B7815B9869FA544D8EC76A7562686271E6BA297DBC24807EA089D37D7C0E48F6C8AA50765F7900637F0CE20E859FE95249742F3FF12380D1E089D37D7C0E48F6C5571747095F342E857739F23D657EF2B6825BDBE14D8E7028C9DFF55498CEFB0BD9CCCA9EDD067B1EDA766A37F9254B7
X-Mailru-Sender: 6DAAA20F2058E07D134D6D8D77B89E7F3D74AC814071E575577E0B59FEE0E9408907B308748047C8501E7C294F69090ED50E20E2BC48EF5AE609D43F356B221EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: OK
X-7FA49CB5: 0D63561A33F958A549E540D97D8F6E2D6DD6D69A44805956045A0057EE9D787C8941B15DA834481FA18204E546F3947CB861051D4BA689FCF6B57BC7E64490618DEB871D839B7333395957E7521B51C2545D4CF71C94A83E9FA2833FD35BB23D27C277FBC8AE2E8B47272755C61AA17BA471835C12D1D977C4224003CC836476C0CAF46E325F83A50BF2EBBBDD9D6B0F05F538519369F3743B503F486389A921A5CC5B56E945C8DA
X-Mailru-MI: 800
X-Mailru-Sender: A5480F10D64C900511DAD0B11101DE4FB9558816DC6CE7232BC83297CF65F0D738FB88F2046B4192D7448B40F9645FF708335C02508E532C672654BDC5BB03D95FEEDEB644C299C0ED14614B50AE0675
X-Mras: OK
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------09CF967D2415FA036A2B9522
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Dear btrfs team / community,

Sometimes it happens that kernel resets USB subsystem (looks like hardware
problem). Nevertheless all USB devices are unattached and attached back. After
few hours of struggle btrfs finally comes to the situation when read-only
filesystem mount is necessary. During this time when I try to access this
mounted filesystem (/mnt/backups) it reports success for some directories, or
error for others:

root@debian:~# ll /mnt/backups/
total 14334
drwxr-xr-x 1 adm users    116 Sep 12 00:35 .
drwxrwxr-x 1 adm users    164 Sep 19 22:44 ..
-rw-r--r-- 1 adm users  79927 Feb  7  2018 contacts.zip
drwxr-xr-x 1 adm users    254 Feb  4  2018 attic
drwxr-xr-x 1 adm users     16 Feb 23  2018 recent
...
root@debian:~# ll /mnt/backups/attic/
ls: reading directory '/mnt/backups/attic/': Input/output error
total 0
drwxr-xr-x 1 adm users 254 Feb  4  2018 .
drwxr-xr-x 1 adm users 116 Sep 12 00:35 ..

It looks like this depends on whether the content is in disk cache...

What is surprising: when I try to create a file, I succeed:

root@debian:~# touch /mnt/backups/.mounted
root@debian:~# ll /mnt/backups/.mounted
-rw-r--r-- 1 root root 0 Sep 20 16:52 /mnt/backups/.mounted
root@debian:~# rm /mnt/backups/.mounted

My btrfs volume consists of two identical drives combined into RAID1 volume:

# btrfs filesystem df /mnt/backups
Data, RAID1: total=880.00GiB, used=878.96GiB
System, RAID1: total=8.00MiB, used=144.00KiB
Metadata, RAID1: total=2.00GiB, used=1.13GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# btrfs filesystem show /mnt/backups
Label: none  uuid: a657364b-36d2-4c1f-8e5d-dc3d28166190
        Total devices 2 FS bytes used 880.09GiB
        devid    1 size 3.64TiB used 882.01GiB path /dev/sdf
        devid    2 size 3.64TiB used 882.01GiB path /dev/sde

As a workaround I can monitor dmesg output but:

1. It would be nice if I could tell btrfs that I would like to mount read-only
after a certain error rate per minute is reached.
2. It would be nice if btrfs could detect that both drives are not available and
unmount (as mount read-only won't help much) the filesystem.

Kernel log for Linux v4.14.2 is attached.

-- 
With best regards,
Dmitry

--------------09CF967D2415FA036A2B9522
Content-Type: text/plain; charset=UTF-8;
 name="log.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="log.txt"

SnVuIDI5IDE4OjU0OjU2IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY1LjQ0MDM5Nl0gdXNiIDQt
MjogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgMwpKdW4gMjkgMTg6NTQ6NTYgZGVi
aWFuIGtlcm5lbDogWzExOTc4NjUuNDQwNDAzXSB1c2IgNC0yLjI6IFVTQiBkaXNjb25uZWN0
LCBkZXZpY2UgbnVtYmVyIDUKSnVuIDI5IDE4OjU0OjU2IGRlYmlhbiBrZXJuZWw6IFsxMTk3
ODY1LjQ3NjExOF0gdXNiIDQtMi4zOiBVU0IgZGlzY29ubmVjdCwgZGV2aWNlIG51bWJlciA4
Ckp1biAyOSAxODo1NDo1NiBkZWJpYW4ga2VybmVsOiBbMTE5Nzg2NS41NDkzNzldIHVzYiA0
LTIuNDogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgNwouLi4KSnVuIDI5IDE4OjU0
OjU4IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY3LjUxNzcyOF0gdXNiLXN0b3JhZ2UgNC0yLjM6
MS4wOiBVU0IgTWFzcyBTdG9yYWdlIGRldmljZSBkZXRlY3RlZApKdW4gMjkgMTg6NTQ6NTgg
ZGViaWFuIGtlcm5lbDogWzExOTc4NjcuNTI0MDIxXSB1c2Itc3RvcmFnZSA0LTIuMzoxLjA6
IFF1aXJrcyBtYXRjaCBmb3IgdmlkIDE1MmQgcGlkIDA1Njc6IDUwMDAwMDAKSnVuIDI5IDE4
OjU0OjU4IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY3LjYwMzg1OV0gdXNiIDQtMi40OiBuZXcg
ZnVsbC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciAxMyB1c2luZyBlaGNpLXBjaQpKdW4gMjkg
MTg6NTQ6NTggZGViaWFuIGtlcm5lbDogWzExOTc4NjcuNzI1NTk1XSB1c2Itc3RvcmFnZSA0
LTIuNDoxLjI6IFVTQiBNYXNzIFN0b3JhZ2UgZGV2aWNlIGRldGVjdGVkCkp1biAyOSAxODo1
NDo1OCBkZWJpYW4ga2VybmVsOiBbMTE5Nzg2Ny43Mjg2MDJdIHNjc2kgaG9zdDk6IHVzYi1z
dG9yYWdlIDQtMi40OjEuMgpKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtlcm5lbDogWzExOTc4
NjguNTI4NzM3XSBzY3NpIDc6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIFNUNDAwMERNIDAw
NC0yQ1YxMDQgICAgICAgMDEyNSBQUTogMCBBTlNJOiA2Ckp1biAyOSAxODo1NDo1OSBkZWJp
YW4ga2VybmVsOiBbMTE5Nzg2OC41MjkzMTBdIHNjc2kgNzowOjA6MTogRGlyZWN0LUFjY2Vz
cyAgICAgU1Q0MDAwRE0gMDA0LTJDVjEwNCAgICAgICAwMTI1IFBROiAwIEFOU0k6IDYKSnVu
IDI5IDE4OjU0OjU5IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY4LjUzMDA5M10gc2QgNzowOjA6
MDogQXR0YWNoZWQgc2NzaSBnZW5lcmljIHNnNSB0eXBlIDAKSnVuIDI5IDE4OjU0OjU5IGRl
YmlhbiBrZXJuZWw6IFsxMTk3ODY4LjUzMDU4OF0gc2QgNzowOjA6MTogQXR0YWNoZWQgc2Nz
aSBnZW5lcmljIHNnNiB0eXBlIDAKSnVuIDI5IDE4OjU0OjU5IGRlYmlhbiBrZXJuZWw6IFsx
MTk3ODY4LjUzMzA2NF0gc2QgNzowOjA6MTogW3NkaF0gVmVyeSBiaWcgZGV2aWNlLiBUcnlp
bmcgdG8gdXNlIFJFQUQgQ0FQQUNJVFkoMTYpLgpKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtl
cm5lbDogWzExOTc4NjguNTMzNjE5XSBzZCA3OjA6MDoxOiBbc2RoXSA3ODE0MDM3MTY4IDUx
Mi1ieXRlIGxvZ2ljYWwgYmxvY2tzOiAoNC4wMCBUQi8zLjY0IFRpQikKSnVuIDI5IDE4OjU0
OjU5IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY4LjUzMzYyNl0gc2QgNzowOjA6MTogW3NkaF0g
NDA5Ni1ieXRlIHBoeXNpY2FsIGJsb2NrcwpKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtlcm5l
bDogWzExOTc4NjguNTM0MDYzXSBzZCA3OjA6MDoxOiBbc2RoXSBXcml0ZSBQcm90ZWN0IGlz
IG9mZgpKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtlcm5lbDogWzExOTc4NjguNTM0MDY5XSBz
ZCA3OjA6MDoxOiBbc2RoXSBNb2RlIFNlbnNlOiA2NyAwMCAxMCAwOApKdW4gMjkgMTg6NTQ6
NTkgZGViaWFuIGtlcm5lbDogWzExOTc4NjguNTM0NDIyXSBzZCA3OjA6MDoxOiBbc2RoXSBO
byBDYWNoaW5nIG1vZGUgcGFnZSBmb3VuZApKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtlcm5l
bDogWzExOTc4NjguNTM0NTQyXSBzZCA3OjA6MDoxOiBbc2RoXSBBc3N1bWluZyBkcml2ZSBj
YWNoZTogd3JpdGUgdGhyb3VnaApKdW4gMjkgMTg6NTQ6NTkgZGViaWFuIGtlcm5lbDogWzEx
OTc4NjguNTM1NTYzXSBzZCA3OjA6MDoxOiBbc2RoXSBWZXJ5IGJpZyBkZXZpY2UuIFRyeWlu
ZyB0byB1c2UgUkVBRCBDQVBBQ0lUWSgxNikuCkp1biAyOSAxODo1NDo1OSBkZWJpYW4ga2Vy
bmVsOiBbMTE5Nzg2OC41MzY3MDJdIHNkIDc6MDowOjA6IFtzZGddIFZlcnkgYmlnIGRldmlj
ZS4gVHJ5aW5nIHRvIHVzZSBSRUFEIENBUEFDSVRZKDE2KS4KSnVuIDI5IDE4OjU0OjU5IGRl
YmlhbiBrZXJuZWw6IFsxMTk3ODY4LjUzNzQ1NF0gc2QgNzowOjA6MDogW3NkZ10gNzgxNDAz
NzE2OCA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDQuMDAgVEIvMy42NCBUaUIpCkp1biAy
OSAxODo1NDo1OSBkZWJpYW4ga2VybmVsOiBbMTE5Nzg2OC41Mzc0NTldIHNkIDc6MDowOjA6
IFtzZGddIDQwOTYtYnl0ZSBwaHlzaWNhbCBibG9ja3MKSnVuIDI5IDE4OjU0OjU5IGRlYmlh
biBrZXJuZWw6IFsxMTk3ODY4LjUzODMyN10gc2QgNzowOjA6MDogW3NkZ10gV3JpdGUgUHJv
dGVjdCBpcyBvZmYKSnVuIDI5IDE4OjU0OjU5IGRlYmlhbiBrZXJuZWw6IFsxMTk3ODY4LjUz
ODMzMV0gc2QgNzowOjA6MDogW3NkZ10gTW9kZSBTZW5zZTogNjcgMDAgMTAgMDgKLi4uCkp1
biAyOSAyMDoyMjozNSBkZWJpYW4ga2VybmVsOiBbMTIwMzEyNS4wNjEwNjhdIEJUUkZTIGVy
cm9yIChkZXZpY2Ugc2RmKTogYmRldiAvZGV2L3NkaCBlcnJzOiB3ciAwLCByZCAxLCBmbHVz
aCAwLCBjb3JydXB0IDAsIGdlbiAwCkp1biAyOSAyMDoyMjozNSBkZWJpYW4ga2VybmVsOiBb
MTIwMzEyNS4wNjEyNDRdIEJUUkZTIGVycm9yIChkZXZpY2Ugc2RmKTogYmRldiAvZGV2L3Nk
ZyBlcnJzOiB3ciAwLCByZCAxLCBmbHVzaCAwLCBjb3JydXB0IDAsIGdlbiAwCkp1biAyOSAy
MDoyMjozNSBkZWJpYW4ga2VybmVsOiBbMTIwMzEyNS4wNjE0MTJdIEJUUkZTIGVycm9yIChk
ZXZpY2Ugc2RmKTogYmRldiAvZGV2L3NkaCBlcnJzOiB3ciAwLCByZCAyLCBmbHVzaCAwLCBj
b3JydXB0IDAsIGdlbiAwCkp1biAyOSAyMDoyMjozNSBkZWJpYW4ga2VybmVsOiBbMTIwMzEy
NS4wNjE1MzBdIEJUUkZTIGVycm9yIChkZXZpY2Ugc2RmKTogYmRldiAvZGV2L3NkZyBlcnJz
OiB3ciAwLCByZCAyLCBmbHVzaCAwLCBjb3JydXB0IDAsIGdlbiAwCkp1biAyOSAyMDoyMjoz
NSBkZWJpYW4ga2VybmVsOiBbMTIwMzEyNS4wNjE3NzBdIEJUUkZTIGVycm9yIChkZXZpY2Ug
c2RmKTogYmRldiAvZGV2L3NkaCBlcnJzOiB3ciAwLCByZCAzLCBmbHVzaCAwLCBjb3JydXB0
IDAsIGdlbiAwCkp1biAyOSAyMDoyMjozNSBkZWJpYW4ga2VybmVsOiBbMTIwMzEyNS4wNjE4
OTRdIEJUUkZTIGVycm9yIChkZXZpY2Ugc2RmKTogYmRldiAvZGV2L3NkZyBlcnJzOiB3ciAw
LCByZCAzLCBmbHVzaCAwLCBjb3JydXB0IDAsIGdlbiAwCkp1biAyOSAyMDoyMjo0MCBkZWJp
YW4ga2VybmVsOiBbMTIwMzEzMC40MTE5MTFdIGJ0cmZzX2Rldl9zdGF0X3ByaW50X29uX2Vy
cm9yOiA0MiBjYWxsYmFja3Mgc3VwcHJlc3NlZAouLi4KSnVuIDI5IDIzOjUxOjM2IGRlYmlh
biBrZXJuZWw6IFsxMjE1NjY2Ljg2MzQ3NV0gQlRSRlMgZXJyb3IgKGRldmljZSBzZGYpOiBi
ZGV2IC9kZXYvc2RoIGVycnM6IHdyIDAsIHJkIDE4NjcsIGZsdXNoIDAsIGNvcnJ1cHQgMCwg
Z2VuIDAKSnVuIDI5IDIzOjUxOjM2IGRlYmlhbiBrZXJuZWw6IFsxMjE1NjY2Ljg2NDQ2NF0g
QlRSRlMgZXJyb3IgKGRldmljZSBzZGYpOiBiZGV2IC9kZXYvc2RnIGVycnM6IHdyIDAsIHJk
IDE4NjcsIGZsdXNoIDAsIGNvcnJ1cHQgMCwgZ2VuIDAKSnVuIDI5IDIzOjUxOjM2IGRlYmlh
biBrZXJuZWw6IFsxMjE1NjY2Ljg2NTM5Ml0gQlRSRlM6IGVycm9yIChkZXZpY2Ugc2RmKSBp
biBidHJmc19ydW5fZGVsYXllZF9yZWZzOjMwODk6IGVycm5vPS01IElPIGZhaWx1cmUKSnVu
IDI5IDIzOjUxOjM2IGRlYmlhbiBrZXJuZWw6IFsxMjE1NjY2Ljg2NjM1NF0gQlRSRlMgaW5m
byAoZGV2aWNlIHNkZik6IGZvcmNlZCByZWFkb25seQpKdW4gMjkgMjM6NTE6MzYgZGViaWFu
IGtlcm5lbDogWzEyMTU2NjYuODY2MzU3XSBCVFJGUyB3YXJuaW5nIChkZXZpY2Ugc2RmKTog
U2tpcHBpbmcgY29tbWl0IG9mIGFib3J0ZWQgdHJhbnNhY3Rpb24uCkp1biAyOSAyMzo1MToz
NiBkZWJpYW4ga2VybmVsOiBbMTIxNTY2Ni44NjYzNjBdIEJUUkZTOiBlcnJvciAoZGV2aWNl
IHNkZikgaW4gY2xlYW51cF90cmFuc2FjdGlvbjoxODczOiBlcnJubz0tNSBJTyBmYWlsdXJl
Ckp1biAyOSAyMzo1MTozNiBkZWJpYW4ga2VybmVsOiBbMTIxNTY2Ni44NjgzMDVdIEJUUkZT
IGVycm9yIChkZXZpY2Ugc2RmKTogY29tbWl0IHN1cGVyIHJldCAtNQpKdW4gMjkgMjM6NTE6
MzYgZGViaWFuIGtlcm5lbDogWzEyMTU2NjYuODY5ODQ5XSBCVFJGUyBlcnJvciAoZGV2aWNl
IHNkZik6IGNsZWFuZXIgdHJhbnNhY3Rpb24gYXR0YWNoIHJldHVybmVkIC0zMAo=
--------------09CF967D2415FA036A2B9522--
