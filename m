Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63740 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753860AbaCJPvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 11:51:32 -0400
Message-ID: <531DDF7E.305@fb.com>
Date: Mon, 10 Mar 2014 11:51:26 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: clm <clm@fb.com>
Subject: Re: [PATCH Resend] btrfs: Use PTR_ERR_OR_ZERO
References: <1392608637-24756-1-git-send-email-sachin.kamat@linaro.org> <CAK9yfHyz66Zt5ZdKy1LYfE1skh-Z5Qx9p6y5Agg1EtKzof0jYg@mail.gmail.com>
In-Reply-To: <CAK9yfHyz66Zt5ZdKy1LYfE1skh-Z5Qx9p6y5Agg1EtKzof0jYg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/10/2014 11:25 AM, Sachin Kamat wrote:
> On 17 February 2014 09:13, Sachin Kamat <sachin.kamat@linaro.org>
> wrote:
>> PTR_RET is deprecated. Use PTR_ERR_OR_ZERO instead. While at it 
>> also include missing err.h header.
>> 
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org> --- 
>> fs/btrfs/root-tree.c |    3 ++- 1 file changed, 2 insertions(+),
>> 1 deletion(-)
>> 
>> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c index
>> 1389b69059de..38bb47e7d6b1 100644 --- a/fs/btrfs/root-tree.c +++
>> b/fs/btrfs/root-tree.c @@ -16,6 +16,7 @@ * Boston, MA
>> 021110-1307, USA. */
>> 
>> +#include <linux/err.h> #include <linux/uuid.h> #include
>> "ctree.h" #include "transaction.h" @@ -271,7 +272,7 @@ int
>> btrfs_find_orphan_roots(struct btrfs_root *tree_root) 
>> key.offset++;
>> 
>> root = btrfs_read_fs_root(tree_root, &root_key); -
>> err = PTR_RET(root); +               err =
>> PTR_ERR_OR_ZERO(root); if (err && err != -ENOENT) { break; } else
>> if (err == -ENOENT) { -- 1.7.9.5
>> 
> 
> Ping..
> 

It's in my current batch, I'm just tracking down problems with other
patches in this batch, it should be pushed out in the next day or two.
 Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHd9+AAoJEANb+wAKly3BNGwP/0Mgrfq4xWQw2LL0dvAWRTvC
iRpDjcP373Mv27tMHs6c4kuvRDAu0biu2kHVTyH6ycJK0/65k1WBoTuC9EHXDLUP
TUhQ+SppqANrgO31rZmps2pa1ErUG/9YJmC8UA2BpZ4XcpBTb8Npn7QzSpYsPDRM
r0fRNAC9w05IQfqMUSrX8zUgW9UmSQ5WRgseMZ0qhPF8vbm8j9Zwnnef/qmB0BMI
LT7W2wBphNkMt4AjgeGCmB+PSif9cdGwu6WLj/beQumdzyXWhrvJ0DNmMStLCpE4
y5CQKi7bCM3HVxehC7vqvs63jVejQUyRpAWSBJ3ixTjt3I1u0qug43YauPzJl3/q
N+OLvJz9WzAvJMl3+rnklnGk3Lew9kxAX87KxPWW3GMA7vx4xDtoUlFL2iGoqxoM
ZvRisLeLykagTxWMImgaMyAjw+Z3sS8ROIzfaJ4RrLgEJJOWwiCjj5z8bAPRBl+G
EUxYrvlXTHG+Nykkhx/AR8JEmVCYUbdndktbiMHhMYQo+4djZbENolGLNjav6Qmf
XyltMPhcAT8Hm2PsqO0Mvso/cge3uePo8RSGE/0V3s/VM0Y+hdOXb2jXnN+dqFDw
EwLySwpTZLUaa5zDJT4eoCX7XUR/Mung6wvhHwyV3eQkbirpyRJQUYbIKbwvkgkZ
chOohNybHaTxefiguv8y
=UiXm
-----END PGP SIGNATURE-----
