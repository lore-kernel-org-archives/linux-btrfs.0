From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] Btrfs: support security xattr with SELinux enabled
Date: Wed, 7 Jan 2009 19:47:29 -0500
Message-ID: <20090108004728.GJ5266@unused.rdu.redhat.com>
References: <49650E5A.3030602@hp.com> <20090107204846.GG5266@unused.rdu.redhat.com> <49654762.5050308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49654762.5050308@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2009 at 07:22:58PM -0500, jim owens wrote:
> Josef Bacik wrote:
>> On Wed, Jan 07, 2009 at 03:19:38PM -0500, jim owens wrote:
>>> +int btrfs_xattr_security_init(struct inode *inode, struct inode *dir)
>>> +{
>>> +	int err;
>>> +	size_t len;
>>> +	void *value;
>>> +	char *suffix;
>>> +	char *name;
>>> +
>>> +	err = security_inode_init_security(inode, dir, &suffix, &value, &len);
>>> +	if (err) {
>>> +		if (err == -EOPNOTSUPP)
>>> +			return 0;
>>> +		return err;
>>> +	}
>>> +
>>> +	name = kmalloc(XATTR_SECURITY_PREFIX_LEN + strlen(suffix) + 1,
>>> +		       GFP_NOFS);
>>
>> Use kzalloc here otherwise the end of name could be some random thing and
>> strlen() will read past the end of the memory.  Thanks,
>
> I don't understand what you think can happen...
>
> +        strcpy(name, XATTR_SECURITY_PREFIX);
> +        strcpy(name + XATTR_SECURITY_PREFIX_LEN, suffix);
>
> always forces "name" to be \0 terminated.
>

Oh derr sorry I forget suffix is \0 terminated.  Nevermind.

Josef
