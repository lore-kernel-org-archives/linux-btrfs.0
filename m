Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36197 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab3AaTYj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:24:39 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so2363138wgh.7
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2013 11:24:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51079151.4070905@jan-o-sch.net>
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
	<51079151.4070905@jan-o-sch.net>
Date: Thu, 31 Jan 2013 21:24:37 +0200
Message-ID: <CAOcd+r0u=nF9V9wWGttQGMDbO7GJ+o-_CuaVf5Qi+-929WZt_A@mail.gmail.com>
Subject: Re: backref for an extent not found in send_root (!backref_ctx->found_itself)
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Content-Type: multipart/mixed; boundary=047d7bfcf524deb62504d49a93ad
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--047d7bfcf524deb62504d49a93ad
Content-Type: text/plain; charset=ISO-8859-1

Hi Jan,
attached are bash scripts to repro the issue.

Some instructions on how to run them:
- create 2 btrfs filesystems with "mkfs.btrfs /dev/sdXXX". I don't
think that size matters.
- mount them in /mnt/src and /mnt/dst
- mount options: noatime,nodatasum,nodatacow,nospace_cache
- put the 3 scripts into one directory and cd to it
- run btrfs_init_tests.sh (it sets up a small file tree for tests)
- run btrfs_test_first_ref_jan.sh

After about 20-30 seconds, it hits the error I mentioned and script
stops. It happens on "for-linus" branch, top commit
1eafa6c73791e4f312324ddad9cbcaf6a1b6052b.
I suspect the issue might be that the test schedules a lot of
subvolumes for deletion, and once the cleaner thread kicks in and also
starts doing backref stuff, the problem happens.

Another small note: there is an issue in btrfs-progs subvolume listing
code (also used by send). When it finds a ROOT_ITEM in the root tree
that is not linked with ROOT_REF/ROOT_BACKREF (i.e., one scheduled for
deletion), it gets confused and exits. Miao sent a patch to fix it
here:
http://www.spinics.net/lists/linux-btrfs/msg19767.html
I don't think it got merged into progs yet (progs are really behind:()

If you want a quick fix, add code like this to the beginning of
__list_subvol_fill_paths (but Miao sent a better patch):
	/*
	 * due to change in __list_subvol_search(), root_lookup
	 * might contain subvolumes with ref_tree==0 (in deletion).
	 */
again:	
	n = rb_first(&root_lookup->root);
	while (n) {
		struct root_info *entry = rb_entry(n, struct root_info, rb_node);
		if (entry->ref_tree == 0) {
			fprintf(stderr, "__list_subvol_fill_paths: drop root_id=%llu,
because it has no ref_tree\n", entry->root_id);
			rb_erase(n, &root_lookup->root);
			free(entry);
			goto again;
		}
		n = rb_next(n);
	}

Otherwise, "btrfs send" might fail, but this is not the failure we are
looking for:)

Thanks,
Alex.





