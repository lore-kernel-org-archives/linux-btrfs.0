Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:51595 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbcDDTdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 15:33:00 -0400
Received: by mail-vk0-f49.google.com with SMTP id c4so68279703vkb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 12:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FF1D4C.9030200@oracle.com>
References: <20160318193937.GA21352@jek-Latitude-E7440>
	<56FA9420.8020503@oracle.com>
	<20160329194722.GC27148@jeknote.loshitsa1.net>
	<56FF1D4C.9030200@oracle.com>
Date: Mon, 4 Apr 2016 12:32:55 -0700
Message-ID: <CAKWEGV7BOq-_AFaDyAaLd1hs=HVxSf+wka7++U+QG7R=diYT=w@mail.gmail.com>
Subject: Re: Global hotspare functionality
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=001a1143e9b6a72ebf052fadcb82
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--001a1143e9b6a72ebf052fadcb82
Content-Type: text/plain; charset=UTF-8

2016-04-01 18:15 GMT-07:00 Anand Jain <anand.jain@oracle.com>:
>>>> Issue 2.
>>>> At start of autoreplacig drive by hotspare, kernel craches in
>>>> transaction
>>>> handling code (inside of btrfs_commit_transaction() called by
>>>> autoreplace initiating
>>>> routines). I 'fixed' this by removing of closing of bdev in
>>>> btrfs_close_one_device_dont_free(), see
>>>>
>>>> https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
>>>> (oops text is attached also). Bdev is closed after replacing by
>>>> btrfs_dev_replace_finishing(), so this is safe but doesn't seem
>>>> to be right way.
>>>
>>>
>>>   I have sent out V2. I don't see that issue with this,
>>>   could you pls try ?
>>
>>
>> Yes, it reproduced on v4.4.5 kernel. I will try with current
>> 'for-linus-4.6' Chris' tree soon.
>>
>> To emulate a drive failure, I disconnect the drive in VirtualBox, so bdev
>> can be freed by kernel after releasing of all references to it.
>
>
>   So far the raid group profile would adapt to lower suitable
>   group profile when device is missing/failed. This appears to
>   be not happening with RAID56 OR there are stale IO which wasn't
>   flushed out. Anyway to have this fixed I am moving the patch
>    btrfs: introduce device dynamic state transition to offline or failed
>   to the top in v3 for any potential changes.
>   But firstly we need a reliable test case, or a very carefully
>   crafted test case which can create this situation
>
>   Here below is the dm-error that I am using for testing, which
>   apparently doesn't report this issue. Could you please try on V3. ?
>   (pls note the device names are hard coded in the test script
>   sorry about that) This would eventually be fstests script.

Hi,

I have reproduced this oops with attached script. I don't use any dm
layer, but just detach drive at scsi layer as xfstests do (device
management functions were copy-pasted from it).

--001a1143e9b6a72ebf052fadcb82
Content-Type: application/x-sh; name="test-autoreplace2-mainline.sh"
Content-Disposition: attachment; filename="test-autoreplace2-mainline.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imme91bl0

