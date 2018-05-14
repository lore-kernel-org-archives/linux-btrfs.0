Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:39061 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752594AbeENMMG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 08:12:06 -0400
Received: by mail-pl0-f66.google.com with SMTP id c19-v6so7268032pls.6
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 05:12:06 -0700 (PDT)
From: Su Yue <damenly.su@gmail.com>
Subject: Re: [PATCH 1/3] btrfs-progs: check: check symlinks with
 append/immutable flags
To: Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20180514102922.8840-1-suy.fnst@cn.fujitsu.com>
 <20180514102922.8840-2-suy.fnst@cn.fujitsu.com>
 <ea812fde-5a3b-be23-ffc0-c5a05a80d886@suse.com>
Message-ID: <c98d25e7-78d4-eb0b-e15d-b5ce8e6a751e@gmail.com>
Date: Mon, 14 May 2018 20:12:02 +0800
MIME-Version: 1.0
In-Reply-To: <ea812fde-5a3b-be23-ffc0-c5a05a80d886@suse.com>
Content-Type: multipart/mixed;
 boundary="------------15E01AC5702EA19F541EE680"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------15E01AC5702EA19F541EE680
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2018/5/14 7:18 PM, Nikolay Borisov wrote:
>=20
>=20
> On 14.05.2018 13:29, Su Yue wrote:
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
>=20
> I don't like the name of the flag. How about:
>=20
> I_ERR_INVALID_SYMLINK_FLAGS
>=20
Before, original mode doesn't check inode flags.
So I'd rather to keep INODE_FLAGS for further use.

As for "ODD" part, it is just inherited from name style of above lines.
I don't like "ODD" too much either.
Anyway, thanks.

Su
>> =20
>>  struct inode_record {
>>  	struct list_head backrefs;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--------------15E01AC5702EA19F541EE680
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

--------------15E01AC5702EA19F541EE680--
