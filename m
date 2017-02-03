Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:38700 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750956AbdBCPo7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Feb 2017 10:44:59 -0500
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
 <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
 <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
 <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
 <pan$e2f8a$ba778439$cd53e97c$382283f9@cox.net>
 <092c2028-f132-83b1-5f10-d84d374a8bb3@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <a85af6d8-fdcd-1039-3c0e-a4486ff0bb0a@cobb.uk.net>
Date: Fri, 3 Feb 2017 15:44:53 +0000
MIME-Version: 1.0
In-Reply-To: <092c2028-f132-83b1-5f10-d84d374a8bb3@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------51BC90FC5258C1F7A2CBF0E3"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------51BC90FC5258C1F7A2CBF0E3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 03/02/17 12:44, Austin S. Hemmelgarn wrote:
> I can look at making a patch for this, but it may be next week before I
> have time (I'm not great at multi-tasking when it comes to software
> development, and I'm in the middle of helping to fix a bug in Ansible
> right now).

That would be great, Austin! It is about 15 years since I last submitted
a patch under kernel development patch rules and things have changed a
fair bit in that time. So if you are set up to do it that sounds good.

As a starting point, I have created a suggested text (patch attached).





--------------51BC90FC5258C1F7A2CBF0E3
Content-Type: text/plain; charset=UTF-8;
 name="btrfs-receive-rw-window"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs-receive-rw-window"

ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vYnRyZnMtcmVjZWl2ZS5hc2NpaWRvYyBiL0Rv
Y3VtZW50YXRpb24vYnRyZnMtcmVjZWl2ZS5hc2NpaWRvYwppbmRleCA2YmU0YWE2Li5kYjUy
NWQ5IDEwMDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL2J0cmZzLXJlY2VpdmUuYXNjaWlkb2MK
KysrIGIvRG9jdW1lbnRhdGlvbi9idHJmcy1yZWNlaXZlLmFzY2lpZG9jCkBAIC0zMSw3ICsz
MSw3IEBAIHRoZSBzdHJlYW0sIGFuZCBwcmludCB0aGUgc3RyZWFtIG1ldGFkYXRhLCBvbmUg
b3BlcmF0aW9uIHBlciBsaW5lLgogCiAzLiBkZWZhdWx0IHN1YnZvbHVtZSBoYXMgY2hhbmdl
ZCBvciB5b3UgZGlkbid0IG1vdW50IHRoZSBmaWxlc3lzdGVtIGF0IHRoZSB0b3BsZXZlbCBz
dWJ2b2x1bWUKIAotQSBzdWJ2b2x1bWUgaXMgbWFkZSByZWFkLW9ubHkgYWZ0ZXIgdGhlIHJl
Y2VpdmluZyBwcm9jZXNzIGZpbmlzaGVzIHN1Y2Nlc2Z1bGx5LgorQSBzdWJ2b2x1bWUgaXMg
bWFkZSByZWFkLW9ubHkgYWZ0ZXIgdGhlIHJlY2VpdmluZyBwcm9jZXNzIGZpbmlzaGVzIHN1
Y2Nlc2Z1bGx5IChzZWUgQlVHUyBiZWxvdykuCiAKIGBPcHRpb25zYAogCkBAIC03Myw2ICs3
MywxNiBAQCBFWElUIFNUQVRVUwogKmJ0cmZzIHJlY2VpdmUqIHJldHVybnMgYSB6ZXJvIGV4
aXQgc3RhdHVzIGlmIGl0IHN1Y2NlZWRzLiBOb24gemVybyBpcwogcmV0dXJuZWQgaW4gY2Fz
ZSBvZiBmYWlsdXJlLgogCitCVUdTCistLS0tCisqYnRyZnMgcmVjZWl2ZSogc2V0cyB0aGUg
c3Vidm9sdW1lIHJlYWQtb25seSBhZnRlciBpdCBjb21wbGV0ZXMgc3VjY2Vzc2Z1bGx5Lgor
SG93ZXZlciwgd2hpbGUgdGhlIHJlY2VpdmUgaXMgaW4gcHJvZ3Jlc3MsIHVzZXJzIHdobyBo
YXZlIHdyaXRlIGFjY2VzcyB0byBmaWxlcworb3IgZGlyZWN0b3JpZXMgaW4gdGhlIHJlY2Vp
dmluZyAncGF0aCcgY2FuIGFkZCwgcmVtb3ZlIG9yIG1vZGlmeSBmaWxlcywgaW4gd2hpY2gK
K2Nhc2UgdGhlIHJlc3VsdGluZyByZWFkLW9ubHkgc3Vidm9sdW1lIHdpbGwgbm90IGJlIGEg
Y29weSBvZiB0aGUgc2VuZGluZyBzdWJ2b2x1bWUuCisKK0lmIHRoZSBpbnRlbnRpb24gaXMg
dG8gY3JlYXRlIGFuIGV4YWN0IGNvcHksIHRoZSByZWNlaXZpbmcgJ3BhdGgnIHNob3VsZCBi
ZSBwcm90ZWN0ZWQKK2Zyb20gYWNjZXNzIGJ5IHVzZXJzIHVudGlsIHRoZSByZWNlaXZlIGhh
cyBjb21wbGV0ZWQgYW5kIHRoZSBzdWJ2b2x1bWUgc2V0IHRvIHJlYWQtb25seS4KKwogQVZB
SUxBQklMSVRZCiAtLS0tLS0tLS0tLS0KICpidHJmcyogaXMgcGFydCBvZiBidHJmcy1wcm9n
cy4K
--------------51BC90FC5258C1F7A2CBF0E3--
