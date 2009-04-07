From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch] error handling of ERR_PTR() returns
Date: Tue, 07 Apr 2009 10:46:03 -0400
Message-ID: <49DB672B.7070007@suse.com>
References: <alpine.DEB.2.00.0904071632560.1465@bicker> <2a31deca0904070734y3f4c3366h5772c032381b38cc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Carpenter <error27@gmail.com>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0904070734y3f4c3366h5772c032381b38cc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrey Kuzmin wrote:
> Since both NULL ptr and IS_ERR(ptr) are treated as error, why not
> redefine IS_ERR to handle both, simplifying caller's life?

IS_ERR is a global kernel function, and NULL isn't always an error.

- -Jeff

> On Tue, Apr 7, 2009 at 5:38 PM, Dan Carpenter <error27@gmail.com> wrote:
>> There are a couple functions which return ERR_PTR as well as NULL.  The
>> caller needs to handle both.
>>
>> Smatch also complains about the handling of alloc_extent_map() but as far
>> as I can see that doesn't actually return an ERR_PTR.
>>
>> Compile tested on 2.6.29.
>>
>> regards,
>> dan carpenter
>>
>> --- orig/fs/btrfs/disk-io.c     2009-04-07 16:15:36.000000000 +0300
>> +++ devel/fs/btrfs/disk-io.c    2009-04-07 16:23:33.000000000 +0300
>> @@ -123,7 +123,7 @@
>>
>>        spin_lock(&em_tree->lock);
>>        em = lookup_extent_mapping(em_tree, start, len);
>> -       if (em) {
>> +       if (!IS_ERR(em) && em) {
>>                em->bdev =
>>                        BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
>>                spin_unlock(&em_tree->lock);
>> @@ -1216,8 +1216,8 @@
>>        int ret;
>>
>>        root = btrfs_read_fs_root_no_name(fs_info, location);
>> -       if (!root)
>> -               return NULL;
>> +       if (!root || IS_ERR(root))
>> +               return root;
>>
>>        if (root->in_sysfs)
>>                return root;
>> @@ -1324,7 +1324,7 @@
>>        spin_lock(&em_tree->lock);
>>        em = lookup_extent_mapping(em_tree, offset, PAGE_CACHE_SIZE);
>>        spin_unlock(&em_tree->lock);
>> -       if (!em) {
>> +       if (!em || IS_ERR(em)) {
>>                __unplug_io_fn(bdi, page);
>>                return;
>>        }
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknbZysACgkQLPWxlyuTD7K0IQCgiZSrwJWtZCG3uRDAKjEPTBeT
qX8AnjaMRgZ9mqw6icQlGNCfOeYGHvO7
=d73O
-----END PGP SIGNATURE-----
