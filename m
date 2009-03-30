From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: PATCH] btrfs: Check transaction start
Date: Mon, 30 Mar 2009 13:44:23 -0400
Message-ID: <49D104F7.9040007@suse.com>
References: <499392D4.5020709@suse.com> <873acunc4f.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <873acunc4f.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
>>  		wake_up_process(root->fs_info->cleaner_kthread);
>> @@ -2197,10 +2199,12 @@ int btrfs_commit_super(struct btrfs_root
>>  	btrfs_clean_old_snapshots(root);
>>  	mutex_unlock(&root->fs_info->cleaner_mutex);
>>  	trans = btrfs_start_transaction(root, 1);
>> +	BUG_ON(IS_ERR(trans));
> 
> Would it make sense to use a different macro for things that
> are expected to be fixed later? BUG_ON_I_SUCK() or TMP_BUG_ON() or 
> something like that?
> I think that would make it clearer that things are only temporary.
> At least it should be documented somewhere.

Yeah, that's a good idea. I'll update the patch set.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknRBPYACgkQLPWxlyuTD7LYiACdE/x30BaKpCvWEXwXYfnRBgMl
EZ0An2VDeUGM12PXFcKgUxzNSbScQ3hA
=yzWl
-----END PGP SIGNATURE-----
