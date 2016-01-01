Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:32768 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbcAABJQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 20:09:16 -0500
Received: by mail-io0-f170.google.com with SMTP id q21so101204682iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Dec 2015 17:09:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN05THS2=MFKwETJMPDz_FntDVFwfgbaY4Aros9=B4rhOF91qQ@mail.gmail.com>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
	<CAN05THS2=MFKwETJMPDz_FntDVFwfgbaY4Aros9=B4rhOF91qQ@mail.gmail.com>
Date: Thu, 31 Dec 2015 17:09:15 -0800
Message-ID: <CAN05THSvLdPvt9LmM4TLG-JWBQdRKNtEjrAkTX9jjL6r8kG8pA@mail.gmail.com>
Subject: Re: btrfs fail behavior when a device vanishes
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=94eb2c0866387fad0305283b6bbb
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--94eb2c0866387fad0305283b6bbb
Content-Type: text/plain; charset=UTF-8

Here is a kludge I hacked up.
Someone that cares could clean this up and start building a proper
test suite or something.

This test script creates a 3 disk raid1 filesystem and very slowly
writes a large file onto the filesystem while, one by one each disk is
disconnected then reconnected in a loop.
It is fairly trivial to trigger dataloss when devices are bounced like this.

You have to run the script as root due to the calls to [u]mount and iscsiadm




On Thu, Dec 31, 2015 at 1:23 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> On Thu, Dec 31, 2015 at 12:11 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> This is a torture test, no data is at risk.
>>
>> Two devices, btrfs raid1 with some stuff on them.
>> Copy from that array, elsewhere.
>> During copy, yank the active device.
>>
>> dmesg shows many of these:
>>
>> [ 7179.373245] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
>> 652123, rd 697237, flush 0, corrupt 0, gen 0
>
> For automated tests a good way could be to build a multi device btrfs filesystem
> ontop of it.
> For example STGT exporting n# volumes and then mount via the loopback interface.
> Then you could just use tgtadm to add / remove the device in a
> controlled fashion and to any filesystem it will look exactly like if
> you pulled the device physically.
>
> This allows you to run fully automated and scripted "how long before
> the filesystem goes into total dataloss mode" tests.
>
>
>
> If you want more fine control than just plug/unplug on a live
> filesystem , you can use
> https://github.com/rsahlberg/flaky-stgt
> Again, this uses iSCSI but it allows you to script event such as
> "this range of blocks are now Uncorrectable read error" etc.
> To automatically stress test that the filesystem can deal with it.
>
>
> I created this STGT fork so that filesystem testers would have a way
> to automate testing of their failure paths.
> In particular for BTRFS which seems to still be incredible fragile
> when devices fail or disconnect.
>
> Unfortunately I don't think anyone cared very much. :-(
> Please BTRFS devs,  please use something like this for testing of
> failure modes and robustness. Please!
>
>
>
>>
>> Why are the write errors nearly as high as the read errors, when there
>> is only a copy from this device happening?
>>
>> Is Btrfs trying to write the read error count (for dev stats) of sdc1
>> onto sdc1, and that causes a write error?
>>
>> Also, is there a command to make a block device go away? At least in
>> gnome shell when I eject a USB stick, it isn't just umounted, it no
>> longer appears with lsblk or blkid, so I'm wondering if there's a way
>> to vanish a misbehaving device so that Btrfs isn't bogged down with a
>> flood of retries.
>>
>> In case anyone is curious, the entire dmesg from device insertion,
>> formatting, mounting, copying to then from, and device yanking is here
>> (should be permanent):
>> http://pastebin.com/raw/Wfe1pY4N
>>
>> And the copy did successfully complete anyway, and the resulting files
>> have the same hashes as their originals. So, yay, despite the noisy
>> messages.
>>
>>
>> --
>> Chris Murphy
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--94eb2c0866387fad0305283b6bbb
Content-Type: application/x-sh; name="test_0100_write_raid1_unplug.sh"
Content-Disposition: attachment; filename="test_0100_write_raid1_unplug.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iiuzctil0