On Tue, Jan 29, 2013 at 11:07 AM, Jan Schmidt <list.btrfs@jan-o-sch.net> wrote:
> Hi Alex,
>
> On Mon, January 28, 2013 at 17:11 (+0100), Alex Lyakas wrote:
>> Hi Jan,
>> I have a set of unit tests (part of the larger system) for the
>> send-receive functionality, with which I am able to hit this error:
>>
>> Jan 28 18:01:00 687-dev kernel: [16968.451358] btrfs: ERROR did not
>> find backref in send_root. inode=259, offset=139264, disk_byte=4263936
>> found extent=4263936
>>
>> As the code states, this could indicate a bug in backref walking. This
>> reproduces with "for-linus" branch.
>>
>> Typically this happens when a snapshot is deleted, immediately a new
>> snap with the same name is created, and then "btrfs send" is issued
>> without parent (i.e., full-send) on this snap.
>>
>> To debug this further, we can do one of two things:
>> # I can apply patches/debug prints & reproduce
>> # I can work to isolate the unit test into a bash script and send you
>> a script that reproduces
>
> I'd prefer #2 of the above. You can also send me the unit tests you've got if I
> can get them running without multiple days of setup.
>
> I'm guessing that this is more likely going to end up in send.c than in
> backref.c, perhaps Alexander would like to trace this one down. But anyway, send
> me a reproducer (in private, if you don't want to publish it) and we'll see
> what's going on.
>
> Thanks,
> -Jan

--047d7bfcf524deb62504d49a93ad
Content-Type: application/x-sh; name="btrfs_functions.sh"
Content-Disposition: attachment; filename="btrfs_functions.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcma59xl0

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCnByZXJlcSgpCnsKCWVjaG8gIlByZXJlcXVpc2l0ZXMiCglh
cHQtZ2V0IGluc3RhbGwgLXkgdHJlZQp9CgpjbGVhbnVwKCkKewoJZWNobyAiQ2xlYW51cC4uLi4i
CglidHJmcyBzdWIgZGVsIC9tbnQvc3JjL2NnMCB8fCB0cnVlCglidHJmcyBzdWIgZGVsIC9tbnQv
c3JjL3NuYXBfY2cwX29yaWcvIHx8IHRydWUKCWJ0cmZzIHN1YiBkZWwgL21udC9zcmMvc25hcDAv
IHx8IHRydWUKCWJ0cmZzIHN1YiBkZWwgL21udC9zcmMvc25hcDEvIHx8IHRydWUKCWJ0cmZzIHN1
YiBkZWwgL21udC9kc3Qvc25hcDAvIHx8IHRydWUKCWJ0cmZzIHN1YiBkZWwgL21udC9kc3Qvc25h
cDEvIHx8IHRydWUKfQoKYmFzZV9zdWJ2b2woKQp7CgllY2hvICJDcmVhdGUgYmFzZSBzdWJ2b2x1
bWUgYW5kIGZpbGwgd2l0aCBkYXRhLi4uIgoJYnRyZnMgc3ViIGNyZWF0ZSAvbW50L3NyYy9jZzAK
CW1rZGlyIC9tbnQvc3JjL2NnMC9kaXIxCglkZCBpZj0vZGV2L3VyYW5kb20gb2Y9L21udC9zcmMv
Y2cwL2ZpbGUxX25vZCBicz0xIGNvdW50PTE2MwoJZGQgaWY9L2Rldi91cmFuZG9tIG9mPS9tbnQv
c3JjL2NnMC9maWxlMl9ub2QgYnM9MSBjb3VudD05NTE1IHNlZWs9MTQwMDAwCglkZCBpZj0vZGV2
L3VyYW5kb20gb2Y9L21udC9zcmMvY2cwL2RpcjEvZmlsZTJfZGlyMSBicz0xIGNvdW50PTIwMDAw
IHNlZWs9MTAwMDAKCWRkIGlmPS9kZXYvdXJhbmRvbSBvZj0vbW50L3NyYy9jZzAvZGlyMS9maWxl
MV9kaXIxIGJzPTEgY291bnQ9NzIwNjMKCWNwIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUyX2RpcjEg
L21udC9zcmMvY2cwL2RpcjEvZmlsZTNfZGlyMV90cnVuYwoJZGQgaWY9L2Rldi91cmFuZG9tIG9m
PS9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUzX2RpcjFfdHJ1bmMgYnM9MSBzZWVrPTY5OTk5IGNvdW50
PTEgY29udj1ub3RydW5jCgl0b3VjaCAvbW50L3NyYy9jZzAvZmlsZTJfbm9kCgl0b3VjaCAvbW50
L3NyYy9jZzAvZmlsZTNfbm9kCgl0b3VjaCAvbW50L3NyYy9jZzAvZGlyMS9maWxlNF9kaXIxCglt
a2RpciAvbW50L3NyYy9jZzAvZGlyMgoJbG4gL21udC9zcmMvY2cwL2RpcjEvZmlsZTFfZGlyMSAv
bW50L3NyYy9jZzAvZGlyMi9maWxlMV9kaXIxX0hMCgl0b3VjaCAvbW50L3NyYy9jZzAvZGlyMi9m
aWxlMV9kaXIyCglta2RpciAvbW50L3NyYy9jZzAvZGlyMi9kaXIzCgl0b3VjaCAvbW50L3NyYy9j
ZzAvZGlyMi9kaXIzL2ZpbGUxX2RpcjMKCXRvdWNoIC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmls
ZTJfZGlyMwoJdG91Y2ggL21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlM19kaXIzCglsbiAvbW50
L3NyYy9jZzAvZGlyMS9maWxlMV9kaXIxIC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvCgkKCWVjaG8g
IkNyZWF0aW5nIGJhY2t1cCBzbmFwLi4uIgoJYnRyZnMgc3ViIHNuYXAgLXIgL21udC9zcmMvY2cw
IC9tbnQvc3JjL3NuYXBfY2cwX29yaWcvCn0KCmJhc2Vfc25hcCgpCnsKCWVjaG8gIi0tLS0tLUNy
ZWF0ZSBiYXNlIHNuYXAgb24gc3JjIGFuZCBkc3QtLS0tLS0tLS0iCglidHJmcyBzdWJ2b2wgZGVs
IC9tbnQvc3JjL3NuYXAwIHx8IHRydWUKCWJ0cmZzIHN1YnZvbCBkZWwgL21udC9kc3Qvc25hcDAg
fHwgdHJ1ZQoJZWNobyAiQ3JlYXRpbmcgYmFzZSBzbmFwIGZvciBzZW5kIC4uLiIKCWJ0cmZzIHN1
YiBzbmFwIC1yIC9tbnQvc3JjL2NnMCAvbW50L3NyYy9zbmFwMAoJCgllY2hvICJTZW5kaW5nIGZ1
bGwgdHJlZS4uLiIKCWJ0cmZzIHNlbmQgLXYgLXYgLXYgL21udC9zcmMvc25hcDAgPiAvdG1wL2R1
bXAKCWVjaG8gIlJlY2VpdmluZy4uLiIKCWJ0cmZzIHJlY2VpdmUgL21udC9kc3QgPCAvdG1wL2R1
bXAKCgllY2hvICJDaGVja2luZyBkaWZmIC1yIgoJZGlmZiAtciAvbW50L3NyYy9zbmFwMCAvbW50
L2RzdC9zbmFwMCAKCgllY2hvICJEb25lIGNyZWF0aW5nIGJhc2Ugc25hcDoiCgl0cmVlIC1BICAt
cyAtLWlub2RlcyAtLW5vcmVwb3J0IC9tbnQvc3JjL3NuYXAwCn0KCnJlc3RvcmUoKQp7CgllY2hv
ICItLS0tLS1SZXN0b3JlIENHLS0tLS0tLS0tIgoJZWNobyAiRGVsZXRlIGNnMCIKCWJ0cmZzIHN1
YiBkZWwgL21udC9zcmMvY2cwCgllY2hvICJSZS1jcmVhdGUgY2cwIGZyb20gc25hcF9jZzBfb3Jp
ZyIKCWJ0cmZzIHN1YiBzbmFwIC9tbnQvc3JjL3NuYXBfY2cwX29yaWcvIC9tbnQvc3JjL2NnMAoJ
dHJlZSAtQSAgLS1pbm9kZXMgLS1ub3JlcG9ydCAvbW50L3NyYy9jZzAKCWVjaG8gIi0tLS0tLVJl
c3RvcmUgYmFzZSBzbmFwc2hvdC0tLS0tLS0tLSIKCWJhc2Vfc25hcAoJZWNobyAiLS0tLS0tQ2xl
YW51cCBkaWZmIHNuYXBzaG90LS0tLS0tLS0tIgoJYnRyZnMgc3ViIGRlbCAvbW50L3NyYy9zbmFw
MSB8fCB0cnVlCglidHJmcyBzdWIgZGVsIC9tbnQvZHN0L3NuYXAxIHx8IHRydWUKfQoKZG9fZGlm
Zl9zZW5kKCkKewoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSIKCWJ0cmZzIHN1YiBkZWwgL21u
dC9zcmMvc25hcDEgfHwgdHJ1ZQoJZWNobyAiQ3JlYXRlIHNuYXAxIGZyb20gY2cwIgoJYnRyZnMg
c3ViIHNuYXAgLXIgL21udC9zcmMvY2cwIC9tbnQvc3JjL3NuYXAxCgllY2hvICJzZW5kIHNuYXAx
IgoJYnRyZnMgc2VuZCAtdiAtdiAtdiAtdiAtcCAvbW50L3NyYy9zbmFwMCAvbW50L3NyYy9zbmFw
MSA+IC90bXAvZHVtcAoJZWNobyAiUHJpbnQgcHJldiBhbmQgY3VyciB0cmVlcyIKCXRyZWUgLUEg
IC0taW5vZGVzIC0tbm9yZXBvcnQgL21udC9zcmMvc25hcDAKCXRyZWUgLUEgIC0taW5vZGVzIC0t
bm9yZXBvcnQgL21udC9zcmMvc25hcDEKCQoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFueSBvbiBk
ZXN0IgoJYnRyZnMgc3ViIGRlbCAvbW50L2RzdC9zbmFwMSB8fCB0cnVlCgllY2hvICJSZWNlaXZl
IgoJYnRyZnMgcmVjZWl2ZSAtdiAtdiAtdiAvbW50L2RzdC8gIDwgL3RtcC9kdW1wCgllY2hvICJW
YWxpZGF0ZSIKCWRpZmYgLXIgL21udC9zcmMvc25hcDEgL21udC9kc3Qvc25hcDEKCWVjaG8gIlN1
Y2Nlc3MhIgp9Cgpkb19mdWxsX3NlbmQoKQp7CgllY2hvICJEZWxldGUgc25hcDEgaWYgYW55IgoJ
YnRyZnMgc3ViIGRlbCAvbW50L3NyYy9zbmFwMSB8fCB0cnVlCgllY2hvICJDcmVhdGUgc25hcDEg
ZnJvbSBjZzAiCglidHJmcyBzdWIgc25hcCAtciAvbW50L3NyYy9jZzAgL21udC9zcmMvc25hcDEK
CWVjaG8gInNlbmQgc25hcDEgZnVsbHkiCglidHJmcyBzZW5kIC12IC12IC12IC12IC9tbnQvc3Jj
L3NuYXAxID4gL3RtcC9kdW1wCgllY2hvICJQcmludCBmdWxsIHRyZWUiCgl0cmVlIC1BICAtLWlu
b2RlcyAtLW5vcmVwb3J0IC9tbnQvc3JjL3NuYXAxCgoJZWNobyAiRGVsZXRlIHNuYXAxIGlmIGFu
eSBvbiBkZXN0IgoJYnRyZnMgc3ViIGRlbCAvbW50L2RzdC9zbmFwMSB8fCB0cnVlCgllY2hvICJS
ZWNlaXZlIgoJYnRyZnMgcmVjZWl2ZSAtdiAtdiAtdiAvbW50L2RzdC8gIDwgL3RtcC9kdW1wCgll
Y2hvICJWYWxpZGF0ZSIKCWRpZmYgLXIgL21udC9zcmMvc25hcDEgL21udC9kc3Qvc25hcDEKCWVj
aG8gIlN1Y2Nlc3MhIgp9Cg==
--047d7bfcf524deb62504d49a93ad
Content-Type: application/x-sh; name="btrfs_init_tests.sh"
Content-Disposition: attachment; filename="btrfs_init_tests.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcma59xo1

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCk1ZRElSPSIkKGRpcm5hbWUgIiRCQVNIX1NPVVJDRVswXSIp
Igpzb3VyY2UgJE1ZRElSL2J0cmZzX2Z1bmN0aW9ucy5zaAoKCnByZXJlcQpjbGVhbnVwCmJhc2Vf
c3Vidm9sCmJhc2Vfc25hcAo=
--047d7bfcf524deb62504d49a93ad
Content-Type: application/x-sh; name="btrfs_test_first_ref_jan.sh"
Content-Disposition: attachment; filename="btrfs_test_first_ref_jan.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcma59xq2

IyEgL2Jpbi9iYXNoCgpzZXQgLWUKCk1ZRElSPSIkKGRpcm5hbWUgIiRCQVNIX1NPVVJDRVswXSIp
Igpzb3VyY2UgJE1ZRElSL2J0cmZzX2Z1bmN0aW9ucy5zaAoKdGVzdDEoKQp7CmVjaG8gIiMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMiCmVjaG8gICJBZGQgSEwgdG8gZXhpc3Rp
bmcgZmlsZSwgd2hpY2ggb3ZlcndyaXRlcyAnc2Vjb25kJyBITCBvZiBhbm90aGVyIGV4aXN0aW5n
IGZpbGUiCnJlc3RvcmUKdW5saW5rIC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmlsZTFfZGlyMQps
biAvbW50L3NyYy9jZzAvZmlsZTFfbm9kIC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmlsZTFfZGly
MQpkb19mdWxsX3NlbmQKZG9fZGlmZl9zZW5kCmVjaG8gICJUZXN0IGRvbmUuIgp9Cgp0ZXN0MTEo
KQp7CmVjaG8gIiMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMiCmVjaG8gICJB
ZGQgSEwgdG8gZXhpc3RpbmcgZmlsZSwgd2hpY2ggb3ZlcndyaXRlcyAnZmlyc3QnIEhMIG9mIGFu
b3RoZXIgZXhpc3RpbmcgZmlsZSIKcmVzdG9yZQp1bmxpbmsgL21udC9zcmMvY2cwL2RpcjEvZmls
ZTFfZGlyMQpsbiAvbW50L3NyYy9jZzAvZmlsZTFfbm9kIC9tbnQvc3JjL2NnMC9kaXIxL2ZpbGUx
X2RpcjEKZG9fZnVsbF9zZW5kCmRvX2RpZmZfc2VuZAplY2hvICAiVGVzdCBkb25lLiIKfQoKdGVz
dDExMSgpCnsKZWNobyAiIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyIKZWNo
byAgIkFkZCBITCB0byBleGlzdGluZyBmaWxlLCB3aGljaCBvdmVyd3JpdGVzICdzZWNvbmQnIEhM
IG9mIGFub3RoZXIgZXhpc3RpbmcgZmlsZSwgYnV0IHRoZSBleGlzdGluZyBmaWxlIGlzIGxvd2Vy
IGlubyIKcmVzdG9yZQp1bmxpbmsgL21udC9zcmMvY2cwL2RpcjIvZGlyMy9maWxlMV9kaXIxCmxu
IC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmlsZTNfZGlyMyAvbW50L3NyYy9jZzAvZGlyMi9kaXIz
L2ZpbGUxX2RpcjEKZG9fZnVsbF9zZW5kCmRvX2RpZmZfc2VuZAplY2hvICAiVGVzdCBkb25lLiIK
fQoKdGVzdDExMigpCnsKZWNobyAiIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyIKZWNobyAgIkFkZCBITCB0byBleGlzdGluZyBmaWxlLCB3aGljaCBvdmVyd3JpdGVzICdmaXJz
dCcgSEwgb2YgYW5vdGhlciBleGlzdGluZyBmaWxlLCBidXQgdGhlIGV4aXN0aW5nIGZpbGUgaXMg
bG93ZXIgaW5vIgpyZXN0b3JlCnVubGluayAvbW50L3NyYy9jZzAvZGlyMS9maWxlMV9kaXIxCmxu
IC9tbnQvc3JjL2NnMC9kaXIyL2RpcjMvZmlsZTNfZGlyMyAvbW50L3NyYy9jZzAvZGlyMS9maWxl
MV9kaXIxCmRvX2Z1bGxfc2VuZApkb19kaWZmX3NlbmQKZWNobyAgIlRlc3QgZG9uZS4iCn0KCndo
aWxlIHRydWUKZG8KCXRlc3QxCgl0ZXN0MTEKCXRlc3QxMTEKCXRlc3QxMTIKZG9uZQkKCg==
--047d7bfcf524deb62504d49a93ad--
