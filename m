Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44259 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMUgP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 16:36:15 -0400
Received: by mail-oa0-f48.google.com with SMTP id j1so1566606oag.35
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Mar 2013 13:36:15 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 13 Mar 2013 15:36:14 -0500
Message-ID: <CA+fT6Cuhdm5YT5f9y1LFHzaf+pDfgE5x4Z3dqGhXLdkKsM7cSw@mail.gmail.com>
Subject: Segfault with btrfsck
From: John Overman <jbo5112@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8fb207a4832a7804d7d45b8b
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--e89a8fb207a4832a7804d7d45b8b
Content-Type: text/plain; charset=ISO-8859-1

=== Terminal output ===
# mount -o recovery /dev/md0 /mnt/root
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

# dmesg | tail
[58290.395538] device label root devid 1 transid 250160 /dev/md0
[58290.395891] btrfs: enabling auto recovery
[58290.395895] btrfs: disk space caching is enabled
[58290.396388] btrfs bad tree block start 0 139264
[58290.396401] btrfs: failed to read chunk root on md0
[58290.396660] btrfs: open_ctree failed

# btrfsck /dev/md0
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
read block failed check_tree_block
Couldn't read chunk root
Segmentation fault

=======================

I'm having some problems with my btrfs partition.  It showed up around
the same time a disk got ejected from a RAID5 mdadm array, so the two
are probably related.  The array seems to be working properly now (or
thinks it is), having rebuilt itself and completed a full integrity
check  However, the array lists 1196 events and found 180156080
mismatches on the integrity check, so it may be serious issues with my
old disks from a Sun array.  Even if my data is completely ruined
(e.g. `dd if=/dev/urandom of=/dev/md0`), btrfsck should not segfault.
Running `btrfs-show-super -a /dev/md0` appears to work fine, except
"chunk_root_generation" is 12 lower than "generation" and
"dev_item.generation" is 0, but I'm not sure how significant that is.

I'm running 64-bit Linux Mint 14 KDE (Ubuntu 12.10 based), upgraded to
the 3.9-rc1 kernel and latest git pull of the official btrfs-progs as
of March 13, 2013.  It uses gcc 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1).
I have attached my backtrace (with commands I used to generate it).  I
could not find a debug version of libuuid to show where that is
crashing.

P.S.
Is there any hope for my data?  I have at least 1 small subvolume I'd
really like to recover.  Most of the rest is either backed up, copies
of media, or stuff I can download.  If it's all gone, I need to move
on with rebuilding, so I can get back to my normal work environment.

P.P.S.
Sorry if anyone is getting this twice.  The first message (with a core
dump included) did not get a reply, nor was it on the mailing list
archive.

--e89a8fb207a4832a7804d7d45b8b
Content-Type: application/octet-stream; name=backtrace
Content-Disposition: attachment; filename=backtrace
Content-Transfer-Encoding: base64
X-Attachment-Id: f_he8x63to0

IyBnZGIgLi9idHJmc2NrCkdOVSBnZGIgKEdEQikgNy41LXVidW50dQpDb3B5cmlnaHQgKEMpIDIw
MTIgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMuCkxpY2Vuc2UgR1BMdjMrOiBHTlUgR1BM
IHZlcnNpb24gMyBvciBsYXRlciA8aHR0cDovL2dudS5vcmcvbGljZW5zZXMvZ3BsLmh0bWw+ClRo
aXMgaXMgZnJlZSBzb2Z0d2FyZTogeW91IGFyZSBmcmVlIHRvIGNoYW5nZSBhbmQgcmVkaXN0cmli
dXRlIGl0LgpUaGVyZSBpcyBOTyBXQVJSQU5UWSwgdG8gdGhlIGV4dGVudCBwZXJtaXR0ZWQgYnkg
bGF3LiAgVHlwZSAic2hvdyBjb3B5aW5nIgphbmQgInNob3cgd2FycmFudHkiIGZvciBkZXRhaWxz
LgpUaGlzIEdEQiB3YXMgY29uZmlndXJlZCBhcyAieDg2XzY0LWxpbnV4LWdudSIuCkZvciBidWcg
cmVwb3J0aW5nIGluc3RydWN0aW9ucywgcGxlYXNlIHNlZToKPGh0dHA6Ly93d3cuZ251Lm9yZy9z
b2Z0d2FyZS9nZGIvYnVncy8+Li4uClJlYWRpbmcgc3ltYm9scyBmcm9tIC9yb290L2lucy9idHJm
cy1wcm9ncy9idHJmc2NrLi4uZG9uZS4KKGdkYikgcnVuIC9kZXYvbWQwClN0YXJ0aW5nIHByb2dy
YW06IC9yb290L2lucy9idHJmcy1wcm9ncy9idHJmc2NrIC9kZXYvbWQwCndhcm5pbmc6IG5vIGxv
YWRhYmxlIHNlY3Rpb25zIGZvdW5kIGluIGFkZGVkIHN5bWJvbC1maWxlIHN5c3RlbS1zdXBwbGll
ZCBEU08gYXQgMHg3ZmZmZjdmZmEwMDAKW1RocmVhZCBkZWJ1Z2dpbmcgdXNpbmcgbGlidGhyZWFk
X2RiIGVuYWJsZWRdClVzaW5nIGhvc3QgbGlidGhyZWFkX2RiIGxpYnJhcnkgIi9saWIveDg2XzY0
LWxpbnV4LWdudS9saWJ0aHJlYWRfZGIuc28uMSIuCkNoZWNrIHRyZWUgYmxvY2sgZmFpbGVkLCB3
YW50PTEzOTI2NCwgaGF2ZT0wCkNoZWNrIHRyZWUgYmxvY2sgZmFpbGVkLCB3YW50PTEzOTI2NCwg
aGF2ZT0wCkNoZWNrIHRyZWUgYmxvY2sgZmFpbGVkLCB3YW50PTEzOTI2NCwgaGF2ZT0wCnJlYWQg
YmxvY2sgZmFpbGVkIGNoZWNrX3RyZWVfYmxvY2sKQ291bGRuJ3QgcmVhZCBjaHVuayByb290CgpQ
cm9ncmFtIHJlY2VpdmVkIHNpZ25hbCBTSUdTRUdWLCBTZWdtZW50YXRpb24gZmF1bHQuCjB4MDAw
MDdmZmZmN2JkN2ExMCBpbiA/PyAoKSBmcm9tIC9saWIveDg2XzY0LWxpbnV4LWdudS9saWJ1dWlk
LnNvLjEKKGdkYikgYnQKIzAgIDB4MDAwMDdmZmZmN2JkN2ExMCBpbiA/PyAoKSBmcm9tIC9saWIv
eDg2XzY0LWxpbnV4LWdudS9saWJ1dWlkLnNvLjEKIzEgIDB4MDAwMDdmZmZmN2JkN2FhNiBpbiA/
PyAoKSBmcm9tIC9saWIveDg2XzY0LWxpbnV4LWdudS9saWJ1dWlkLnNvLjEKIzIgIDB4MDAwMDAw
MDAwMDQyMzQ0MCBpbiBjbWRfY2hlY2sgKGFyZ2M9MSwgYXJndj0weDdmZmZmZmZmZTQ2OCkKICAg
IGF0IGNtZHMtY2hlY2suYzozNjEzCiMzICAweDAwMDAwMDAwMDA0MDc2YzEgaW4gbWFpbiAoYXJn
Yz0yLCBhcmd2PTB4N2ZmZmZmZmZlNDY4KSBhdCBidHJmcy5jOjI5NQ==
--e89a8fb207a4832a7804d7d45b8b--
