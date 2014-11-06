Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47710 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKFLFz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Nov 2014 06:05:55 -0500
Received: by mail-lb0-f169.google.com with SMTP id 10so700031lbg.28
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Nov 2014 03:05:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201411061743.5znDnvlg%fengguang.wu@intel.com>
References: <201411061743.5znDnvlg%fengguang.wu@intel.com>
Date: Thu, 6 Nov 2014 12:05:52 +0100
Message-ID: <CACeaM89cLbeSU1em6xxu3kASWMBMs_3g2+sLhki2eCOdOd-rMQ@mail.gmail.com>
Subject: Re: fs/btrfs/ioctl.c:2204:29: sparse: incorrect type in argument 4
 (different address spaces)
From: Gerhard Heift <gerhard@heift.name>
To: Chris Mason <chris.mason@fusionio.com>
Cc: kbuild-all@01.org, linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e01182b1a04db6005072eae43
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--089e01182b1a04db6005072eae43
Content-Type: text/plain; charset=UTF-8

Hello,

I got a warning from the kbuild test robot for an invalid address
space cast, which was introduced by my patch for TREE_SEARCH_V2. Here
is a patch, which should fix the warning.

Regards,
  Gerhard

2014-11-06 10:48 GMT+01:00 kbuild test robot <fengguang.wu@intel.com>:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   20f3963d8f48ae8309fbc777ef6787fd0a3f53c2
> commit: cc68a8a5a4330a4bb72922d0c7a7044ae13ee692 btrfs: new ioctl TREE_SEARCH_V2
> date:   5 months ago
> reproduce:
>   # apt-get install sparse
>   git checkout cc68a8a5a4330a4bb72922d0c7a7044ae13ee692
>   make ARCH=x86_64 allmodconfig
>   make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>    fs/btrfs/ioctl.c:2204:29: sparse: cast removes address space of expression
>>> fs/btrfs/ioctl.c:2204:29: sparse: incorrect type in argument 4 (different address spaces)
>    fs/btrfs/ioctl.c:2204:29:    expected char [noderef] <asn:1>*ubuf
>    fs/btrfs/ioctl.c:2204:29:    got char *<noident>
>    fs/btrfs/ioctl.c:2729:27: sparse: incorrect type in assignment (different base types)
>    fs/btrfs/ioctl.c:2729:27:    expected unsigned int [unsigned] [usertype] nodesize
>    fs/btrfs/ioctl.c:2729:27:    got restricted __le32 [usertype] nodesize
>    fs/btrfs/ioctl.c:2730:29: sparse: incorrect type in assignment (different base types)
>    fs/btrfs/ioctl.c:2730:29:    expected unsigned int [unsigned] [usertype] sectorsize
>    fs/btrfs/ioctl.c:2730:29:    got restricted __le32 [usertype] sectorsize
>    fs/btrfs/ioctl.c:2731:34: sparse: incorrect type in assignment (different base types)
>    fs/btrfs/ioctl.c:2731:34:    expected unsigned int [unsigned] [usertype] clone_alignment
>    fs/btrfs/ioctl.c:2731:34:    got restricted __le32 [usertype] sectorsize
>    fs/btrfs/ioctl.c:4275:29: sparse: incorrect type in argument 1 (different address spaces)
>    fs/btrfs/ioctl.c:4275:29:    expected void [noderef] <asn:1>*to
>    fs/btrfs/ioctl.c:4275:29:    got void *<noident>
>    fs/btrfs/ioctl.c:4350:29: sparse: incorrect type in argument 1 (different address spaces)
>    fs/btrfs/ioctl.c:4350:29:    expected void [noderef] <asn:1>*to
>    fs/btrfs/ioctl.c:4350:29:    got void *<noident>
>
> vim +2204 fs/btrfs/ioctl.c
>
>   2188          /* copy search header and buffer size */
>   2189          uarg = (struct btrfs_ioctl_search_args_v2 __user *)argp;
>   2190          if (copy_from_user(&args, uarg, sizeof(args)))
>   2191                  return -EFAULT;
>   2192
>   2193          buf_size = args.buf_size;
>   2194
>   2195          if (buf_size < sizeof(struct btrfs_ioctl_search_header))
>   2196                  return -EOVERFLOW;
>   2197
>   2198          /* limit result size to 16MB */
>   2199          if (buf_size > buf_limit)
>   2200                  buf_size = buf_limit;
>   2201
>   2202          inode = file_inode(file);
>   2203          ret = search_ioctl(inode, &args.key, &buf_size,
>> 2204                             (char *)(&uarg->buf[0]));
>   2205          if (ret == 0 && copy_to_user(&uarg->key, &args.key, sizeof(args.key)))
>   2206                  ret = -EFAULT;
>   2207          else if (ret == -EOVERFLOW &&
>   2208                  copy_to_user(&uarg->buf_size, &buf_size, sizeof(buf_size)))
>   2209                  ret = -EFAULT;
>   2210
>   2211          return ret;
>   2212  }
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

