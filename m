From: Josef Bacik <josef@redhat.com>
Subject: Re: stalls with latest btrfs merge into 3.0-rc2
Date: Mon, 13 Jun 2011 21:01:53 -0400
Message-ID: <4DF6B301.90904@redhat.com>
References: <4DF67C06.4000307@sandia.gov>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000509000600020601030608"
Cc: linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
To: Jim Schutt <jaschut@sandia.gov>
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <4DF67C06.4000307@sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000509000600020601030608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/13/2011 05:07 PM, Jim Schutt wrote:
> Hi,
>
> On a system under a heavy write load from multiple ceph OSDs,
> I'm running into the following hung tasks where btrfs is implicated.
> I'm running commit 3c25fa740e2 from Linus' tree merged with
> commit cb9b41c92fa from git://ceph.newdream.net/git/ceph-client.git.
>

Please try this patch and verify it fixes the problem.  If it does I'll 
make it less crappy and send it along.  Thanks,

Josef

--------------000509000600020601030608
Content-Type: text/plain;
 name="test-fix.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="test-fix.patch"

ZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL3RyYW5zYWN0aW9uLmMgYi9mcy9idHJmcy90cmFuc2Fj
dGlvbi5jCmluZGV4IDdhOWY1MTcuLjUzMjEzOWUgMTAwNjQ0Ci0tLSBhL2ZzL2J0cmZzL3Ry
YW5zYWN0aW9uLmMKKysrIGIvZnMvYnRyZnMvdHJhbnNhY3Rpb24uYwpAQCAtMTIzNiwxMiAr
MTIzNiwxNiBAQCBpbnQgYnRyZnNfY29tbWl0X3RyYW5zYWN0aW9uKHN0cnVjdCBidHJmc190
cmFuc19oYW5kbGUgKnRyYW5zLAogCQkJc2NoZWR1bGVfdGltZW91dCgxKTsKIAogCQlmaW5p
c2hfd2FpdCgmY3VyX3RyYW5zLT53cml0ZXJfd2FpdCwgJndhaXQpOwotCQlzcGluX2xvY2so
JnJvb3QtPmZzX2luZm8tPnRyYW5zX2xvY2spOwotCQlyb290LT5mc19pbmZvLT50cmFuc19u
b19qb2luID0gMTsKLQkJc3Bpbl91bmxvY2soJnJvb3QtPmZzX2luZm8tPnRyYW5zX2xvY2sp
OwogCX0gd2hpbGUgKGF0b21pY19yZWFkKCZjdXJfdHJhbnMtPm51bV93cml0ZXJzKSA+IDEg
fHwKIAkJIChzaG91bGRfZ3JvdyAmJiBjdXJfdHJhbnMtPm51bV9qb2luZWQgIT0gam9pbmVk
KSk7CiAKKwlzcGluX2xvY2soJnJvb3QtPmZzX2luZm8tPnRyYW5zX2xvY2spOworCXJvb3Qt
PmZzX2luZm8tPnRyYW5zX25vX2pvaW4gPSAxOworCXNwaW5fdW5sb2NrKCZyb290LT5mc19p
bmZvLT50cmFuc19sb2NrKTsKKworCXdoaWxlIChhdG9taWNfcmVhZCgmY3VyX3RyYW5zLT5u
dW1fd3JpdGVycykgPiAxKQorCQlzY2hlZHVsZV90aW1lb3V0KDEpOworCiAJcmV0ID0gY3Jl
YXRlX3BlbmRpbmdfc25hcHNob3RzKHRyYW5zLCByb290LT5mc19pbmZvKTsKIAlCVUdfT04o
cmV0KTsKIAo=
--------------000509000600020601030608--
