From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/2] Btrfs: load the key from the dir item in readdir
 into a fake dentry
Date: Thu, 26 May 2011 15:02:42 -0400
Message-ID: <4DDEA3D2.3080907@redhat.com>
References: <1306421316-1504-2-git-send-email-josef@redhat.com> <m2fwo19tzp.fsf@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m2fwo19tzp.fsf@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/26/2011 02:50 PM, Andi Kleen wrote:
> Josef Bacik <josef@redhat.com> writes:
>> +
>> +				newkey = kzalloc(sizeof(struct btrfs_key),
>> +						 GFP_NOFS);
>> +				if (!newkey)
>> +					goto no_dentry;
>> +				tmp = d_alloc(filp->f_dentry, &q);
> 
> This doesn't seem to address the "find / fills all memory with dentries"
> concerns brought up earlier at all.
> 

Nope, this part does in patch 1/1

+	/*
+	 * If this dentry needs lookup, don't set the referenced flag so that it
+	 * is more likely to be cleaned up by the dcache shrinker in case of
+	 * memory pressure.
+	 */
+	if (!d_need_lookup(dentry))
+		dentry->d_flags |= DCACHE_REFERENCED;


> d_alloc uses a normal GFP_KERNEL, which is quite in appropiate for this.
> 
> It should at least reclaim and probably more, but even then it's
> risky.
> 

Ah yeah I guess I should have probably used GFP_KERNEL.  Sorry about that,

Josef
