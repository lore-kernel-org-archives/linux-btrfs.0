Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57362 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757368AbaEIUpL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 16:45:11 -0400
Message-ID: <536D3E51.80209@fb.com>
Date: Fri, 9 May 2014 16:45:05 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add a extent ref verify tool V2
References: <1399582528-24698-1-git-send-email-jbacik@fb.com> <20140508233414.GC12210@lenny.home.zabbo.net>
In-Reply-To: <20140508233414.GC12210@lenny.home.zabbo.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2014 07:34 PM, Zach Brown wrote:
>> +#ifdef CONFIG_BTRFS_FS_REF_VERIFY
>> +int btrfs_build_ref_tree(struct btrfs_fs_info *fs_info);
>> +void btrfs_free_ref_cache(struct btrfs_fs_info *fs_info);
>> +int btrfs_ref_tree_mod(struct btrfs_root *root, u64 bytenr, u64 num_bytes,
>> +		       u64 parent, u64 ref_root, u64 owner, u64 offset,
>> +		       int action);
>> +void btrfs_free_ref_tree_range(struct btrfs_fs_info *fs_info, u64 start,
>> +			       u64 len);
>> +#else
>> +
>> +#define btrfs_free_ref_cache(fs_info) do { } while (0)
>> +#define btrfs_ref_tree_mod(root, bytenr, num_bytes, parent, ref_root,	\
>> +			   owner, offset, action) do { } while (0)
>> +#define btrfs_free_ref_tree_range(fs_info, start, len) do { } while (0)
>> +
>> +#endif /* CONFIG_BTRFS_FS_REF_VERIFY */
>> +#endif /* _REF_VERIFY__ */
>
> Don't just omit the arguments when the config isn't enabled.  That can
> let these calls bit rot over time as everyone build tests their changes
> with the config disabled, as they will.
>
> 	int derp;
>
> 	...
>
> 	btrfs_free_ref_cache(derp);
>
> 	...
>
> -	derp++;
>
>
> Will have gcc warn that derp is unused.  They'll delete it and send out
> the patch.  You'll later turn on the config and get undefined derp
> warnings.
>
> inline stubs are the best way out.  They'll still warn if the arg is
> used undefined.  Putting (void)arg; in the macros doesn't warn in that
> case.

Gcc doesn't complain when I build with it off but I can switch to inline 
stubs if that makes you feel better.  Thanks,

Josef