--089e01182b1a04db6005072eae43
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-btrfs-fix-address-space-cast-in-TREE_SEARCH_V2.patch"
Content-Disposition: attachment;
	filename="0001-btrfs-fix-address-space-cast-in-TREE_SEARCH_V2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i260c8g70

RnJvbSA2MjBmZjE2NTI3YmQ3MTFlN2I2Njc3YmE3ZDVlY2ZiNDQ2N2MyMzFhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHZXJoYXJkIEhlaWZ0IDxnZXJoYXJkQGhlaWZ0Lm5hbWU+CkRh
dGU6IFRodSwgNiBOb3YgMjAxNCAxMTozMDoxMCArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGJ0cmZz
OiBmaXggYWRkcmVzcyBzcGFjZSBjYXN0IGluIFRSRUVfU0VBUkNIX1YyCgpUaGlzIHBhdGNoZXMg
Zml4ZXMgYW4gaW52YWxpZCBjYXN0IG9mIGFuIHVzZXIgc3BhY2UgYWRkcmVzcyB0byBrZXJuZWwg
c3BhY2UsCmJ1dCBpcyBzdGlsbCB1c2VkIGFzIHVzZXIgc3BhY2UgaW4gdGhlIGNhbGxlZCBmdW5j
dGlvbi4KClRoaXMgY2FzdCB3b3VsZCBoYXZlIG5vdCBiZWVuIG5lY2Vzc2FyeSwgaWYgSSBoYWQg
Y2hvb3NlbiB0aGUgdHlwZSBvZgooc3RydWN0IGJ0cmZzX2lvY3RsX3NlYXJjaF9hcmdzX3YyKS5i
dWYgYXMgY2hhcltdIGFuZCBub3QgYXMgX191NjRbXSwgd2hpY2ggSQpkaWQgZm9yIGZvciB1bmtu
b3duIHJlYXNvbnMuCgpTaWduZWQtb2ZmLWJ5OiBHZXJoYXJkIEhlaWZ0IDxnZXJoYXJkQGhlaWZ0
Lm5hbWU+Ci0tLQogZnMvYnRyZnMvaW9jdGwuYyB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL2J0cmZzL2lvY3RsLmMg
Yi9mcy9idHJmcy9pb2N0bC5jCmluZGV4IDZlYTE1NDYuLmRiZDU3N2UgMTAwNjQ0Ci0tLSBhL2Zz
L2J0cmZzL2lvY3RsLmMKKysrIGIvZnMvYnRyZnMvaW9jdGwuYwpAQCAtMjIwMSw3ICsyMjAxLDcg
QEAgc3RhdGljIG5vaW5saW5lIGludCBidHJmc19pb2N0bF90cmVlX3NlYXJjaF92MihzdHJ1Y3Qg
ZmlsZSAqZmlsZSwKIAogCWlub2RlID0gZmlsZV9pbm9kZShmaWxlKTsKIAlyZXQgPSBzZWFyY2hf
aW9jdGwoaW5vZGUsICZhcmdzLmtleSwgJmJ1Zl9zaXplLAotCQkJICAgKGNoYXIgKikoJnVhcmct
PmJ1ZlswXSkpOworCQkJICAgKGNoYXIgX191c2VyICopKCZ1YXJnLT5idWZbMF0pKTsKIAlpZiAo
cmV0ID09IDAgJiYgY29weV90b191c2VyKCZ1YXJnLT5rZXksICZhcmdzLmtleSwgc2l6ZW9mKGFy
Z3Mua2V5KSkpCiAJCXJldCA9IC1FRkFVTFQ7CiAJZWxzZSBpZiAocmV0ID09IC1FT1ZFUkZMT1cg
JiYKLS0gCjIuMS4xCgo=
--089e01182b1a04db6005072eae43--
