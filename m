Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from thorus.sichert.me ([78.47.115.25]:42248 "EHLO thorus.sichert.me"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdCYWKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2017 18:10:12 -0400
Received: from [192.168.133.20] (host8-2.natpool.mwn.de [138.246.2.8])
        by thorus.sichert.me (Postfix) with ESMTPSA id 0C948D8
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Mar 2017 22:03:27 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Moritz Sichert <moritz+linux@sichert.me>
Subject: Qgroups are not applied when snapshotting a subvol?
Message-ID: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
Date: Sat, 25 Mar 2017 23:03:26 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------AE8947224FE49117CA6EFAA0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------AE8947224FE49117CA6EFAA0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I tried to configure qgroups on a btrfs filesystem but was really surprised that when you snapshot a subvolume, the snapshot will not be assigned to the qgroup the subvolume was in.

As an example consider the small terminal session in the attachment: I create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on that qgroup. Then I write a file into A and eventually get "disk quota exceeded". Then I create a snapshot of A and call it B. B will not be assigned to 1/1 and writing a file into B confirms that no limits at all are imposed for B.

I feel like I must be missing something here. Considering that creating a snapshot does not require root privileges this would mean that any user can just circumvent any quota and therefore make them useless.

Is there a way to enforce quotas even when a user creates snapshots?


Moritz

--------------AE8947224FE49117CA6EFAA0
Content-Type: text/plain; charset=UTF-8;
 name="btrfs-qgroups.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="btrfs-qgroups.txt"

JCBidHJmcyBxdW90YSBlbmFibGUgLg0KJCBidHJmcyBzdWJ2b2x1bWUgY3JlYXRlIEENCkNy
ZWF0ZSBzdWJ2b2x1bWUgJy4vQScNCiQgYnRyZnMgcWdyb3VwIGNyZWF0ZSAxLzEgLg0KJCBi
dHJmcyBxZ3JvdXAgc2hvdyAtcCAtLXN5bmMgLg0KcWdyb3VwaWQgICAgICAgICByZmVyICAg
ICAgICAgZXhjbCBwYXJlbnQgIA0KLS0tLS0tLS0gICAgICAgICAtLS0tICAgICAgICAgLS0t
LSAtLS0tLS0gIA0KMC81ICAgICAgICAgIDE2LjAwS2lCICAgICAxNi4wMEtpQiAtLS0gICAg
IA0KMC8yNTcgICAgICAgIDE2LjAwS2lCICAgICAxNi4wMEtpQiAtLS0gICAgIA0KMS8xICAg
ICAgICAgICAgIDAuMDBCICAgICAgICAwLjAwQiAtLS0gICAgIA0KJCBidHJmcyBxZ3JvdXAg
YXNzaWduIDAvMjU3IDEvMSAuDQokIGJ0cmZzIHFncm91cCBsaW1pdCA1TSAxLzEgLg0KJCBk
ZCBpZj0vZGV2L3VyYW5kb20gb2Y9QS9mb28gYnM9MU0gY291bnQ9NA0KNCswIHJlY29yZHMg
aW4NCjQrMCByZWNvcmRzIG91dA0KNDE5NDMwNCBieXRlcyAoNC4yIE1CLCA0LjAgTWlCKSBj
b3BpZWQsIDAuMDUyOTI1NSBzLCA3OS4yIE1CL3MNCiQgYnRyZnMgcWdyb3VwIHNob3cgLXAg
LS1zeW5jIC4NCnFncm91cGlkICAgICAgICAgcmZlciAgICAgICAgIGV4Y2wgcGFyZW50ICAN
Ci0tLS0tLS0tICAgICAgICAgLS0tLSAgICAgICAgIC0tLS0gLS0tLS0tICANCjAvNSAgICAg
ICAgICAxNi4wMEtpQiAgICAgMTYuMDBLaUIgLS0tICAgICANCjAvMjU3ICAgICAgICAgNC4w
Mk1pQiAgICAgIDQuMDJNaUIgMS8xICAgICANCjEvMSAgICAgICAgICAgNC4wMk1pQiAgICAg
IDQuMDJNaUIgLS0tICAgICANCiQgZGQgaWY9L2Rldi91cmFuZG9tIG9mPUEvYmFyIGJzPTFN
IGNvdW50PTQNCmRkOiBlcnJvciB3cml0aW5nICdBL2Jhcic6IERpc2sgcXVvdGEgZXhjZWVk
ZWQNCjErMCByZWNvcmRzIGluDQowKzAgcmVjb3JkcyBvdXQNCjkxNzUwNCBieXRlcyAoOTE4
IGtCLCA4OTYgS2lCKSBjb3BpZWQsIDAuMDA0MDgwNjggcywgMjI1IE1CL3MNCiQgYnRyZnMg
c3Vidm9sdW1lIHNuYXBzaG90IEEgQg0KQ3JlYXRlIGEgc25hcHNob3Qgb2YgJ0EnIGluICcu
L0InDQokIGJ0cmZzIHFncm91cCBzaG93IC1wIC0tc3luYyAuDQpxZ3JvdXBpZCAgICAgICAg
IHJmZXIgICAgICAgICBleGNsIHBhcmVudCAgDQotLS0tLS0tLSAgICAgICAgIC0tLS0gICAg
ICAgICAtLS0tIC0tLS0tLSAgDQowLzUgICAgICAgICAgMTYuMDBLaUIgICAgIDE2LjAwS2lC
IC0tLSAgICAgDQowLzI1NyAgICAgICAgIDQuODlNaUIgICAgIDE2LjAwS2lCIDEvMSAgICAg
DQowLzI1OCAgICAgICAgIDQuODlNaUIgICAgIDE2LjAwS2lCIC0tLSAgICAgDQoxLzEgICAg
ICAgICAgIDQuODlNaUIgICAgICA0Ljg5TWlCIC0tLSAgICAgDQokIGRkIGlmPS9kZXYvdXJh
bmRvbSBvZj1CL2JheiBicz0xTSBjb3VudD00DQo0KzAgcmVjb3JkcyBpbg0KNCswIHJlY29y
ZHMgb3V0DQo0MTk0MzA0IGJ5dGVzICg0LjIgTUIsIDQuMCBNaUIpIGNvcGllZCwgMC4wMTc0
NDY3IHMsIDI0MCBNQi9zDQokIGJ0cmZzIHFncm91cCBzaG93IC1wIC0tc3luYyAuDQpxZ3Jv
dXBpZCAgICAgICAgIHJmZXIgICAgICAgICBleGNsIHBhcmVudCAgDQotLS0tLS0tLSAgICAg
ICAgIC0tLS0gICAgICAgICAtLS0tIC0tLS0tLSAgDQowLzUgICAgICAgICAgMTYuMDBLaUIg
ICAgIDE2LjAwS2lCIC0tLSAgICAgDQowLzI1NyAgICAgICAgIDQuODlNaUIgICAgIDE2LjAw
S2lCIDEvMSAgICAgDQowLzI1OCAgICAgICAgIDguODlNaUIgICAgICA0LjAyTWlCIC0tLSAg
ICAgDQoxLzEgICAgICAgICAgIDQuODlNaUIgICAgICA0Ljg5TWlCIC0tLQo=
--------------AE8947224FE49117CA6EFAA0--