IyEvYmluL3NoCgouIC4vZnVuY3Rpb25zLnNoCkJUUkZTTU5UPWBwd2RgL01OVApUTVA9UkFORE9N
CgplY2hvICJCYXNpYyBQbHVnIC8gVW5wbHVnIHRlc3RzIgoKc3RhcnRfdGFyZ2V0CmNyZWF0ZV9k
aXNrX2x1biAxIDFHCmNyZWF0ZV9kaXNrX2x1biAyIDFHCmNyZWF0ZV9kaXNrX2x1biAzIDFHCgpl
Y2hvICJNb3VudGluZyBpU0NTSSBkZXZpY2VzIC4uLiAiCmlzY3NpYWRtIC0tbW9kZSBkaXNjb3Zl
cnlkYiAtLXR5cGUgc2VuZHRhcmdldHMgLS1wb3J0YWwgJHtUR1RQT1JUQUx9IC0tZGlzY292ZXIK
aXNjc2lhZG0gLS1tb2RlIG5vZGUgLS10YXJnZXRuYW1lICR7SVFOVEFSR0VUfSAtLXBvcnRhbCAk
e1RHVFBPUlRBTH0gLS1sb2dpbgoKZWNobyAiQ3JlYXRlIGEgdGhyZWUgZGV2aWNlIEJUUkZTIGZp
bGVzeXN0ZW0iCnNsZWVwIDUgIyBLbHVkZ2UgdG8gd2FpdCBmb3IgdGhlIGRldmljZXMgdG8gc2hv
dyB1cApta2ZzLmJ0cmZzIC1mIC1kIHJhaWQxIC9kZXYvZGlzay9ieS1wYXRoL2lwLTEyNy4wLjAu
MTozMjY5LWlzY3NpLWlxbi5saWJpc2NzaS51bml0dGVzdC50YXJnZXQtbHVuLTEgL2Rldi9kaXNr
L2J5LXBhdGgvaXAtMTI3LjAuMC4xOjMyNjktaXNjc2ktaXFuLmxpYmlzY3NpLnVuaXR0ZXN0LnRh
cmdldC1sdW4tMiAvZGV2L2Rpc2svYnktcGF0aC9pcC0xMjcuMC4wLjE6MzI2OS1pc2NzaS1pcW4u
bGliaXNjc2kudW5pdHRlc3QudGFyZ2V0LWx1bi0zCgplY2hvICJNb3VudGluZyB0aGUgZmlsZXN5
c3RlbSIKbWtkaXIgJHtCVFJGU01OVH0gMj4vZGV2L251bGwKbW91bnQgL2Rldi9kaXNrL2J5LXBh
dGgvaXAtMTI3LjAuMC4xOjMyNjktaXNjc2ktaXFuLmxpYmlzY3NpLnVuaXR0ZXN0LnRhcmdldC1s
dW4tMSAke0JUUkZTTU5UfQoKZWNobyAiQ3JlYXRpbmcgNTEyTUIgcmFuZG9tIGZpbGUiCmRkIGlm
PS9kZXYvdXJhbmRvbSBvZj1SQU5ET00gYnM9MU0gY291bnQ9NSAyPi9kZXYvbnVsbAoKZWNobyAi
Q29weSB0aGUgZmlsZSB0byBCVFJGUyAoc2xvd2x5KSIKcnN5bmMgLVBhdiAtLWJ3bGltaXQ9MTAy
NEsgUkFORE9NICR7QlRSRlNNTlR9L1JBTkRPTSAmCgplY2hvICJEaXNjb25uZWN0L3JlY29ubmVj
dCB0aGUgZGV2aWNlcyB3aGlsZSB0aGUgc2xvdyByc3luYyBpcyBydW5uaW5nIgpzZXEgMSAyMiB8
IHdoaWxlIHJlYWQgSVRFUkFUSU9OOyBkbwoJICAgICAgIGVjaG8gIlxuUmVtb3ZpbmcgZGlzayAx
IgoJICAgICAgIHJlbW92ZV9kaXNrX2x1biAxCgkgICAgICAgc2xlZXAgNQoJICAgICAgIGVjaG8g
IlxuUmVhZGRpbmcgZGlzayAxIgoJICAgICAgIGFkZF9kaXNrX2x1biAxIDFHCgkgICAgICAgc2xl
ZXAgNQoJICAgICAgIGVjaG8gIlxuUmVtb3ZpbmcgZGlzayAyIgoJICAgICAgIHJlbW92ZV9kaXNr
X2x1biAyCgkgICAgICAgc2xlZXAgNQoJICAgICAgIGVjaG8gIlxuUmVhZGRpbmcgZGlzayAyIgoJ
ICAgICAgIGFkZF9kaXNrX2x1biAyIDFHCgkgICAgICAgc2xlZXAgNQoJICAgICAgIGVjaG8gIlxu
UmVtb3ZpbmcgZGlzayAzIgoJICAgICAgIHJlbW92ZV9kaXNrX2x1biAzCgkgICAgICAgc2xlZXAg
NQoJICAgICAgIGVjaG8gIlxuUmVhZGRpbmcgZGlzayAzIgoJICAgICAgIGFkZF9kaXNrX2x1biAz
IDFHCgkgICAgICAgc2xlZXAgNQpkb25lCgplY2hvICJSZW1vdW50IHRoZSBmaWxlc3lzdGVtIHRv
IGRyb3AgY2FjaGVzIgp1bW91bnQgJHtCVFJGU01OVH0KbW91bnQgL2Rldi9kaXNrL2J5LXBhdGgv
aXAtMTI3LjAuMC4xOjMyNjktaXNjc2ktaXFuLmxpYmlzY3NpLnVuaXR0ZXN0LnRhcmdldC1sdW4t
MSAke0JUUkZTTU5UfQoKZWNobyAiQ29tcHV0aW5nIGNoZWNrc3VtcyIKT1JJR1NVTT1gbWQ1c3Vt
IFJBTkRPTSB8IGN1dCAtZiAxIC1kICIgImAKTkVXU1VNPWBtZDVzdW0gJHtCVFJGU01OVH0vUkFO
RE9NIHwgY3V0IC1mIDEgLWQgIiAiYAplY2hvICJPcmlnaW5hbCBjaGVja3N1bSIgJHtPUklHU1VN
fQplY2hvICJOZXcgY2hlY2tzdW0iICR7TkVXU1VNfQoKaWYgWyAiJHtPUklHU1VNfXgiID09ICIk
e05FV1NVTX14IiBdIDsgdGhlbgogICAgZWNobyAiU1VDQ0VTUy4gQ2hlY2tzdW1zIG1hdGNoIgpl
bHNlCiAgICBlY2hvICJGQUlMRUQuIENoZWNrc3VtIG1pc21hdGNoIgpmaQoKZWNobyAiQ2xlYW5p
bmcgdXAiCnJtIFJBTkRPTQp1bW91bnQgJHtCVFJGU01OVH0KaXNjc2lhZG0gLS1tb2RlIG5vZGUg
LS10YXJnZXRuYW1lICR7SVFOVEFSR0VUfSAtLXBvcnRhbCAke1RHVFBPUlRBTH0gLS1sb2dvdXQK
CmRlbGV0ZV9kaXNrX2x1biAxCmRlbGV0ZV9kaXNrX2x1biAyCmRlbGV0ZV9kaXNrX2x1biAzCnNo
dXRkb3duX3RhcmdldAoKZXhpdCAwCg==
--94eb2c0866387fad0305283b6bbb
Content-Type: application/x-sh; name="functions.sh"
Content-Disposition: attachment; filename="functions.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_iiuzd1601

