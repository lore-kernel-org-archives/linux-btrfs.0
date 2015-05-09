Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbbEID5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 May 2015 23:57:24 -0400
Message-ID: <554D859E.6010301@suse.com>
Date: Fri, 08 May 2015 23:57:18 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>
CC: fdmanana@gmail.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: iterate over unused chunk space in FITRIM
References: <554909A5.4030307@suse.com> <CAL3q7H5O0w+_EPSbpMyWTYzyzyCOxHmU-wPRx7w85ftUzHzXgQ@mail.gmail.com> <554D35F6.8040601@suse.com> <20150509001802.GA19531@mew>
In-Reply-To: <20150509001802.GA19531@mew>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/8/15 8:18 PM, Omar Sandoval wrote:
> On Fri, May 08, 2015 at 06:17:26PM -0400, Jeff Mahoney wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 5/8/15 4:38 PM, Filipe David Manana wrote:
>>> On Tue, May 5, 2015 at 7:19 PM, Jeff Mahoney <jeffm@suse.com> 
>>> wrote:
>>>> -static int contains_pending_extent(struct
>>>> btrfs_trans_handle *trans, +static int
>>>> contains_pending_extent(struct btrfs_transaction
>>>> *transaction, struct btrfs_device *device, u64 *start, u64
>>>> len) { +       struct btrfs_fs_info *fs_info = 
>>>> device->dev_root->fs_info; struct extent_map *em; -
>>>> struct list_head *search_list =
>>>> &trans->transaction->pending_chunks; + struct list_head
>>>> *search_list = &transaction->pending_chunks;
>>> 
>>> transaction can be NULL so we need to check for that first (as
>>> you do below).
>> 
>> The ordering here is safe. We're not dereferencing the
>> transaction, we're getting the address of one of the members.
>> search_list will point to 0x100 or something. We don't ever
>> dereference that without checking the transaction against NULL.
>> 
> 
> Hi, Jeff,
> 
> I believe I've seen this topic come up before -- see [1]. Although
> it's probably fine on any sane compiler, it's apparently not
> correct from a language standard standpoint. Probably better safe
> than sorry.
> 
> [1]
> https://software.intel.com/en-us/blogs/2015/04/20/null-pointer-derefer
encing-causes-undefined-behavior

I
> 
get that if there are questions now, there will be questions later,
and I should just change it. And I will. But I stand by my argument
that the code is correct. Historically, a zero address being invalid
is convention. It wasn't part of the language spec.

I disagree with the blog post. A straight up NULL pointer may be
un-evaluatable as an object, but by the time it gets passed through
several layers of casting and function parameters, it's no longer
(void *)0.

Accordingly, this:

"""
An lvalue is an expression with an object type or an incomplete type
other than void; if an lvalue does not designate an object when it is
evaluated, the behavior is undefined.
"""

doesn't actually make any sense when the source of the null pointer is
unknown, like with a function parameter.


- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)

iQIcBAEBAgAGBQJVTYWeAAoJEB57S2MheeWy5U8P/2+VJbtK04pojXmfChdt2y5Z
qJoADUnnboa+20HBgo+dgd/aZDMM72sngss6vle65HSJqMvvagv0ZCEXBqA3HeqM
11Cpsdi122a34vYp2RO6W4ldpLebcsq4IlU06LDSPW71xciFYtCpv/6o5CM6oHIW
3a9yKl1KlhJmmb9l86kF0SJxvGWuyCeL8EQY22be7QR7t6zQERPybXXhW3L6cfin
ya+2pPOwOeJl/u3AgA2U8nCX5KufABMfjQ+6uMcgUXgVnN4YmmivoNh5OJPJhgJi
V4k/0g7IEuLRe4dN5eGjoIShaftAu0aWqgH7Xg9NrNewjbwBCKkqliS+qf0B8Rud
Ma21ovUzpIFJAEXDqJPi8yDXHUy3DZ3zBSpfASI0CdC97USFSp/R36pVPYIHqrbA
0t6UIHoRUokdTgSTErft/oRxnxG4Qze41M3O3Bk04KMqoWay78VWHrOCziIDQ22q
cr0RUCi2vCLFMdg9QKrFm8h+rvusoxiZ176cDkIiFfevYUcG/IiFO5WnHSYBASVD
t1ZPvWEqgeXNhMMXPUX9QOObtef/iXhy44uD5GnVZtdGE0arBSAyIKZaAFkv79qo
eedH7TcANRoSbqYERgK+dwNrrd/bfuguTvQeXk9//hxK6z+Fmmsh/4weduUoV2oA
c8lLTHz46fVECHIXbB9H
=Nare
-----END PGP SIGNATURE-----