IyEvYmluL2Jhc2gKCk1OVD0kMQpzaGlmdApESVNLUz0oICRAICkKCmRldl9yZW1vdmVkPTAKcmVt
b3ZlZF9kZXZfaHRsPSIiCgpfZmFpbCAoKSB7CgllY2hvICRACglfY2xlYW51cAoJZXhpdCAxCn0K
CiMgYXJnIDEgaXMgZGV2IHRvIHJlbW92ZSBhbmQgaXMgb3V0cHV0IG9mIHRoZSBiZWxvdyBlZy4K
IyBscyAtbCAvc3lzL2NsYXNzL2Jsb2NrL3NkZCB8IHJldiB8IGN1dCAtZCAiLyIgLWYgMyB8IHJl
dgpfZGV2bWd0X3JlbW92ZSgpCnsKCWxvY2FsIGx1bj0kMQoJbG9jYWwgZGlzaz0kMgoKCWVjaG8g
MSA+IC9zeXMvY2xhc3Mvc2NzaV9kZXZpY2UvJHtsdW59L2RldmljZS9kZWxldGUgfHwgX2ZhaWwg
IlJlbW92ZSBkaXNrIGZhaWxlZCIKCglzdGF0ICRkaXNrID4gL2Rldi9udWxsIDI+JjEKCXdoaWxl
IFsgJD8gLWVxIDAgXTsgZG8KCQlzbGVlcCAxCgkJc3RhdCAkZGlzayA+IC9kZXYvbnVsbCAyPiYx
Cglkb25lCn0KCiMgYXJnIDEgaXMgZGV2IHRvIGFkZCBhbmQgaXMgb3V0cHV0IG9mIHRoZSBiZWxv
dyBlZy4KIyBscyAtbCAvc3lzL2NsYXNzL2Jsb2NrL3NkZCB8IHJldiB8IGN1dCAtZCAiLyIgLWYg
MyB8IHJldgpfZGV2bWd0X2FkZCgpCnsKCWxvY2FsIGgKCWxvY2FsIHRkbAoJIyBhcmcgMSB3aWxs
IGJlIGluIGg6dDpkOmwgZm9ybWF0IG5vdyBpbiB0aGUgaCBhbmQgInQgZCBsIiBmb3JtYXQKCWg9
YGVjaG8gJHsxfSB8IGN1dCAtZCI6IiAtZiAxYAoJdGRsPWBlY2hvICR7MX0gfCBjdXQgLWQiOiIg
LWYgMi18c2VkICdzLzovIC9nJ2AKCgllY2hvICR7dGRsfSA+ICAvc3lzL2NsYXNzL3Njc2lfaG9z
dC9ob3N0JHtofS9zY2FuIHx8IF9mYWlsICJBZGQgZGlzayBmYWlsZWQiCgoJIyBlbnN1cmUgdGhl
IGRldmljZSBjb21lcyBvbmxpbmUKCWRldl9iYWNrX29uZWxpbmU9MAoJZm9yIGkgaW4gYHNlcSAx
IDEwYDsgZG8KCQlpZiBbIC1kIC9zeXMvY2xhc3Mvc2NzaV9kZXZpY2UvJHsxfS9kZXZpY2UvYmxv
Y2sgXTsgdGhlbgoJCQlkZXY9YGxzIC9zeXMvY2xhc3Mvc2NzaV9kZXZpY2UvJHsxfS9kZXZpY2Uv
YmxvY2tgCgkJCWZvciBqIGluIGBzZXEgMSAxMGA7CgkJCWRvCgkJCQlzdGF0IC9kZXYvJGRldiA+
IC9kZXYvbnVsbCAyPiYxCgkJCQlpZiBbICQ/IC1lcSAwIF07IHRoZW4KCQkJCQlkZXZfYmFja19v
bmVsaW5lPTEKCQkJCQlicmVhawoJCQkJZmkKCQkJCXNsZWVwIDEKCQkJZG9uZQoJCQlicmVhawoJ
CWVsc2UKCQkJc2xlZXAgMQoJCWZpCglkb25lCglpZiBbICRkZXZfYmFja19vbmVsaW5lIC1lcSAw
IF07IHRoZW4KCQllY2hvICIvZGV2LyRkZXYgb25saW5lIGZhaWxlZCIKCWVsc2UKCQllY2hvICIv
ZGV2LyRkZXYgaXMgYmFjayBvbmxpbmUiCglmaQp9CgoKCgp0cmFwICJfY2xlYW51cDsgZXhpdCBc
JHN0YXR1cyIgMCAxIDIgMyAxNQoKX2NsZWFudXAoKSB7Cgl1bW91bnQgJE1OVCA+L2Rldi9udWxs
IDI+JjEKCglpZiBbICRkZXZfcmVtb3ZlZCA9PSAxIF07IHRoZW4KCQlfZGV2bWd0X2FkZCAiJHty
ZW1vdmVkX2Rldl9odGx9IgoJZmkKfQoKCgp3YWl0X2ZvcigpIHsKCWNtZD0kMQoJc3Vic3RyPSQy
CglpbnRlcnZhbD0kMwoKCWlmIFsgLXogIiRpbnRlcnZhbCIgXTsgdGhlbgoJCWludGVydmFsPTEK
CWZpCgoJZWNobyAtbiAiV2FpdGluZyBmb3IgJyRzdWJzdHInIGluIG91dHB1dCBvZiAnJGNtZCcg
Y29tbWFuZC4uLiIKCgl3aGlsZSAhICgkY21kIHwgZ3JlcCAtcSAtZSAiJHN1YnN0ciIpOyBkbwoJ
CVsgJGludGVydmFsIC1ndCAwIF0gJiYgc2xlZXAgJGludGVydmFsCglkb25lCgllY2hvICIgZm91
bmQiCn0KCgppZiBbICQjIC1sdCAyIF07IHRoZW4KCWVjaG8gIlVzYWdlOiAkMCA8RlMgbW91bnRw
b2ludD4gPGRpc2tzPiIgPiYyCglleGl0IDE7CmZpCgpuPSR7I0RJU0tTW0BdfQoKZHM9JHtESVNL
U1tAXTowOiQoKCRuLTEpKX0KCnVtb3VudCAkTU5UID4vZGV2L251bGwgMj4mMQoKCmVjaG8gIiR7
RElTS1NbQF19IC0+ICRNTlQiCgpmb3IgaSBpbiAke0RJU0tTW0BdfTsgZG8KCXdpcGVmcyAtYSAk
aSA+L2Rldi9udWxsIDI+JjEKZG9uZQoKIyBDcmVhdGUgRlMKbWtmcy5idHJmcyAtZCByYWlkNSAt
bSByYWlkNSAkZHMKCiMgQWRkIHNwYXJlIGRldgpzcGFyZT0ke0RJU0tTW0BdOiQoKG4tMSkpOjF9
CmJ0cmZzIHNwYXJlIGFkZCAkc3BhcmUKCm1vdW50ICR7RElTS1NbMF19ICRNTlQKCmRkIGlmPS9k
ZXYvemVybyBvZj0kTU5UL3Rlc3QuZGF0IGJzPTEwTSBjb3VudD0zMAoKZmFpbGVkX2Rpc2s9JHtE
SVNLU1tAXTokKChuLTIpKToxfQojIHJldHJpdmUgdGhlIEhUTCBmb3IgdGhpcyBzY3NpIGRpc2sK
ZD1gZWNobyAkZmFpbGVkX2Rpc2t8Y3V0IC1kIi8iIC1mM2AKcmVtb3ZlZF9kZXZfaHRsPWBscyAt
bCAvc3lzL2NsYXNzL2Jsb2NrLyR7ZH0gfCByZXYgfCBjdXQgLWQgIi8iIC1mIDMgfCByZXZgCgpf
ZGV2bWd0X3JlbW92ZSAke3JlbW92ZWRfZGV2X2h0bH0gJHtmYWlsZWRfZGlza30KZGV2X3JlbW92
ZWQ9MQoKZGQgaWY9L2Rldi96ZXJvIG9mPSRNTlQvdGVzdDIuZGF0IGJzPTEwTSBjb3VudD0zMApz
eW5jCgpidHJmcyBmaSBzaG93ICRNTlQKCnNsZWVwIDMwCgpidHJmcyBmaSBzaG93ICRNTlQKCgoK
--001a1143e9b6a72ebf052fadcb82--