ZXhwb3J0IFRHVF9JUENfU09DS0VUPWBwd2RgL3RndGQuc29ja2V0IAoKVEdURD0idGd0ZCIKVEdU
QURNPSJ0Z3RhZG0iClRHVExVTj1gcHdkYC9MVU4KVEdUUE9SVEFMPTEyNy4wLjAuMTozMjY5CgpJ
UU5UQVJHRVQ9aXFuLmxpYmlzY3NpLnVuaXR0ZXN0LnRhcmdldApJUU5JTklUSUFUT1I9aXFuLmxp
YmlzY3NpLnVuaXR0ZXN0LmluaXRpYXRvcgpUR1RVUkw9aXNjc2k6Ly8ke1RHVFBPUlRBTH0vJHtJ
UU5UQVJHRVR9LzEKCnN0YXJ0X3RhcmdldCgpIHsKICAgICMgaW4gY2FzZSB3ZSBoYXZlIG9uZSBz
dGlsbCBydW5uaW5nIGZyb20gYSBwcmV2aW91cyBydW4KICAgICR7VEdUQURNfSAtLW9wIGRlbGV0
ZSAtLWZvcmNlIC0tbW9kZSB0YXJnZXQgLS10aWQgMSAyPi9kZXYvbnVsbAogICAgJHtUR1RBRE19
IC0tb3AgZGVsZXRlIC0tbW9kZSBzeXN0ZW0gMj4vZGV2L251bGwKICAgICMgU2V0dXAgdGFyZ2V0
CiAgICBlY2hvICJTdGFydGluZyBpU0NTSSB0YXJnZXQiCiAgICAke1RHVER9IC0taXNjc2kgcG9y
dGFsPSR7VEdUUE9SVEFMfSwkezF9CiAgICBzbGVlcCAxCiAgICAke1RHVEFETX0gLS1vcCBuZXcg
LS1tb2RlIHRhcmdldCAtLXRpZCAxIC1UICR7SVFOVEFSR0VUfQogICAgJHtUR1RBRE19IC0tb3Ag
YmluZCAtLW1vZGUgdGFyZ2V0IC0tdGlkIDEgLUkgQUxMCiAgICAjJHtUR1RBRE19IC0tb3Agc2hv
dyAtLW1vZGUgdGFyZ2V0Cn0KCnNodXRkb3duX3RhcmdldCgpIHsKICAgICMgUmVtb3ZlIHRhcmdl
dAogICAgZWNobyAiU2h1dHRpbmcgZG93biBpU0NTSSB0YXJnZXQiCiAgICAke1RHVEFETX0gLS1v
cCBkZWxldGUgLS1mb3JjZSAtLW1vZGUgdGFyZ2V0IC0tdGlkIDEKICAgICR7VEdUQURNfSAtLW9w
IGRlbGV0ZSAtLW1vZGUgc3lzdGVtCn0KCmNyZWF0ZV9sdW4oKSB7CiAgICAjIFNldHVwIExVTgog
ICAgdHJ1bmNhdGUgLS1zaXplPTEwME0gJHtUR1RMVU59CiAgICAke1RHVEFETX0gLS1vcCBuZXcg
LS1tb2RlIGxvZ2ljYWx1bml0IC0tdGlkIDEgLS1sdW4gMSAtYiAke1RHVExVTn0gLS1ibG9ja3Np
emU9NDA5Ngp9CgpkZWxldGVfbHVuKCkgewogICAgIyBSZW1vdmUgTFVOCiAgICBybSAke1RHVExV
Tn0KfQoKY3JlYXRlX2Rpc2tfbHVuKCkgewogICAgIyBTZXR1cCBMVU4KICAgIHRydW5jYXRlIC0t
c2l6ZT0kMiAke1RHVExVTn0uJDEKICAgICR7VEdUQURNfSAtLW9wIG5ldyAtLW1vZGUgbG9naWNh
bHVuaXQgLS10aWQgMSAtLWx1biAkMSAtYiAke1RHVExVTn0uJDEgLS1ibG9ja3NpemU9NTEyCn0K
CmRlbGV0ZV9kaXNrX2x1bigpIHsKICAgICMgUmVtb3ZlIExVTgogICAgcm0gJHtUR1RMVU59LiQx
Cn0KCmFkZF9kaXNrX2x1bigpIHsKICAgICR7VEdUQURNfSAtLW9wIG5ldyAtLW1vZGUgbG9naWNh
bHVuaXQgLS10aWQgMSAtLWx1biAkMSAtYiAke1RHVExVTn0uJDEgLS1ibG9ja3NpemU9NTEyCn0K
CnJlbW92ZV9kaXNrX2x1bigpIHsKICAgICR7VEdUQURNfSAtLW9wIGRlbGV0ZSAtLW1vZGUgbG9n
aWNhbHVuaXQgLS10aWQgMSAtLWx1biAkMQp9CgpzZXR1cF9jaGFwKCkgewogICAgJHtUR1RBRE19
IC0tb3AgbmV3IC0tbW9kZSBhY2NvdW50IC0tdXNlciBsaWJpc2NzaSAtLXBhc3N3b3JkIGxpYmlz
Y3NpCiAgICAke1RHVEFETX0gLS1vcCBiaW5kIC0tbW9kZSBhY2NvdW50IC0tdGlkIDEgLS11c2Vy
IGxpYmlzY3NpCgogICAgJHtUR1RBRE19IC0tb3AgbmV3IC0tbW9kZSBhY2NvdW50IC0tdXNlciBv
dXRnb2luZyAtLXBhc3N3b3JkIG91dGdvaW5nCiAgICAke1RHVEFETX0gLS1vcCBiaW5kIC0tbW9k
ZSBhY2NvdW50IC0tdGlkIDEgLS11c2VyIG91dGdvaW5nIC0tb3V0Z29pbmcKfQoKc3VjY2Vzcygp
IHsKICAgIGVjaG8gIltPS10iCiAgICBybSAke1RFU1RfVE1QfSAyPiAvZGV2L251bGwKfQoKZmFp
bHVyZSgpIHsKICAgIGVjaG8gIltGQUlMRURdIgogICAgZXhpdCAxCn0K
--94eb2c0866387fad0305283b6bbb--
