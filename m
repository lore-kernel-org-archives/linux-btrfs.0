Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36135 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbeENLwZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:52:25 -0400
Received: by mail-pf0-f196.google.com with SMTP id w129-v6so5910798pfd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 04:52:25 -0700 (PDT)
From: Su Yue <damenly.su@gmail.com>
Subject: Re: [PATCH 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
 <6250dfd4-80c3-1714-27f4-d0091ef411a6@gmx.com>
Message-ID: <a89b4c6d-49c0-8f0c-73ab-10c70e03708e@gmail.com>
Date: Mon, 14 May 2018 19:52:20 +0800
MIME-Version: 1.0
In-Reply-To: <6250dfd4-80c3-1714-27f4-d0091ef411a6@gmx.com>
Content-Type: multipart/mixed;
 boundary="------------56A6BFBADAA0BD52579FC11F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------56A6BFBADAA0BD52579FC11F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2018/5/14 7:22 PM, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 18:29, Su Yue wrote:
>> Define new macro I_ERR_ODD_INODE_FLAGS to represents odd inode flags.
>>
>> Symlinks should never have append/immutable flags.
>> While processing inodes, if found a symlink with append/immutable
>> flags, mark the inode record with I_ERR_ODD_INODE_FLAGS.
>>
>> This is for original mode.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>  check/main.c          | 7 +++++++
>>  check/mode-original.h | 1 +
>>  2 files changed, 8 insertions(+)
>>
>> diff --git a/check/main.c b/check/main.c
>> index 68da994f7ae0..f5f52c406046 100644
>> --- a/check/main.c
>> +++ b/check/main.c
>> @@ -576,6 +576,8 @@ static void print_inode_error(struct btrfs_root *r=
oot, struct inode_record *rec)
>>  		fprintf(stderr, ", link count wrong");
>>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>>  		fprintf(stderr, ", orphan file extent");
>> +	if (errors & I_ERR_ODD_INODE_FLAGS)
>> +		fprintf(stderr, ", odd inode flags");
>>  	fprintf(stderr, "\n");
>>  	/* Print the orphan extents if needed */
>>  	if (errors & I_ERR_FILE_EXTENT_ORPHAN)
>> @@ -805,6 +807,7 @@ static int process_inode_item(struct extent_buffer=
 *eb,
>>  {
>>  	struct inode_record *rec;
>>  	struct btrfs_inode_item *item;
>> +	u64 flags;
>> =20
>>  	rec =3D active_node->current;
>>  	BUG_ON(rec->ino !=3D key->objectid || rec->refs > 1);
>> @@ -822,6 +825,10 @@ static int process_inode_item(struct extent_buffe=
r *eb,
>>  	rec->found_inode_item =3D 1;
>>  	if (rec->nlink =3D=3D 0)
>>  		rec->errors |=3D I_ERR_NO_ORPHAN_ITEM;
>> +	flags =3D btrfs_inode_flags(eb, item);
>> +	if (rec->imode & BTRFS_FT_SYMLINK &&
>> +	    flags & (BTRFS_INODE_IMMUTABLE | BTRFS_INODE_APPEND))
>> +		rec->errors =3D I_ERR_ODD_INODE_FLAGS;
>=20
> Shouldn't it be "|=3D" instead of "=3D" ?
>=20
> Thanks,
> Qu

Oh... Should be "|=3D".

Thanks,
Su

>=20
>>  	maybe_free_inode_rec(&active_node->inode_cache, rec);
>>  	return 0;
>>  }
>> diff --git a/check/mode-original.h b/check/mode-original.h
>> index 368de692fdd1..13cfa5b9e1b3 100644
>> --- a/check/mode-original.h
>> +++ b/check/mode-original.h
>> @@ -186,6 +186,7 @@ struct file_extent_hole {
>>  #define I_ERR_LINK_COUNT_WRONG		(1 << 13)
>>  #define I_ERR_FILE_EXTENT_ORPHAN	(1 << 14)
>>  #define I_ERR_FILE_EXTENT_TOO_LARGE	(1 << 15)
>> +#define I_ERR_ODD_INODE_FLAGS		(1 << 16)
>> =20
>>  struct inode_record {
>>  	struct list_head backrefs;
>>
>=20


--------------56A6BFBADAA0BD52579FC11F
Content-Type: application/pgp-keys;
 name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFrxufcBCAD0qWU6UwbZznInFAL+RMvhdcHMdhgKM7Bkq7evUxjROvEbIEdJ
gGrmSWm7zlxZb0NPDFyzSQy/w/H0+9MTsgcUbhLORFFgbwPjyg15Z2MEFxvHspoY
DPhKjd9qxWL/v9F15EtJ/M0zw+pibWwmFPh7PXDriZOzgVR4XGG73Nsm7bJ79N6V
1NbfDH1eEx8Yf3KE+K7ESV1YPq0rPFNGbG5d8Fw39hPd6qeGTzQ5V9Gghg9aNH/q
PygkPDjmJv2wP1fGSivpjiB93oRge5S4WDDaH5eedWrIUeEQZMUOKcqQSpIKqimw
Od69nzUsXI4VwShXyvKNINEkGGjdXseezbF5ABEBAAG0HVN1IFl1ZSA8ZGFtZW5s
eS5zdUBnbWFpbC5jb20+iQFUBBMBCAA+FiEEftbZazISzUZ3Vp++AtnXyVw95OgF
AlrxufgCGwMFCQHhM4AFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQAtnXyVw9
5OhMLgf8CD5TPpKq9wE0Zg/XT5wSwZFTNy+rXiw2hmWaLE1AH6Slfb82GvJFthIu
tEoXa4Yqm9SxEAI/Lk/tdtKYpLLdWp+N9iGzNW5Z3mflTcNPh3lE1/6QmjaRULfM
nvHqWZVAmzr69ZSjslMi8kTIIZtnyHLA3r0H03eUQLUUQeuxjED57YTm4+Js7aO9
gv6Vjn+n3+UbtWGhemHw5Xzn9KhDL3bMIkT0tA21TVdcxaqWsFwY7aU8+4FtiPt9
SbhsE38oMzbzfhlhopMlS9srJ+yOFE8G8peZUyC7LgATl0FAa6bnzoqrNOWoRR/6
juQA8hgsxL+LQh+CC6F8OiqFiKFnabkBDQRa8bn4AQgAu7IqCbUl7qqQqX8N5LCF
dwjtX/hECpDyUWw+SWMOAdBOSNYYJrrvLhwN/2i+YbYtW3xMmdXUTAC9Mi25uC/O
y6ezsfV1LMcYxB8C+IJH1Oh8gdDTtm+BVwqNYEcGUluJDtRD+NsI9oz2+3nW7T5C
6twNABAl5b/UEMAoEh1/kG9VVM0jiC8O+0vCmFBiM4RQS2qyF3CoKknBAYS6q/GR
/Qw6z4XHAaz1jFNz+9PP/I4ijhPNvKZXaxzsqB3AXyqUi86x04AXGJZeQbcFjCaP
jnE0ow5gjyYkC32L7+RZUc7dNJFCNXHJn91TVC8g7x0x4S94w3xQNI7Le4xo7gD8
6QARAQABiQE8BBgBCAAmFiEEftbZazISzUZ3Vp++AtnXyVw95OgFAlrxufgCGwwF
CQHhM4AACgkQAtnXyVw95OjdvwgAlMCDN5LoyY/jTCeVA/PqR5FvYnpKCCjinlAn
8C0k4/3v1hIpnxhbmT96oXGEZfN7F/7bfsfX2dzBaERP6n4iPelEzgTcl3GQxkvZ
zAWAOhsqgwTSzujF9H0m2/IEm4QtaRRhZ2NINA3bwq6seNmDZkCQuIby/SDV6GiF
Q9Wzb4qX62OF0SWJgHF9ddXhtUY+OT1Dtb0g6ocvr+n0cLLFuF3SrNtE+xPVzy7V
Eett4ZzUvzuXt7CTrMmBKPl8nJjgPuEr8bubmuQbYrxSFwfb2N2AhcAbtWxZbOE8
NyRSKHWJIxVmEAC+3vK2AsLqxf8tO3Z1UvPEm9E5fDcb67s5mg=3D=3D
=3DUVvh
-----END PGP PUBLIC KEY BLOCK-----

--------------56A6BFBADAA0BD52579FC11F--
